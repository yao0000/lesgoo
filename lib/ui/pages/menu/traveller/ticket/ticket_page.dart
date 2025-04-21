import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/global.dart';
import 'package:travel/data/models/car_model.dart';
import 'package:travel/data/models/index.dart';
import 'package:travel/data/repositories/flight_repository.dart';
import 'package:travel/data/repositories/index.dart';
import 'package:travel/data/repositories/user_repository.dart';
import 'package:travel/ui/widgets/container_no_data.dart';

class TicketPage extends StatefulWidget {
  final String userUid;
  const TicketPage({super.key, required this.userUid});

  @override
  State<StatefulWidget> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  late String userUid;
  int selectedIndex = 0;
  final List<String> categories =
      Global.user.role == "admin"
          ? ["Hotel", "Restaurant", "Cars"]
          : ["Flights", "Hotel", "Restaurant", "Cars"];
  List<dynamic> list = [];

  @override
  void initState() {
    super.initState();
    userUid = widget.userUid;
    _loadList();
  }

  Future<void> _loadList() async {
    List<dynamic>? fetchList = [];
    if (Global.user.role == "user") {
      switch (selectedIndex) {
        case 0:
          {
            fetchList = await FlightBookingRepository.getListByUser(userUid);
            break;
          }
        case 1:
          {
            fetchList = await HotelBookingRepository.getListByUser(userUid);
            break;
          }
        case 2:
          {
            fetchList = await RestaurantBookingRepository.getListByUser(
              userUid,
            );
            break;
          }
        case 3:
          {
            fetchList = await CarBookingRepository.getListByUser(userUid);
            break;
          }
        default:
          {}
      }
    } else {
      switch (selectedIndex) {
        case 0:
          {
            fetchList = await HotelBookingRepository.getListByUser(userUid);
            break;
          }
        case 1:
          {
            fetchList = await RestaurantBookingRepository.getListByUser(
              userUid,
            );
            break;
          }
        case 2:
          {
            fetchList = await CarBookingRepository.getListByUser(userUid);
            break;
          }
        default:
          {}
      }
    }

    setState(() {
      list = fetchList ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Global.user.role == "admin" ? AppColors.adminBg : AppColors.bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Your Ticket"),
        backgroundColor: Global.user.role == "admin" ? AppColors.adminBg : AppColors.bgColor,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(categories.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    _loadList();
                    if (Global.user.notifications[index]) {
                      Global.user.notifications[index] = false;
                      UserRepository.update();
                      Global.updateNotifications();
                    }
                  },
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    selectedIndex == index
                                        ? Colors.amber
                                        : AppColors.navyBlue,
                                width: 2.0,
                              ),
                            ),
                            child: Text(
                              categories[index],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.navyBlue,
                              ),
                            ),
                          ),
                          if (Global.user.notifications[index] &&
                              userUid == Global.user.uid)
                            Positioned(
                              right: -4,
                              top: -4,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child:
                list.isEmpty
                    ? noDataScreen("No booking for now")
                    : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return _buildTicketCard(list[index]);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(dynamic bookingItem) {
    String image = "";
    String date = "";
    DateFormat df = DateFormat("d/M");

    if (bookingItem is HotelBookingModel) {
      image = 'assets/img/Hotels.png';
      date = df.format(bookingItem.startDate.toLocal());
    } else if (bookingItem is RestaurantBookingModel) {
      image = 'assets/img/Restaurant.png';
      date = df.format(bookingItem.time.toLocal());
    } else if (bookingItem is CarBookingModel) {
      image = 'assets/img/Car.png';
      date = df.format(bookingItem.startDate.toLocal());
    } else if (bookingItem is FlightBookingModel) {
      image = "assets/img/Flights.png";
      date = df.format(DateTime.parse(bookingItem.departureDate));
    }

    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: () async {
          if (bookingItem is FlightBookingModel) {
            GoRouter.of(
              context,
            ).push('/boardingPass', extra: {'bookingItem': bookingItem});
            return;
          }
          bool? isDelete = await GoRouter.of(
            context,
          ).push('/ticketDetail', extra: {'bookingItem': bookingItem});

          if (isDelete == true) {
            _loadList();
          }
        },
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(child: Image.asset(image, width: 28, height: 28)),
        ),
        title: Text(
          "Booking Confirmation",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hi ${Global.user.name}, Congratulations on booking..."),
            Align(
              alignment: Alignment.centerRight,
              child: Text(date, style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}

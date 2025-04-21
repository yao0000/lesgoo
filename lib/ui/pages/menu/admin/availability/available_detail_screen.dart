import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/global.dart';
import 'package:travel/data/models/car_model.dart';
import 'package:travel/data/models/function.dart';

import 'package:travel/data/models/index.dart';
import 'package:travel/data/repositories/index.dart';
import 'package:travel/data/repositories/user_repository.dart';

class AvailableDetailScreen extends StatefulWidget {
  final dynamic item;
  const AvailableDetailScreen({super.key, required this.item});

  @override
  State<StatefulWidget> createState() => _AvailableDetailState();
}

class _AvailableDetailState extends State<AvailableDetailScreen> {
  late dynamic item;
  List<dynamic> list = [];
  List<UserModel> userList = [];

  @override
  void initState() {
    super.initState();
    item = widget.item;
    _loadList();
  }

  void _loadList() async {
    await _loadUser();
    List<dynamic> fetchList = [];
    if (item is HotelModel) {
      fetchList = await HotelBookingRepository.getListByHotelId(item.uid);
    } else if (item is RestaurantModel) {
      fetchList = await RestaurantBookingRepository.getListById(item.uid);
    } else if (item is CarModel) {
      fetchList = await CarBookingRepository.getListById(item.uid);
    }

    setState(() {
      list = fetchList;
    });
  }

  Future<void> _loadUser() async {
    List<UserModel> fetchList = [];
    fetchList = await UserRepository.getList();
    setState(() {
      userList = fetchList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
            },
          ),
        ),
      body: Padding(
        padding: EdgeInsets.only(top: 0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: AppColors.adminBg,
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 10, top: 10),
                child: Center(
                  child: Image.network(
                    getAttribute(item, 'imageUrl'),
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getAttribute(item, 'name'),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.navyBlue,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              getAttribute(item, 'price'),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            _sectionContent(_getUnit()),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 15, bottom: 10),
                      child: Text(
                        "Booked Slot",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Text(
                      "Number of bookings: ${list.length}",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    if (list.isNotEmpty)
                      ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return _buildBookingCard(list[index]);
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionContent(String text) {
    return Text(text, style: TextStyle(color: Colors.black54));
  }

  String _getUnit() {
    if (item is HotelModel) {
      return "1 Night";
    } else if (item is RestaurantModel) {
      return "1 Pax";
    } else if (item is CarModel) {
      return "1 Day";
    }
    return "";
  }

  Widget _buildBookingCard(dynamic booking) {
    return Card(
      color: Color(0xFF9AACC7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              "assets/img/acc_tick.png",
              width: 28,
              height: 28,
              color: AppColors.navyBlue,
            ),
          ),
        ),
        title: Text(
          userList.firstWhere((item) => item.uid == booking.userUid).name,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getInfo(booking),
        ),
      ),
    );
  }

  List<Widget> getInfo(dynamic booking) {
    if (item is HotelModel) {
      return getHotelBookingInfo(booking);
    } else if (item is RestaurantModel) {
      return getRestaurantBookingInfo(booking);
    } else {
      return getCarBookingInfo(booking);
    }
  }

  List<Widget> getHotelBookingInfo(dynamic booking) {
    HotelBookingModel model = booking as HotelBookingModel;
    return [
      _getLabel(
        "Start Date: ${model.startDate.toLocal().toIso8601String().split('T')[0]}",
      ),
      _getLabel(
        "End Date: ${model.endDate.toLocal().toIso8601String().split('T')[0]}",
      ),
      _getLabel("Duration: ${model.totalDays}"),
      _getLabel("Rooms: ${model.roomCount}"),
      _getLabel("Amount: ${model.amount}"),
    ];
  }

  List<Widget> getRestaurantBookingInfo(dynamic booking) {
    RestaurantBookingModel model = booking as RestaurantBookingModel;
    return [
      _getLabel(
        "Date: ${model.time.toLocal().toIso8601String().split('T')[0]}",
      ),
      _getLabel("Time: ${DateFormat.jm().format(model.time.toLocal())}"),
      _getLabel("Pax: ${model.pax}"),
      _getLabel("Amount: ${model.amount}"),
    ];
  }

  List<Widget> getCarBookingInfo(dynamic booking) {
    CarBookingModel model = booking as CarBookingModel;
    return [
      _getLabel(
        "Start Date: ${model.startDate.toLocal().toIso8601String().split('T')[0]}",
      ),
      _getLabel(
        "End Date: ${model.endDate.toLocal().toIso8601String().split('T')[0]}",
      ),
      _getLabel("Duration: ${model.daysCount}"),
      _getLabel("Amount: ${model.amount}"),
    ];
  }

  Widget _getLabel(String label) {
    return Text(label);
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/global.dart';
import 'package:travel/data/models/car_model.dart';
import 'package:travel/data/models/function.dart';
import 'package:travel/data/models/index.dart';
import 'package:travel/data/repositories/car_repository.dart';
import 'package:travel/data/repositories/hotel_repository.dart';
import 'package:travel/data/repositories/restaurant_repository.dart';
import 'package:travel/ui/pages/menu/common/function.dart';
import 'package:travel/ui/pages/menu/traveller/discover/booking_screen.dart';
import 'package:travel/ui/widgets/widgets.dart';

class TicketDetailsScreen extends StatefulWidget {
  final dynamic bookingItem;
  const TicketDetailsScreen({super.key, required this.bookingItem});

  @override
  State<StatefulWidget> createState() => _TicketDetailsScreen();
}

class _TicketDetailsScreen extends State<TicketDetailsScreen> {
  Stream<dynamic>? itemStream;
  dynamic item;
  dynamic bookingItem;
  int selectedRate = 5;

  @override
  void initState() {
    super.initState();
    bookingItem = getItem(widget.bookingItem);
    itemStream = _loadItemDetails();
  }

  Future<void> _deleteBooking() async {
    bool? confirm = await showConfirmationDialog(
      context,
      "Are you sure ?",
      "The system will cancel the bookings",
    );

    if (confirm == null || !confirm) {
      return;
    }

    bool isSucess = false;
    if (bookingItem is HotelBookingModel) {
      isSucess = await HotelBookingRepository.delete(uid: bookingItem.bookingUid);
    } else if (bookingItem is RestaurantBookingModel) {
      isSucess = await RestaurantBookingRepository.delete(uid: bookingItem.bookingUid);
    } else if (bookingItem is CarBookingModel) {
      isSucess = await CarBookingRepository.delete(uid: bookingItem.bookingUid);
    }

    if (isSucess) {
      context.pop(true);
    }
  }

  Stream<dynamic> _loadItemDetails() {
    if (bookingItem is HotelBookingModel) {
      return Stream.fromFuture(
        HotelRepository.getItem(bookingItem.itemUid.toString()),
      );
    } else if (bookingItem is RestaurantBookingModel) {
      return Stream.fromFuture(
        RestaurantRepository.getItem(bookingItem.itemUid.toString()),
      );
    } else if (bookingItem is CarBookingModel) {
      return Stream.fromFuture(
        CarRepository.getItem(bookingItem.itemUid.toString()),
      );
    }
    return const Stream.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booking Confirmation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<dynamic>(
          stream: itemStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return noDataScreen("No Data Available");
            }

            item = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(bottom: 10),
                    child: Center(
                      child: Image.network(
                        getAttribute(item, 'imageUrl'),
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Booking Summary',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildInfoSection(),
                  const SizedBox(height: 25),
                  _buildVerticalInfoGrp(
                    Icons.confirmation_number,
                    'Booking ID',
                    bookingItem.itemUid.toString(),
                  ),
                  const SizedBox(height: 20),
                  _buildBookingInfoSection(),
                  const SizedBox(height: 25),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailsSection(),
                        Divider(),
                        buildDetailRow(
                          "Total Amount",
                          bookingItem.amount.toString(),
                        ),
                      ],
                    ),
                  ),
                  if (Global.user.role == "user") _buildRatingSection(),
                  const SizedBox(height: 15),
                  if (Global.user.role == "user")
                    Center(
                      child: ButtonAction(
                        label: "Close",
                        onPressed: () {
                          context.go('/home');
                        },
                      ),
                    ),
                  if (Global.user.role == "admin")
                  Center(child: ButtonAction(label: "Delete Booking", btnColor: Colors.red, onPressed: () => _deleteBooking()),)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    if (bookingItem is HotelBookingModel ||
        bookingItem is RestaurantBookingModel) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getAttribute(item, 'name'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              buildIconInfo(
                Icons.star,
                getAttribute(item, 'rating'),
                iconColor: Colors.yellow,
              ),
              SizedBox(width: 10),
              buildIconInfo(
                Icons.location_on,
                getAttribute(item, 'address'),
                isOverflow: true,
              ),
            ],
          ),
        ],
      );
    } else if (bookingItem is CarBookingModel) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getAttribute(item, 'plate'),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                getAttribute(item, 'name'),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildIconInfo(Icons.location_on, getAttribute(item, 'address')),
              buildIconInfo(Icons.timer, "12:00 P.M."),
            ],
          ),
        ],
      );
    }
    return Container();
  }

  Widget _buildBookingInfoSection() {
    if (bookingItem is HotelBookingModel) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildVerticalInfoGrp(
            Icons.calendar_today,
            'Check In',
            DateFormat("d/M/yyyy").format(bookingItem.startDate.toLocal()),
          ),

          _buildVerticalInfoGrp(
            Icons.calendar_today,
            'Check Out',
            DateFormat("d/M/yyyy").format(bookingItem.endDate.toLocal()),
          ),
        ],
      );
    } else if (bookingItem is RestaurantBookingModel) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildVerticalInfoGrp(
            Icons.calendar_today,
            'Dining Date',
            DateFormat("d/M/yyyy").format(bookingItem.time.toLocal()),
          ),
          _buildVerticalInfoGrp(
            Icons.timer,
            'Dining Time',
            DateFormat("hh:mm a").format(bookingItem.time.toLocal()),
          ),
        ],
      );
    } else if (bookingItem is CarBookingModel) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildVerticalInfoGrp(
            Icons.calendar_today,
            'Pickup Date',
            DateFormat("d/M/yyyy").format(bookingItem.startDate.toLocal()),
          ),
          _buildVerticalInfoGrp(
            Icons.calendar_today,
            'Return Date',
            DateFormat("d/M/yyyy").format(bookingItem.endDate.toLocal()),
          ),
        ],
      );
    }
    return Container();
  }

  Widget _buildDetailsSection() {
    if (bookingItem is HotelBookingModel) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDetailRow("Room", getAttribute(item, "price")),
          buildDetailRow("Night", bookingItem.totalDays.toString()),
        ],
      );
    } else if (bookingItem is RestaurantBookingModel) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDetailRow("Price per pax", getAttribute(item, "price")),
          buildDetailRow("Number of pax", bookingItem.pax.toString()),
        ],
      );
    } else if (bookingItem is CarBookingModel) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDetailRow("Car Type", getAttribute(item, 'name')),
          buildDetailRow("Car Place", getAttribute(item, 'plate')),
          buildDetailRow("Days", bookingItem.daysCount.toString()),
          buildDetailRow("Price", bookingItem.amount.toString()),
        ],
      );
    }
    return Container();
  }

  Widget _buildRatingSection() {
    bool isPast = false;
    if (bookingItem is HotelBookingModel) {
      isPast = DateTime.now().isAfter(bookingItem.endDate);
    } else if (bookingItem is RestaurantBookingModel) {
      isPast = DateTime.now().isAfter(bookingItem.time);
    } else if (bookingItem is CarBookingModel) {
      DateTime time = DateTime(
        bookingItem.endDate.toLocal().year,
        bookingItem.endDate.toLocal().month,
        bookingItem.endDate.toLocal().day,
        12,
        0,
      );
      isPast = DateTime.now().isAfter(time);
    }

    if (!isPast) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          'Rate Us',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (index) => GestureDetector(
              onTap: () {
                showToast("Rating Successfully");
                setState(() {
                  selectedRate = index + 1;
                });
              },
              child: Icon(
                Icons.star,
                color: index < selectedRate ? Colors.amber : Colors.black54,
                size: 32,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalInfoGrp(IconData icon, String iconLabel, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildIconInfo(icon, iconLabel, iconColor: AppColors.navyBlue),
        const SizedBox(height: 10),
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:travel/data/global.dart';
import 'package:travel/data/models/function.dart';
import 'package:travel/data/models/index.dart';
import 'package:travel/data/repositories/car_repository.dart';
import 'package:travel/data/repositories/hotel_repository.dart';
import 'package:travel/data/repositories/restaurant_repository.dart';
import 'package:travel/data/repositories/user_repository.dart';
import 'package:travel/services/firebase_auth_service.dart';
import 'package:travel/services/local_notification.dart';
import 'package:travel/ui/widgets/widgets.dart';

class BookingScreen extends StatefulWidget {
  final dynamic item;

  const BookingScreen({super.key, required this.item});

  @override
  State<StatefulWidget> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? selectedTime;
  int totalDays = 0;
  int count = 1;

  DateTime _getDefaultDateTime(bool isStartDate) {
    if (isStartDate && startDate != null) {
      return startDate!;
    } else if (!isStartDate && endDate != null) {
      return endDate!;
    }
    return DateTime.now();
  }

  Future<void> _datePicker(bool isStartDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _getDefaultDateTime(isStartDate),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked == null) {
      return;
    }

    // date comparison restriction
    bool isInvalid = false;
    if (isStartDate && endDate != null) {
      int difference = endDate!.difference(picked).inDays;
      isInvalid = difference < 0;
    } else if (!isStartDate && startDate != null) {
      int difference = picked.difference(startDate!).inDays;
      isInvalid = difference < 0;
    }

    if (isInvalid) {
      showMessageDialog(
        context: context,
        title: "Opps",
        message: "End date must bigger than start date",
      );
      return;
    }

    setState(() {
      if (isStartDate) {
        startDate = picked;
      } else {
        endDate = picked;
      }
    });

    if (startDate != null && endDate != null) {
      int difference = endDate!.difference(startDate!).inDays;
      setState(() {
        if (getItem(widget.item) is HotelModel) {
          if (difference == 0) {
            totalDays = 1;
          } else {
            totalDays = difference;
          }
        } else {
          totalDays = difference + 1;
        }
      });
    }
  }

  Future<void> _timePicker() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _booking() async {
    dynamic item = getItem(widget.item);

    dynamic bookingItem;
    bool isSuccess = false;

    if (item is HotelModel) {
      if (startDate == null || endDate == null) {
        showMessageDialog(
          context: context,
          title: "Opps",
          message: "Date are required",
        );
        return;
      }

      bookingItem = HotelBookingModel(
        itemUid: item.uid.toString(),
        userUid: AuthService.getCurrentUser()!.uid,
        startDate: startDate!.toUtc(),
        endDate: endDate!.toUtc(),
        roomCount: count,
        totalDays: totalDays,
        amount: _getTotalPrice(),
      );
    } else if (item is RestaurantModel) {
      if (startDate == null) {
        showMessageDialog(
          context: context,
          title: "Opps",
          message: "Date is required",
        );
        return;
      }

      if (selectedTime == null) {
        showMessageDialog(
          context: context,
          title: "Opps",
          message: "Time is required",
        );
        return;
      }

      bookingItem = RestaurantBookingModel(
        itemUid: item.uid.toString(),
        userUid: AuthService.getCurrentUser()!.uid,
        time:
            DateTime(
              startDate!.year,
              startDate!.month,
              startDate!.day,
              selectedTime!.hour,
              selectedTime!.minute,
            ).toUtc(),
        pax: count,
        amount: _getTotalPrice(),
      );
    } else {
      if (startDate == null || endDate == null) {
        showMessageDialog(
          context: context,
          title: "Opps",
          message: "Date are required",
        );
        return;
      }

      bookingItem = CarBookingModel(
        itemUid: item.uid.toString(),
        userUid: AuthService.getCurrentUser()!.uid,
        startDate: startDate!.toUtc(),
        endDate: endDate!.toUtc(),
        daysCount: totalDays,
        amount: _getTotalPrice(),
      );
    }

    showLoadingDialog(context, "Posting in progress...");
    if (bookingItem is HotelBookingModel) {
      isSuccess = await HotelBookingRepository.post(data: bookingItem);
    } else if (bookingItem is RestaurantBookingModel) {
      isSuccess = await RestaurantBookingRepository.post(data: bookingItem);
    } else {
      isSuccess = await CarBookingRepository.post(data: bookingItem);
    }

    Navigator.pop(context);
    if (isSuccess) {
      String sName = "";
      String sDate = "";
      if (bookingItem is HotelBookingModel) {
        Global.user.notifications[1] = true;
        sName = "hotel";
        sDate = DateFormat("d/M/yyyy").format(bookingItem.startDate.toLocal());
      } else if (bookingItem is RestaurantBookingModel) {
        Global.user.notifications[2] = true;
        sName = "restaurant";
        sDate = DateFormat("d/M/yyyy").format(bookingItem.time.toLocal());
      } else if (bookingItem is CarBookingModel) {
        Global.user.notifications[3] = true;
        sName = "cars";
        sDate = DateFormat("d/M/yyyy").format(bookingItem.startDate.toLocal());
      }
      UserRepository.update();
      Global.updateNotifications();

      showNotification(
        "Hi ${Global.user.name}, your booking for $sName on $sDate has been successfully confirmed. You can view the full details in Ticket",
      );
      showToast("Booking successfully");
      GoRouter.of(
        context,
      ).push('/paymentSuccess', extra: {'bookingItem': bookingItem});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Choose your date"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _boldText("Selected Dates"),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: _buildPeriodSection(),
            ),
            SizedBox(height: 20),
            _boldText(_getSectionTitle()),
            SizedBox(height: 20),
            _buildCountSection(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: _buildDetailsSection(),
            ),
            SizedBox(height: 30),
            buildDetailRow("Total Amount", _getTotalPrice()),
            SizedBox(height: 30),
            Center(
              child: ButtonAction(
                label: "Book Now!",
                onPressed: () => _booking(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSection() {
    dynamic item = getItem(widget.item);
    double screenWidth = MediaQuery.of(context).size.width;

    if (item is HotelModel || item is CarModel) {
      return Column(
        children: [
          Row(
            children: [
              _boldText("Start Date"),
              SizedBox(width: screenWidth * 0.35),
              _boldText("End Date"),
            ],
          ),
          Row(
            children: [
              _buildDatePicker(startDate, true),
              SizedBox(width: screenWidth * 0.05),
              Icon(Icons.arrow_right_alt),
              SizedBox(width: screenWidth * 0.05),
              _buildDatePicker(endDate, false),
            ],
          ),
        ],
      );
    } else if (item is RestaurantModel) {
      return Column(
        children: [
          Row(
            children: [
              _boldText("Start Date"),
              SizedBox(width: screenWidth * 0.35),
              _boldText("Time"),
            ],
          ),
          Row(
            children: [
              _buildDatePicker(startDate, true),
              SizedBox(width: screenWidth * 0.15),
              GestureDetector(
                onTap: () => _timePicker(),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.black54),
                    const SizedBox(width: 8),
                    Text(
                      selectedTime != null ? _get24HourFormat() : "XX:XX",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }
    return Container();
  }

  Widget _buildDatePicker(DateTime? date, bool isStartDate) {
    return GestureDetector(
      onTap: () => _datePicker(isStartDate),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 16),
            SizedBox(width: 8),
            Text(
              date != null
                  ? "${date.day}-${date.month}-${date.year}"
                  : "DD-MM-YYY",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountSection() {
    if (getItem(widget.item) is CarModel) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCountLabel(),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle_outline),
                onPressed:
                    count > 1
                        ? () {
                          setState(() {
                            count--;
                          });
                        }
                        : null,
              ),
              Text("$count"),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () {
                  setState(() {
                    count++;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountLabel() {
    dynamic item = getItem(widget.item);

    if (item is HotelModel) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _boldText("Room"),
          SizedBox(height: 10),
          Text(
            "One room fit\n2 adults and 1 child",
            style: TextStyle(color: Colors.black54),
          ),
        ],
      );
    } else if (item is RestaurantModel) {
      return _boldText("Number of pax");
    } else if (item is CarModel) {
      return _boldText("Days");
    }

    return Container();
  }

  Widget _buildDetailsSection() {
    dynamic item = getItem(widget.item);

    if (item is HotelModel) {
      return Column(
        children: [
          buildDetailRow("Room", getAttribute(item, "price", count: count)),
          buildDetailRow("Night", totalDays.toString()),
        ],
      );
    } else if (item is RestaurantModel) {
      return Column(
        children: [
          buildDetailRow("Price per pax", getAttribute(item, "price")),
          buildDetailRow("Number of pax", count.toString()),
        ],
      );
    } else if (item is CarModel) {
      return Column(
        children: [
          buildDetailRow("Car Type", getAttribute(item, 'name')),
          buildDetailRow("Car Place", getAttribute(item, 'plate')),
          buildDetailRow("Days", totalDays.toString()),
          buildDetailRow("Price", getAttribute(item, 'price')),
        ],
      );
    }
    return Container();
  }

  Widget _boldText(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  String _getSectionTitle() {
    dynamic item = getItem(widget.item);

    if (item is HotelModel) {
      return "Who is travelling?";
    } else if (item is RestaurantModel) {
      return "Who is dining?";
    } else if (item is CarModel) {
      return "How many days your rent?";
    }
    return "";
  }

  String _getTotalPrice() {
    dynamic item = getItem(widget.item);
    int quantity = 0;
    if (item is HotelModel) {
      quantity = count * totalDays;
    } else if (item is RestaurantModel) {
      quantity = count;
    } else if (item is CarModel) {
      quantity = totalDays;
    }
    return getPriceFormat(item, quantity);
  }

  String _get24HourFormat() {
    return '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}';
  }
}

Widget buildDetailRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Text(value, style: TextStyle(color: Colors.blue)),
      ],
    ),
  );
}

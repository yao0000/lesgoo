import 'package:flutter/material.dart';
import 'package:travel/data/models/car_model.dart';
import 'package:travel/data/models/index.dart';
import 'package:travel/data/repositories/hotel_repository.dart';
import 'package:travel/services/firebase_auth_service.dart';
import 'package:travel/ui/widgets/widgets.dart';
import 'package:travel/data/models/function.dart';

class HotelBookingScreen extends StatefulWidget {
  final dynamic item;

  const HotelBookingScreen({super.key, required this.item});

  @override
  State<StatefulWidget> createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen> {
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? selectedTime;

  int count = 1;

  Future<void> _booking() async {
    var item = widget.item;
    if (item is Map) {
      item = item.entries.first.value;
    }

    bool isSuccess = false;
    if (item is HotelModel) {
      isSuccess = await _postHotelBooking(item);
    } else if (item is RestaurantModel) {}

    if (isSuccess) {
      showToast("Booking successfully");
    }
  }

  Future<bool> _postHotelBooking(dynamic item) async {
    if (startDate == null || endDate == null) {
      showMessageDialog(
        context: context,
        title: "Error",
        message: "Date are required",
      );
      return false;
    }

    bool isSuccess = await HotelBookingRepository.post(
      hotelUid: item.uid.toString(),
      userUid: AuthService.getCurrentUser()!.uid,
      startDate: startDate!.toUtc(),
      endDate: endDate!.toUtc(),
      roomCount: count,
      totalPrice: getPriceFormat(item, count),
    );

    return isSuccess;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
    if (startDate != null) {
      print(startDate);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
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
            Text(
              "Selected Dates",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: _buildPeriodSection(),
            ),
            SizedBox(height: 20),
            Text(_getTitle(), style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.item.entries.first.value is HotelModel)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Room",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "One room fit\n2 adults and 1 child",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                if (widget.item.entries.first.value is! HotelModel)
                  Row(
                    children: [
                      Text(
                        _getUnit(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
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
            SizedBox(height: 20),
            _sectionDetails(),
            SizedBox(height: 20),
            _buildPriceRow("Total Amount", getPriceFormat(widget.item, count)),
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

  Widget _buildDatePicker(String label, DateTime? date, bool isStartDate) {
    return GestureDetector(
      onTap: () => _selectDate(context, isStartDate),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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

  Widget _buildPriceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0).copyWith(right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }

  Widget _buildPeriodSection() {
    dynamic item = widget.item;
    if (item is Map) {
      item = item.entries.first.value;
    }

    if (item is RestaurantModel) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Date"), const Text("Time")],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDatePicker("Start Date", startDate, true),
              Icon(Icons.arrow_right_alt),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text(
                    selectedTime != null
                        ? selectedTime!.format(context)
                        : "XX:XX",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }
    // Hotel and Transportation reuse the same panel
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [const Text("Start Date"), const Text("End Date")],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDatePicker("Start Date", startDate, true),
            Icon(Icons.arrow_right_alt),
            _buildDatePicker("End Date", endDate, false),
          ],
        ),
      ],
    );
  }

  Widget _sectionDetails() {
    dynamic item = widget.item;
    if (item is Map) {
      item = item.entries.first.value;
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item is HotelModel) ...[
            _buildPriceRow("Room", getAttribute(widget.item, 'price')),
            _buildPriceRow('Nights', count.toString()),
          ],
          if (item is RestaurantModel) ...[
            _buildPriceRow("Price per pax", getAttribute(widget.item, 'price')),
            _buildPriceRow('Number of pax', count.toString()),
          ],
          if (item is CarModel) ...[
            _buildPriceRow('Car Type', getAttribute(item, 'name')),
            _buildPriceRow('Car Plate', getAttribute(item, 'plate')),
            _buildPriceRow('Days', count.toString()),
            _buildPriceRow('Price', getAttribute(widget.item, 'price')),
          ]
        ],
      ),
    );
  }

  String _getUnit() {
    dynamic item = widget.item;
    if (item is Map) {
      item = item.entries.first.value;
    }

    if (item is HotelModel) {
      return "Nights";
    } else if (item is RestaurantModel) {
      return "Number of pax";
    } else if (item is CarModel) {
      return "Days";
    } else {
      return "";
    }
  }

  String _getTitle() {
    dynamic item = widget.item;
    if (item is Map) {
      item = item.entries.first.value;
    }

    if (item is HotelModel) {
      return "Who is travelling?";
    } else if (item is RestaurantModel) {
      return "Who is dining?";
    } else if (item is CarModel) {
      return "How many days your rent?";
    } else {
      return "";
    }
  }
}

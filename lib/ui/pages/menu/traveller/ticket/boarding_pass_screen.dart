import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/global.dart';
import 'package:travel/data/models/flight_model.dart';
import 'package:travel/ui/widgets/button_action.dart';

class BoardingPassScreen extends StatelessWidget {
  final FlightBookingModel bookingModel;

  const BoardingPassScreen({super.key, required this.bookingModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),
            const Text(
              'Boarding Pass',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.navyBlue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      Text(
                        Global.user.name,
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (bookingModel.isRoundTrip)
                                Text(
                                  bookingModel.departureDate,
                                  style: TextStyle(color: Colors.white70),
                                ),
                              if (bookingModel.isRoundTrip)
                                Text(
                                  bookingModel.departureTrip!.departureTime,
                                  style: TextStyle(color: Colors.white70),
                                ),
                              const SizedBox(height: 5),
                              Text(
                                bookingModel.departure,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                bookingModel.returnDate,
                                style: TextStyle(color: Colors.white70),
                              ),
                              Text(
                                bookingModel.isRoundTrip
                                    ? bookingModel.returnTrip!.arrivalTime
                                    : bookingModel.departureTrip!.departureTime,
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          Image.asset(
                            bookingModel.isRoundTrip
                                ? "assets/img/trip_return.png"
                                : "assets/img/trip_one_way.png",
                            width: 30,
                            height: 30,
                            color: Colors.white,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (bookingModel.isRoundTrip)
                                Text(
                                  bookingModel.departureDate,
                                  style: TextStyle(color: Colors.white70),
                                ),
                              if (bookingModel.isRoundTrip)
                                Text(
                                  bookingModel.departureTrip!.arrivalTime,
                                  style: TextStyle(color: Colors.white70),
                                ),
                              const SizedBox(height: 5),
                              Text(
                                bookingModel.destination,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                bookingModel.isRoundTrip
                                    ? bookingModel.returnDate
                                    : bookingModel.returnDate,
                                style: TextStyle(color: Colors.white70),
                              ),
                              Text(
                                bookingModel.isRoundTrip
                                    ? bookingModel.returnTrip!.departureTime
                                    : bookingModel.departureTrip!.arrivalTime,
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoColumn('Gate', 'T08'),
                          _infoColumn('Seat', '18'),
                          _infoColumn('Flights', '08C'),
                          _infoColumn('Class', bookingModel.type),
                        ],
                      ),
                      const SizedBox(height: 15),
                      if (bookingModel.isRoundTrip)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _infoColumn('Gate', 'T08'),
                            _infoColumn('Seat', '18'),
                            _infoColumn('Flights', '08C'),
                            _infoColumn('Class', bookingModel.type),
                          ],
                        ),
                      const SizedBox(height: 30),
                      Image.asset("assets/img/barcode.jpg"),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: ButtonAction(
                label: "Close",
                onPressed: () {
                  context.go('/home');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(String title, String value) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: Colors.white70, fontSize: 12)),
        SizedBox(height: 4),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }
}

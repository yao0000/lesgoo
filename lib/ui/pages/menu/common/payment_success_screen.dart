import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/models/flight_model.dart';
import 'package:travel/data/models/function.dart';
import 'package:travel/ui/widgets/button_action.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final dynamic bookingItem;

  const PaymentSuccessScreen({super.key, required this.bookingItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/img/Payment.png', width: 100, height: 100),
            SizedBox(height: 20),
            Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Thank you for your purchasing',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            SizedBox(height: 20),
            ButtonAction(
              label: "View Ticket",
              onPressed: () {
                dynamic item = getItem(bookingItem);

                if (item is FlightBookingModel) {
                  GoRouter.of(context).push('/boardingPass', extra: {'bookingItem': bookingItem});
                  return;
                }
                GoRouter.of(
                  context,
                ).push('/ticketDetail', extra: {'bookingItem': bookingItem});
              },
            ),
          ],
        ),
      ),
    );
  }
}

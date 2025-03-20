import 'package:flutter/material.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/ui/widgets/button_action.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/Payment.png', 
              width: 100,
              height: 100,
            ),
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
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 20),
            ButtonAction(label: "View Ticket"),
          ],
        ),
      ),
    );
  }
}

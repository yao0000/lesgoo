import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/services/firebase_auth_service.dart';
import 'package:travel/ui/widgets/dialog_loading.dart';
import 'package:travel/ui/widgets/dialog_msg.dart';
import 'package:restart_app/restart_app.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adminBg,
      appBar: AppBar(
        backgroundColor: AppColors.adminBg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Services",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          const Divider(
            color: Colors.black,
            thickness: 1,
            indent: 40,
            endIndent: 40,
          ),
          const SizedBox(height: 20),
          /*ServiceCard(icon: Icons.hotel, label: "Hotel"),
          ServiceCard(icon: Icons.restaurant, label: "Restaurant"),
          ServiceCard(icon: Icons.directions_car, label: "Transportation"),*/
          ServiceCard(file: 'service.png', label: "Hotels"),
          ServiceCard(file: 'Restaurant.png', label: "Restaurant"),
          ServiceCard(file: 'Car.png', label: "Transportation"),
          ServiceCard(file: 'logout.png', label: "Log out"),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String file;
  final String label;

  const ServiceCard({super.key, required this.file, required this.label});

  Future<void> _signOut(BuildContext context) async {
    bool? confirm = await showConfirmationDialog(
      context,
      "Logout",
      "Are you sure you want to log out?",
    );

    if (confirm == true) {
      showLoadingDialog(context, "sign out in progress...");
      await AuthService.signOut();
      Navigator.pop(context);
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (file == "logout.png") {
          await _signOut(context);
          Restart.restartApp();
          return;
        }
        GoRouter.of(context).push('/list/${label.toLowerCase()}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.lightBlue[100],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Icon(icon, size: 30, color: Colors.indigo[900]),
              Image.asset(
                'assets/img/$file', // Make sure the image is in your assets folder
                width: 30,
                height: 30,
                color:
                    Colors.indigo[900], // This works only for monochrome images
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

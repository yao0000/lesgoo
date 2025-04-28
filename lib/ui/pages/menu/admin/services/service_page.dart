import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/services/firebase_auth_service.dart';
import 'package:travel/ui/widgets/dialog_loading.dart';
import 'package:travel/ui/widgets/dialog_msg.dart';
import 'package:restart_app/restart_app.dart';

class ServicesPage extends StatelessWidget {
  final int mode;
  const ServicesPage({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adminBg,
      appBar: AppBar(
        backgroundColor: AppColors.adminBg,
        elevation: 0,
        centerTitle: true,
        title: Text(
          mode == 0 ? "Services" : "Track Availability",
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
          ServiceCard(file: 'service.png', label: "Hotels", mode: mode),
          ServiceCard(file: 'Restaurant.png', label: "Restaurants", mode: mode),
          ServiceCard(file: 'Car.png', label: "Cars", mode: mode),
          if (mode == 0)
            ServiceCard(file: 'logout.png', label: "Log out", mode: mode),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String file;
  final String label;
  final int mode;

  const ServiceCard({
    super.key,
    required this.file,
    required this.label,
    required this.mode,
  });

  Future<bool> _signOut(BuildContext context) async {
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

    return confirm ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (file == "logout.png") {
          bool isLogout = await _signOut(context);
          if (isLogout == true) {
            Restart.restartApp();
          }
          return;
        }
        GoRouter.of(
          context,
        ).push('/list/${label.toLowerCase()}', extra: {'mode': mode});
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
              Image.asset(
                'assets/img/$file',
                width: 30,
                height: 30,
                color: Colors.indigo[900],
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

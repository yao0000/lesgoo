import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/global.dart';
import 'package:travel/data/models/user_model.dart';
import 'package:travel/data/repositories/user_repository.dart';
import 'package:travel/services/firebase_auth_service.dart';
import 'package:travel/ui/widgets/base/custom_app_bar.dart';
import 'package:travel/ui/widgets/widgets.dart';
import 'package:restart_app/restart_app.dart';

class ProfilePage extends StatelessWidget {
  final String userUid;
  const ProfilePage({super.key, required this.userUid});

  void _signOut(BuildContext context) async {
    bool? confirm = await showConfirmationDialog(
      context,
      "Logout",
      "Are you sure you want to log out?",
    );

    if (confirm == true) {
      showLoadingDialog(context, "sign out in progress...");
      await AuthService.signOut();
      Navigator.pop(context);
      //context.go('/login');
      Restart.restartApp();
    }
  }

  void _deleteUser(BuildContext context) async {
    bool? confirm = await showConfirmationDialog(
      context,
      "Are You Sure?",
      "The user will be permanent deleted",
    );

    if (confirm == null || !confirm) {
      return;
    }

    bool isSuccess = await UserRepository.delete(userUid: userUid);
    if (isSuccess) {
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Global.user.role == "user" ? AppColors.bgColor : AppColors.adminBg,
      appBar:
          Global.user.role == "user"
              ? TravellerAppBar(title: "Profile")
              : CustomAppBar(title: "", backgroundColor: AppColors.adminBg),
      body: StreamBuilder<UserModel?>(
        stream: UserRepository.getUserStream(userUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return noDataScreen("No user data found");
          }

          UserModel user = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (user.imageUrl.isEmpty)
                      ? CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.navyBlue,
                      )
                      : ClipOval(
                        child: Image.network(
                          user.imageUrl,
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                  const SizedBox(height: 10),
                  Text(
                    user.username,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  if (Global.user.role == "user")
                    ButtonAction(
                      label: "Edit Profile",
                      onPressed:
                          () => GoRouter.of(context).push('/profileEdit'),
                    ),

                  const SizedBox(height: 20),

                  InputText(label: "Name", hintText: user.name.isEmpty ? "Please set your name" : user.name, readOnly: true),
                  InputText(
                    label: "Phone",
                    hintText: user.phone.isEmpty ? "Please set your contact numebr" : user.phone,
                    readOnly: true,
                  ),
                  InputText(
                    label: "Gender",
                    hintText: user.gender,
                    readOnly: true,
                  ),
                  InputText(
                    label: "Country",
                    hintText: user.country,
                    readOnly: true,
                  ),

                  const SizedBox(height: 30),
                  if (Global.user.role == "user")
                    ButtonAction(
                      label: "Log Out",
                      onPressed: () => _signOut(context),
                    ),

                  if (Global.user.role == "admin")
                    Column(
                      children: [
                        ButtonAction(
                          label: "Manage Booking",
                          onPressed:
                              () =>
                                  context.push('/ticketList', extra: user.uid),
                        ),
                        if (user.role == "user")
                          ButtonAction(
                            label: "Delete User",
                            btnColor: Colors.red,
                            onPressed: () => _deleteUser(context),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

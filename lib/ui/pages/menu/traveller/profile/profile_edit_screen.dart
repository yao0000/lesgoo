import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/global.dart';
import 'package:travel/data/models/user_model.dart';
import 'package:travel/data/repositories/user_repository.dart';
import 'package:travel/services/firebase_auth_service.dart';
import 'package:travel/ui/widgets/widgets.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  String? userId;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String selectedCountry = "Malaysia";
  String selectedGender = "Prefer not to say";

  XFile? profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = AuthService.getCurrentUser();
    if (user != null) {
      userId = user.uid;
      UserModel? userData = await UserRepository.getUser(userId!);
      if (userData != null) {
        setState(() {
          nameController.text = userData.name;
          phoneController.text = userData.phone;
          selectedCountry = userData.country;
          selectedGender = userData.gender;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        profileImage = image;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        selectedCountry.isEmpty ||
        selectedGender.isEmpty) {
      showMessageDialog(
        context: context,
        title: "Error",
        message: "All fields are required",
      );
      return;
    }

    Global.user.uid = userId!;
    Global.user.name = nameController.text.trim();
    Global.user.country = selectedCountry;
    Global.user.gender = selectedGender;
    Global.user.phone = phoneController.text.trim();

    if (profileImage != null) {
      Global.user.imageUrl = await UserRepository.uploadPhoto(
        File(profileImage!.path),
      );
    }

    await UserRepository.update();
    showToast("Profile updated successfully!");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  (Global.user.imageUrl.isEmpty)
                      ? CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.navyBlue,
                      )
                      : ClipOval(
                        child:
                            profileImage == null
                                ? Image.network(
                                  Global.user.imageUrl,
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
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
                                )
                                : Image.file(
                                  File(
                                    profileImage!.path,
                                  ), // Convert XFile to File
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                      ),
                  GestureDetector(
                    onTap: () => _pickImage(),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.edit, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),

              InputText(
                label: "Name",
                hintText: "",
                controller: nameController,
              ),
              InputText(
                label: "Phone",
                hintText: "",
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),
              DropdownSelector(
                label: "Country",
                value: selectedCountry,
                items: ["Malaysia", "USA", "UK", "Other"],
                onChanged: (value) => setState(() => selectedCountry = value!),
              ),
              DropdownSelector(
                label: "Gender",
                value: selectedGender,
                items: ["Male", "Female", "Prefer not to say"],
                onChanged: (value) => setState(() => selectedGender = value!),
              ),
              SizedBox(height: 30),

              ButtonAction(label: "Save", onPressed: _saveProfile),
            ],
          ),
        ),
      ),
    );
  }
}

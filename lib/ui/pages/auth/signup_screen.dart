import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/services/firebase_auth_service.dart';
import 'package:travel/ui/widgets/widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    showLoadingDialog(context, "Register in progress...");
    bool success = await AuthService.signUp(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    Navigator.pop(context);

    if (!success) {
      return;
    }

    if (AuthService.isUserLoggedIn()) {
      await AuthService.signOut();
      showToast("Register successfully");
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor, 
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Let's get started",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Fill out a few details to\nget signed up",
                    textAlign: TextAlign.center,
                  ),
                  InputText(
                    label: "Name",
                    hintText: "Enter your name",
                    controller: _nameController,
                    isRequired: true,
                  ),
                  InputText(
                    label: "Email",
                    hintText: "Enter your email",
                    controller: _emailController,
                    isRequired: true,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  InputPassword(
                    label: "Password",
                    hintText: "Enter your password",
                    controller: _passwordController,
                    otherPasswordController: _confirmPasswordController,
                  ),
                  InputPassword(
                    label: "Confirmed Password",
                    hintText: "Re-type your password",
                    controller: _confirmPasswordController,
                    otherPasswordController: _passwordController,
                  ),
                  ButtonAuth(label: "Sign Up", onPressed: _submitForm),
                  const SizedBox(height: 20),
                  Text("Already have an account?"),
                  ClickableText(label: "SIGN IN", onPressed: () => context.pop()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

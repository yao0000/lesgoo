import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/global.dart';
import 'package:travel/services/firebase_auth_service.dart';
import 'package:travel/ui/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    showLoadingDialog(context, "logging in progress...");
    bool success = await AuthService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    Navigator.pop(context);

    if (success) {
      showToast("Login successfully");
      await Global.loadUserInfo();
      if (Global.user.role == 'user') {
        context.go('/home');
      } else {
        context.go('/adminHome');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/img/logo.png', height: 100),
                SizedBox(height: 16),
                Text(
                  "Welcome Back,",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text("Let's start our journey!"),
                InputText(
                  label: "Email",
                  hintText: "Enter your email",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  isRequired: true,
                ),
                InputPassword(
                  label: "Password",
                  hintText: "Enter your password",
                  controller: _passwordController,
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      GoRouter.of(context).push('/adminHome');
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                ButtonAuth(label: "LogIn", onPressed: _login),
                SizedBox(height: 20),
                Text("You don’t have an account?"),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).push('/signup');
                  },
                  child: Text(
                    "REGISTER",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

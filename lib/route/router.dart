import 'package:go_router/go_router.dart';
import 'package:travel/ui/pages/auth/signup_screen.dart';
import 'package:travel/ui/pages/auth/login_screen.dart';
import 'package:travel/ui/pages/menu/traveller/profile/profile_edit_screen.dart';
import 'package:travel/ui/pages/menu/traveller/traveller_home_screen.dart';
import 'package:travel/ui/pages/splash_screen.dart';
import 'package:travel/ui/pages/auth/forgot_password_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
    GoRoute(path: '/resetPassword', builder: (context, state) => const ForgotPasswordScreen()),

    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/profileEdit', builder: (context, state) => const EditProfilePage()),
  ],
);

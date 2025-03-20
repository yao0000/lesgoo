import 'package:go_router/go_router.dart';
import 'package:travel/ui/pages/auth/signup_screen.dart';
import 'package:travel/ui/pages/auth/login_screen.dart';
import 'package:travel/ui/pages/menu/admin/admin_home_screen.dart';
import 'package:travel/ui/pages/menu/admin/common/item_add_screen.dart';
import 'package:travel/ui/pages/menu/common/details_screen.dart';
import 'package:travel/ui/pages/menu/common/list_screen.dart';
import 'package:travel/ui/pages/menu/common/payment_success_screen.dart';
import 'package:travel/ui/pages/menu/traveller/discover/hotel_booking_screen.dart';
import 'package:travel/ui/pages/menu/traveller/discover/flight/flight_search_screen.dart';
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
    GoRoute(path: '/flightSearch', builder: (context, state) => const FlightSearchScreen()),
    GoRoute(path: '/paymentSuccess', builder: (context, state) => const PaymentSuccessScreen()),

    GoRoute(
      path: '/list/:type',
      builder: (context, state) {
        final type = state.pathParameters['type']!;
        return ListScreen(type: type);
      },
    ),
    GoRoute(path: '/details', builder: (context, state) => const DetailsScreen()),
    GoRoute(path: '/hotelBooking', builder: (context, state) => const HotelBookingScreen()),

  // for admin
    GoRoute(path:'/adminHome', builder: (context, state) => const AdminHomeScreen()),
    
    GoRoute(path: '/itemAdd/:type', builder: (context, state){
        final type = state.pathParameters['type']!;
        return ItemAddScreen(type: type);
      },)

  ],
);

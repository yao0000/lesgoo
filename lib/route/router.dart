import 'package:go_router/go_router.dart';
import 'package:travel/data/models/function.dart';
import 'package:travel/ui/pages/auth/signup_screen.dart';
import 'package:travel/ui/pages/auth/login_screen.dart';
import 'package:travel/ui/pages/menu/admin/admin_home_screen.dart';
import 'package:travel/ui/pages/menu/admin/common/item_add_screen.dart';
import 'package:travel/ui/pages/menu/common/details_screen.dart';
import 'package:travel/ui/pages/menu/common/list_screen.dart';
import 'package:travel/ui/pages/menu/common/payment_success_screen.dart';
import 'package:travel/ui/pages/menu/traveller/discover/booking_screen.dart';
import 'package:travel/ui/pages/menu/traveller/discover/flight/flight_confirm_screen.dart';
import 'package:travel/ui/pages/menu/traveller/discover/flight/flight_list_screen.dart';
import 'package:travel/ui/pages/menu/traveller/discover/flight/flight_search_screen.dart';
import 'package:travel/ui/pages/menu/traveller/itinerary/add_itinerary_details_screen.dart';
import 'package:travel/ui/pages/menu/traveller/itinerary/add_itinerary_screen.dart';
import 'package:travel/ui/pages/menu/traveller/itinerary/itinerary_details_screen.dart';
import 'package:travel/ui/pages/menu/traveller/profile/profile_edit_screen.dart';
import 'package:travel/ui/pages/menu/traveller/profile/profile_page.dart';
import 'package:travel/ui/pages/menu/traveller/ticket/boarding_pass_screen.dart';
import 'package:travel/ui/pages/menu/traveller/ticket/ticket_details_screen.dart';
import 'package:travel/ui/pages/menu/traveller/ticket/ticket_page.dart';
import 'package:travel/ui/pages/menu/traveller/traveller_home_screen.dart';
import 'package:travel/ui/pages/splash_screen.dart';
import 'package:travel/ui/pages/auth/forgot_password_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
    GoRoute(
      path: '/resetPassword',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/profileEdit',
      builder: (context, state) => const EditProfilePage(),
    ),
    GoRoute(
      path: '/flightSearch',
      builder: (context, state) => const FlightSearchScreen(),
    ),
    GoRoute(
      path: '/paymentSuccess',
      builder: (context, state) {
        final item = state.extra as dynamic;
        return PaymentSuccessScreen(bookingItem: item);
      },
    ),
    GoRoute(
      path: '/list/:type',
      builder: (context, state) {
        final type = state.pathParameters['type']!;
        return ListScreen(type: type);
      },
    ),
    GoRoute(
      path: '/details',
      builder: (context, state) {
        final item = state.extra as dynamic;
        return DetailsScreen(item: getItem(item));
      },
    ),
    GoRoute(
      path: '/booking',
      builder: (context, state) {
        final item = state.extra;
        return BookingScreen(item: item);
      },
    ),
    GoRoute(
      path: '/addItinerary',
      builder: (context, state) => const AddItineraryScreen(),
    ),
    GoRoute(
      path: '/addItineraryDetail',
      builder: (context, state) {
        final item = state.extra;
        return AddItineraryDetailsScreen(tripModel: item);
      },
    ),
    GoRoute(
      path: '/itineraryDetail',
      builder: (context, state) {
        final item = state.extra;
        return ItineraryDetailsScreen(trip: getItem(item));
      },
    ),
    GoRoute(
      path: '/ticketDetail',
      builder: (context, state) {
        final bookingItem = state.extra as dynamic;
        return TicketDetailsScreen(bookingItem: bookingItem);
      },
    ),
    GoRoute(
      path: '/flightsList',
      builder: (context, state) {
        final searchReq = state.extra as dynamic;
        return FlightListScreen(flightSearchModel: searchReq);
      },
    ),
    GoRoute(
      path: '/flightBooking',
      builder: (context, state) {
        final bookingModel = state.extra as dynamic;
        return FlightConfirmScreen(bookingModel: getItem(bookingModel));
      },
    ),
    GoRoute(
      path: '/boardingPass',
      builder: (context, state) {
        final bookingModel = state.extra as dynamic;
        return BoardingPassScreen(bookingModel: getItem(bookingModel));
      } ,
    ),
    // for admin
    GoRoute(
      path: '/adminHome',
      builder: (context, state) => const AdminHomeScreen(),
    ),

    GoRoute(
      path: '/itemAdd/:type',
      builder: (context, state) {
        final type = state.pathParameters['type']!;
        return ItemAddScreen(type: type);
      },
    ),
    GoRoute(
      path: '/userDetail',
      builder:(context, state) {
        final userUid = state.extra;
        return ProfilePage(userUid: getItem(userUid));
      },
    ),
    GoRoute(
      path: '/ticketList',
      builder:(context, state) {
        final userUid = state.extra;
        //return UserDetailScreen(user: getItem(user));
        return TicketPage(userUid: getItem(userUid));
      },
    ),
  ],
);

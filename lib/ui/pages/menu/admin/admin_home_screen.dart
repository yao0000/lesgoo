import 'package:flutter/material.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/ui/pages/menu/admin/services/service_page.dart';
import 'package:travel/ui/pages/menu/admin/users/users_page.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    ServicesPage(),
    Center(child: Text("Itinerary Page", style: TextStyle(fontSize: 20))),
    UsersPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: AppColors.navyBlue,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 28,
              height: 28,
              child: Image.asset('assets/img/service.png'),
            ),
            label: "Service",
          ),

          BottomNavigationBarItem(
            icon: SizedBox(
              width: 28,
              height: 28,
              child: Image.asset('assets/img/calendar.png'),
            ),
            label: "Avilability",
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 28,
              height: 28,
              child: Image.asset('assets/img/users.png'),
            ),
            label: "Users",
          ),
        ],
      ),
    );
  }
}

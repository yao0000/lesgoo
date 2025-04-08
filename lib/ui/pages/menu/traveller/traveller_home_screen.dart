import 'package:flutter/material.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/global.dart';
import 'package:travel/ui/pages/menu/traveller/discover/discover_page.dart';
import 'package:travel/ui/pages/menu/traveller/itinerary/itinerary_page.dart';
import 'package:travel/ui/pages/menu/traveller/profile/profile_page.dart';
import 'package:travel/ui/pages/menu/traveller/ticket/ticket_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    //Center(child: Text("Discover Page", style: TextStyle(fontSize: 20))),
    DiscoverPage(),
    //Center(child: Text("Itinerary Page", style: TextStyle(fontSize: 20))),
    ItineraryPage(),
    TicketPage(),
    //Center(child: Text("Tickets Page", style: TextStyle(fontSize: 20))),
    ProfilePage(),
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
              child: Image.asset('assets/img/home.png'),
            ),
            label: "Discover",
          ),

          BottomNavigationBarItem(
            icon: SizedBox(
              width: 28,
              height: 28,
              child: Image.asset('assets/img/itinerary.png'),
            ),
            label: "Itinerary",
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                SizedBox(
                  width: 28,
                  height: 28,
                  child: Image.asset('assets/img/ticket.png'),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: Global.hasNewNotification,
                  builder: (context, hasNotification, child) {
                    return hasNotification
                        ? Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                        : SizedBox();
                  },
                ),
              ],
            ),
            label: "Ticket",
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 28,
              height: 28,
              child: Image.asset('assets/img/me.png'),
            ),
            label: "Me",
          ),
        ],
      ),
    );
  }
}

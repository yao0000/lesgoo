import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/repositories/restaurant_repository.dart';   
import 'package:travel/data/repositories/hotel_repository.dart';
import 'package:travel/data/repositories/car_repository.dart'; 
import 'package:travel/ui/widgets/widgets.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final random = Random();
    final forYouType = random.nextInt(3);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What would you like to find?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconCategory(
                    iconPath: 'assets/img/Flights.png',
                    label: "Flights",
                    onTap: () => context.push('/flightSearch'),
                  ),
                  IconCategory(
                    iconPath: 'assets/img/Hotels.png',
                    label: "Hotels",
                    onTap: () => context.push('/list/hotels'),
                  ),
                  IconCategory(
                    iconPath: 'assets/img/Restaurant.png',
                    label: "Food",
                    onTap: () => context.push('/list/restaurants'),
                  ),
                  IconCategory(
                    iconPath: 'assets/img/Car.png',
                    label: "Cars",
                    onTap: () => context.push('/list/cars'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // New "For You" section
              _buildSectionTitle("For You"),
              const SizedBox(height: 10),
              _buildForYouSection(screenWidth, forYouType),
              const SizedBox(height: 20),

              _buildSectionTitle("Popular Hotels"),
              const SizedBox(height: 10),
              FutureBuilder<List<dynamic>?>(
                future: HotelRepository.getList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return noDataScreen("No data found");
                  } else {
                    return _buildHorizontalList(screenWidth, snapshot.data!);
                  }
                },
              ),

              const SizedBox(height: 20),

              _buildSectionTitle("Popular Restaurant"),
              const SizedBox(height: 10),
              FutureBuilder<List<dynamic>?>(
                future: RestaurantRepository.getList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return noDataScreen("No data found");
                  } else {
                    return _buildHorizontalList(screenWidth, snapshot.data!);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForYouSection(double screenWidth, int type) {
    Widget title;
    Future<List<dynamic>?> future;

    switch (type) {
      case 0:
        title = Row(
          children: [
            Image.asset('assets/img/Hotels.png', width: 16, height: 16),
            const SizedBox(width: 8),
            const Text(
              "Recommended Hotels",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        );
        future = HotelRepository.getList();
        break;
      case 1:
        title = Row(
          children: [
            Image.asset('assets/img/Restaurant.png', width: 16, height: 16),
            const SizedBox(width: 8),
            const Text(
              "Restaurants You Might Like",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        );
        future = RestaurantRepository.getList();
        break;
      case 2:
      default:
        title = Row(
          children: [
            Image.asset('assets/img/Car.png', width: 16, height: 16),
            const SizedBox(width: 8),
            const Text(
              "Car Rentals For You",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        );
        future = CarRepository.getList(); 
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.navyBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: title,
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<dynamic>?>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                  height: 180,
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return noDataScreen("No recommendations found");
            } else {
              final shuffledList = List.from(snapshot.data!)..shuffle();
              final recommendedItems = shuffledList.take(min(shuffledList.length, 5)).toList();
              return _buildHorizontalList(screenWidth, recommendedItems);
            }
          },
        ),
      ],
    );
  }

  // Section Title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  // Horizontal List
  Widget _buildHorizontalList<T>(double screenWidth, List<T> list) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder:
            (context, index) =>
                CardHolder(screenWidth: screenWidth * 0.6, item: list[index]),
      ),
    );
  }
}

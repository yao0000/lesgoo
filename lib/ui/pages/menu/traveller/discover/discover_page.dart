import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/repositories/restaurant_repository.dart';
import 'package:travel/ui/widgets/card_holder.dart';
import 'package:travel/ui/widgets/icon_category.dart';
import 'package:travel/data/repositories/hotel_repository.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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

              _buildSectionTitle("Popular Hotels"),
              const SizedBox(height: 10),
              //_buildHorizontalList(screenWidth),
              FutureBuilder<List<dynamic>?>(
                future: HotelRepository.getList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No data found"));
                  } else {
                    return _buildHorizontalList(screenWidth, snapshot.data!);
                  }
                },
              ),

              const SizedBox(height: 20),

              _buildSectionTitle("Popular Restaurant"),
              const SizedBox(height: 10),
              //_buildHorizontalList(screenWidth),
              FutureBuilder<List<dynamic>?>(
                future: RestaurantRepository.getList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No data found"));
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

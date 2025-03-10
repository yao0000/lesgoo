import 'package:flutter/material.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/ui/widgets/icon_category.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SingleChildScrollView(
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
                IconCategory(icon: Icons.flight, label: "Flights", onTap: () => print('Flights is clicked')),
                IconCategory(icon: Icons.hotel, label: "Hotels", onTap: () => print('Hotels is clicked')),
                IconCategory(icon: Icons.food_bank, label: "Food", onTap: () => print('Food is clicked')),
                IconCategory(icon: Icons.directions_car, label: "Cars", onTap: () => print('cars is clicked')),
              ],
            ),
            const SizedBox(height: 20),

            
            _buildSectionTitle("Popular Hotels"),
            const SizedBox(height: 10),
            _buildHorizontalList(screenWidth),

            const SizedBox(height: 20),

            
            _buildSectionTitle("Popular Restaurant"),
            const SizedBox(height: 10),
            _buildHorizontalList(screenWidth),
          ],
        ),
      ),
    );
  }

  // Section Title
  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          "See All",
          style: TextStyle(fontSize: 14, color: Colors.blue.shade700),
        ),
      ],
    );
  }

  // Horizontal List
  Widget _buildHorizontalList(double screenWidth) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) => _buildCard(screenWidth),
      ),
    );
  }

  // Card Widget
  Widget _buildCard(double screenWidth) {
    return Container(
      width: screenWidth * 0.6,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey[300], // Placeholder for image
              alignment: Alignment.center,
              child: const Text("[Pictures]"),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("[Places]", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("[Ratings]", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("[Price]", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Per person", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

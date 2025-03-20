import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/models/index.dart';
import 'package:travel/ui/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  String _detailsRouting(dynamic item) {
    if (item == HotelModel) {
      return "/hotelBooking";
    }
    return "/";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.bgColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: AppColors.bgColor, // Background color for image
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 10),
                child: Center(
                  child: Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqj6LtDOZm-APHiUFuSE2Cr1In65Vvjzr3w8Z8QE2QvyQvgY-MhZVkXD68g5lQe156DP4&usqp=CAU',
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'place',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'price',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow),
                        SizedBox(width: 5),
                        Text('rating', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "About",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyBlue,
                      ),
                    ),
                    Text('about', style: TextStyle(color: Colors.black54)),
                    SizedBox(height: 10),
                    Text(
                      "Gallery",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    /*SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: gallery.map((img) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.network(img, width: 80, height: 80, fit: BoxFit.cover),
                      )).toList(),
                    ),
                  ),*/
                    SizedBox(height: 10),
                    Text(
                      "Address",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyBlue,
                      ),
                    ),
                    Text('address', style: TextStyle(color: Colors.black54)),
                    SizedBox(height: 10),
                    Text(
                      "Rate Us",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyBlue,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(Icons.star, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(child: ButtonAction(label: "Choose your date", onPressed: () => GoRouter.of(context).push(_detailsRouting(null)))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

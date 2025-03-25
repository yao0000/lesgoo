import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/models/car_model.dart';
import 'package:travel/data/models/index.dart';
import 'package:travel/data/models/restaurant_model.dart';
import 'package:travel/ui/widgets/widgets.dart';
import 'package:travel/data/global.dart';
import 'package:travel/ui/widgets/base/button.dart';
import 'package:travel/data/models/function.dart';

class DetailsScreen extends StatelessWidget {
  final dynamic item;
  const DetailsScreen({super.key, required this.item});

  String _detailsRouting() {
    if (item is HotelModel) {
      return "/hotelBooking";
    }
    return "/hotelBooking";
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
                color: AppColors.bgColor,
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 10),
                child: Center(
                  child: Image.network(
                    getAttribute(item, 'imageUrl'),
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
                          getAttribute(item, 'name'),
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              getAttribute(item, 'price'),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            _sectionContent(_getUnit()),
                          ],
                        ),
                      ],
                    ),
                    if (item is CarModel)
                      _sectionContent(getAttribute(item, 'plate')),
                    Row(
                      children: [
                        if (item is! CarModel)
                          Icon(Icons.star, color: Colors.yellow),
                        SizedBox(width: 5),
                        _sectionContent(getAttribute(item, 'rating')),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      _getAttribute('rate'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyBlue,
                      ),
                    ),
                    if (item is! CarModel) ...[
                      _sectionLabel("About"),
                      _sectionContent(getAttribute(item, 'about')),
                      SizedBox(height: 10),
                    ],
                    if (item is HotelModel) ...[
                      _sectionLabel("Facility"),
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        padding: EdgeInsets.only(bottom: 10, top: 10),
                        child: Center(
                          child: Image.network(
                            _getAttribute('imageFacility'),
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                    _sectionLabel("Gallery"),
                    SizedBox(height: 5),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            (getAttribute(item, 'gallery') as List<dynamic>?)
                                ?.map((img) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image.network(
                                      img.toString(),
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                })
                                .toList() ??
                            [],
                      ),
                    ),
                    SizedBox(height: 10),
                    _sectionLabel(
                      item is CarModel ? "Pick Up Point:" : "Address",
                    ),
                    _sectionContent(getAttribute(item, 'address')),
                    SizedBox(height: 10),
                    if (item is CarModel) ...[
                      _sectionLabel("Pick Up Time: "),
                      _sectionContent(getAttribute(item, 'time')),
                    ],
                    /*_sectionLabel("Rate Us"),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(Icons.star, color: Colors.black),
                      ),
                    ),*/
                    SizedBox(height: 20),
                    Center(
                      child:
                          Global.user.role == "user"
                              ? ButtonAction(
                                label: "Choose your date",
                                onPressed:
                                    () => GoRouter.of(context).push(
                                      _detailsRouting(),
                                      extra: {item: item},
                                    ),
                              )
                              : Button(
                                text: "Delete",
                                onPressed: () {},
                                buttonColor: Colors.red,
                                textColor: Colors.black,
                              ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _sectionContent(String text) {
    return Text(text, style: TextStyle(color: Colors.black54));
  }

  String _getUnit() {
    if (item is HotelModel) {
      return "1 Night";
    } else if (item is RestaurantModel) {
      return "1 Pax";
    } else if (item is CarModel) {
      return "1 Day";
    }
    return "";
  }

  dynamic _getAttribute(String key) {
    final currencyFormat = NumberFormat.currency(
      locale: "en_US",
      symbol: "\$",
      decimalDigits: 2,
    );

    if (item is HotelModel) {
      switch (key) {
        case "name":
          return item.name.toString();
        case "address":
          return item.address.toString();
        case "rating":
          return item.rating.toString();
        case "price":
          return currencyFormat.format(item.price);
        case "about":
          return item.about.toString();
        case "imageFacility":
          return item.imageFacility.toString();
        case "imageUrl":
          return item.imageUrl.toString();
        case "gallery":
          return item.gallery;
      }
    } else if (item is RestaurantModel) {
      switch (key) {
        case "name":
          return item.name.toString();
        case "imageUrl":
          return item.imageUrl.toString();
        case "address":
          return item.address.toString();
        case "rating":
          return item.rating.toString();
        case "price":
          return currencyFormat.format(item.price);
        case "about":
          return item.about.toString();
        case "gallery":
          return item.gallery;
      }
    }
    return "";
  }
}

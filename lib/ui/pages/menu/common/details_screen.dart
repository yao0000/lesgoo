import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/models/index.dart';
import 'package:travel/data/repositories/index.dart';
import 'package:travel/ui/widgets/widgets.dart';
import 'package:travel/data/global.dart';
import 'package:travel/ui/widgets/base/button.dart';
import 'package:travel/data/models/function.dart';

class DetailsScreen extends StatelessWidget {
  final dynamic item;
  const DetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Global.user.role == "admin" ? AppColors.adminBg : Colors.blue[100],
      body: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Global.user.role == "admin" ? AppColors.adminBg : AppColors.bgColor,
          elevation: 0,
          automaticallyImplyLeading: false, // Remove default back button
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              if (Global.user.role == "admin")
                GestureDetector(
                  onTap: ()async  {
                    String dir = '';
                    if (item is HotelModel) {
                      dir = 'hotels';
                    } else if (item is RestaurantModel) {
                      dir = 'restaurants';
                    } else {
                      dir = 'cars';
                    }
                    bool? isEdit = await context.push('/itemAdd/$dir', extra: {item: item});

                    if (isEdit == true) {
                      context.pop(true);
                    }
                  },
                  child: Text(
                    "Edit",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                      backgroundColor: Colors.transparent,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Global.user.role == "admin" ? AppColors.adminBg : AppColors.bgColor,
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
                          getAttribute(item, 'name').length > 20 ? getAttribute(item, 'name').substring(0, 20) : getAttribute(item, 'name'),
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
                    if (item is RestaurantModel) ..._getCuisine(item),
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
                    SizedBox(height: 20),
                    Center(
                      child:
                          Global.user.role == "user"
                              ? ButtonAction(
                                label: "Choose your date",
                                onPressed:
                                    () => GoRouter.of(context).push(
                                      "/booking",
                                      extra: {item: item},
                                    ),
                              )
                              : Button(
                                text: "Delete",
                                onPressed: () async {
                                  bool? confirm = await showConfirmationDialog(
                                    context,
                                    "Are you sure?",
                                    "The options will be permanent deleted.",
                                  );

                                  if (confirm == null || confirm == false) {
                                    return;
                                  }

                                  bool isSuccess = false;
                                  if (item is HotelModel) {
                                    isSuccess = await HotelRepository.delete(
                                      uid: item.uid.toString(),
                                    );
                                  }
                                  else if (item is RestaurantModel) {
                                    isSuccess = await RestaurantRepository.delete(
                                      uid: item.uid.toString(),
                                    );
                                  }
                                  else if (item is CarModel) {
                                    isSuccess = await CarRepository.delete(
                                      uid: item.uid.toString(),
                                    );
                                  }

                                  if (isSuccess) {
                                    showToast("Delete Successfully");
                                    context.pop(true);
                                  }
                                },
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

  List<Widget> _getCuisine(RestaurantModel model) {
    return [
      _sectionLabel("Cuisine Type"),
      _sectionContent(model.cuisine),
      const SizedBox(height: 5),
    ];
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:travel/data/models/index.dart';
import 'package:travel/data/models/restaurant_model.dart';
import 'package:travel/data/models/function.dart';

class CardHolder extends StatelessWidget {
  final dynamic item;
  final double screenWidth;
  const CardHolder({super.key, required this.screenWidth, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/details', extra: item);
      },
      child: Container(
        width: screenWidth,
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
                color: Colors.grey[300],
                alignment: Alignment.center,
                child: Image.network(
                  getAttribute(item, 'imageUrl'),
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  /*loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },*/
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getAttribute('name'),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _getAttribute('rating'),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _getAttribute('price'),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Per person",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getAttribute(String key) {
    final currencyFormat = NumberFormat.currency(
      locale: "en_US",
      symbol: "\$",
      decimalDigits: 2,
    );

    if (item is HotelModel) {
      switch (key) {
        case "name":
          {
            return item.name.toString();
          }
        case "address":
          return "${item.address.substring(0, 10)}...";
        case "rating":
          return item.rating.toString();
        case "price":
          return currencyFormat.format(item.price);
      }
    } else if (item is RestaurantModel) {
      switch (key) {
        case "name":
          {
            return item.name.toString();
          }
        case "imageUrl":
          {
            return item.imageUrl.toString();
          }
        case "address":
          return "${item.address.substring(0, 10)}...";
        case "rating":
          return item.rating.toString();
        case "price":
          return currencyFormat.format(item.price);
      }
    }
    return "";
  }
}

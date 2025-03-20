import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:travel/data/models/index.dart';
import 'package:travel/data/models/restaurant_model.dart';

class CardObject extends StatelessWidget {
  final dynamic item;
  CardObject({super.key, required this.item});
  final currencyFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/details');
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                color: Colors.grey[300],
                child: Image.network(
                  _getAttribute('imageUrl'),
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getAttribute('name'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _getAttribute('price'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getAttribute(''),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _getAttribute('rating'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getAttribute(String key) {
    if (item is HotelModel) {
      switch (key) {
        case "name":
          {
            return item.name.toString();
          }
        case "address":
          {
            return "${item.address.substring(0, item.address.length >= 20 ? 20 : item.address.length)}...";
          }
        case "rating":
          {
            return item.rating.toString();
          }
        case "price":
          {
            return currencyFormat.format(item.price);
          }
        default:
          {
            return "";
          }
      }
    } else if (item is RestaurantModel) {
      switch (key) {
        case "name":
          {
            return item.name.toString();
          }
        case "address":
          {
            return "${item.address.substring(0, item.address.length >= 20 ? 20 : item.address.length)}...";
          }
        case "rating":
          {
            return item.rating.toString();
          }
        case "price":
          {
            return currencyFormat.format(item.price);
          }
        case "imageUrl":
          {
            return item.imageUrl.toString();
          }
      }
    }
    return "";
  }
}

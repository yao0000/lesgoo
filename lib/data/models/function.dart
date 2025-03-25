import 'package:travel/data/models/car_model.dart';
import 'package:travel/data/models/index.dart';
import 'package:intl/intl.dart';

final currencyFormat = NumberFormat.currency(
  locale: "en_US",
  symbol: "\$",
  decimalDigits: 2,
);

dynamic getAttribute(dynamic item, String key) {
  if (item is Map) {
    item = item.entries.first.value;
  }

  if (item is HotelModel) {
    switch (key) {
      case "name":
        return item.name.toString();
      case "address":
        return item.address.toString();
      case "rating":
      case "field4":
        return item.rating.toString();
      case "price":
        return getPriceFormat(item, 1);
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
      case "field4":
        return item.rating.toString();
      case "price":
        return getPriceFormat(item, 1);
      case "about":
        return item.about.toString();
      case "gallery":
        return item.gallery;
    }
  } else if (item is CarModel) {
    switch (key) {
      case "name":
        return item.name.toString();
      case "rating":
        return '${item.seat.toInt()} Seats';
      case "plate":
      case "field3":
        return item.plate.toString();
      case "price":
        return getPriceFormat(item, 1);
      case "field4":
        return item.seat.toString();
      case "imageUrl":
        return item.imageUrl.toString();
      case "gallery":
        return item.gallery;
      case "address":
        return item.address.toString();
      case "time": 
        return "12:00 PM";
    }
  }
  return "";
}

String getPriceFormat(dynamic item, int count) {
  if (item is Map) {
    item = item.entries.first.value;
  }

  return currencyFormat.format(item.price * count).replaceFirst("\$", "\$ ");
}

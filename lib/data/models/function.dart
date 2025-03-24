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
        return item.rating.toString();
      case "price":
        return currencyFormat.format(item.price).replaceFirst("\$", "\$ ");
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
        return currencyFormat.format(item.price).replaceFirst("\$", "\$ ");
      case "about":
        return item.about.toString();
      case "gallery":
        return item.gallery;
    }
  }
  return "";
}

String getPriceFormat(dynamic item, int count) {
  if (item is Map) {
    item = item.entries.first.value;
  }

  if (item is HotelModel) {
    return currencyFormat.format(item.price * count).replaceFirst("\$", "\$ ");
  }

  return "";
}

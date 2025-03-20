class HotelModel {
  final String uid;
  final String about;
  final String address;
  final String name;
  final double price;
  final double rating;

  HotelModel({
    required this.uid,
    required this.about,
    required this.address,
    required this.name,
    required this.price,
    required this.rating
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      uid: json['uid'] ?? '',
      about: json['about'] ?? '',
      address: json['address'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.00).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'about': about,
      'address': address,
      'name': name,
      'price': price,
      'rating': rating,
    };
  }
}

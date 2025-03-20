class RestaurantModel {
  final String uid;
  final String name;
  final String about;
  final String address;
  final double price;
  final double rating;
  final String imageUrl;

  RestaurantModel({
    required this.uid,
    required this.name,
    required this.about,
    required this.address,
    required this.price,
    required this.rating,
    required this.imageUrl,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      uid: json['uid'] ?? '', 
      name: json['name'] ?? '', 
      about: json['about'] ?? '', 
      address: json['address'] ?? '', 
      price: (json['price'] ?? 0.00).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'about': about,
      'address': address,
      'price': price,
      'rating': rating,
      'imageUrl': imageUrl,
    };
  }
}

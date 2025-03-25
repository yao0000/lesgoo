class CarModel {
  String uid;
  String name;
  String plate;
  String address;
  double price;
  double seat;
  String imageUrl;

  List<String> gallery;

  CarModel({
    required this.uid,
    required this.name,
    required this.plate,
    required this.address,
    required this.price,
    required this.seat,
    required this.imageUrl,
    required this.gallery
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      plate: json['plate'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      seat: (json['seat'] ?? 1.0).toDouble(),
      address: json['address'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      gallery:
          (json['gallery'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'plate': plate,
      'price': price,
      'seat': seat,
      'address': address,
      'imageUrl': imageUrl,
      'gallery': gallery
    };
  }
}

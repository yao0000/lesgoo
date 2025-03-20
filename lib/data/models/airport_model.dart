class AirportModel {
  final String id;
  final String description;

  AirportModel({
    required this.id,
    required this.description,
  });

  factory AirportModel.fromJson(Map<String, dynamic> json) {
    return AirportModel(
      id: json["ID"] ?? '',
      description: json['Description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Description': description,
      'ID': id,
    };
  }
}

class FlightBookingModel {
  final bool isRoundTrip;
  final String type;
  final String departure;
  final String destination;
  final String departureDate;
  final int pax;
  final String returnDate;
  double amount;
  ScheduleModel? departureTrip;
  ScheduleModel? returnTrip;
  String userUid;

  FlightBookingModel({
    required this.isRoundTrip,
    required this.type,
    required this.departure,
    required this.destination,
    required this.departureDate,
    required this.pax,
    required this.returnDate,
    this.amount = 0.00,
    this.userUid = '',
    this.departureTrip,
    this.returnTrip
  });

  factory FlightBookingModel.fromJson(Map<String, dynamic> json) {
    return FlightBookingModel(
      isRoundTrip: json['isRoundTrip'] ?? false,
      type: json['type'] ?? '',
      departure: json['departure'] ?? '',
      destination: json['destination'] ?? '',
      departureDate: json['departureDate'] ?? '',
      returnDate: json['returnDate'] ?? '',
      pax: json['pax'] ?? 0,
      amount: (json['amount'] ?? 0.00).toDouble(),
      userUid: json['userUid'] ?? '',
      departureTrip: json['departureTrip'] != null
          ? ScheduleModel.fromJson(json['departureTrip'])
          : null,
      returnTrip: json['returnTrip'] != null
          ? ScheduleModel.fromJson(json['returnTrip'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'isRoundTrip': isRoundTrip,
      'type': type,
      'departure': departure,
      'destination': destination,
      'pax': pax,
      'amount': amount,
      'departureDate': departureDate,
      'returnDate': returnDate,
      'userUid': userUid
    };

    if (departureTrip != null) {
      data['departureTrip'] = departureTrip!.toJson();
    }

    if (isRoundTrip && returnTrip != null) {
      data['returnTrip'] = returnTrip!.toJson();
    }
    return data;
  }
}

class ScheduleModel {
  final String id;
  final String departureTime;
  final String arrivalTime;
  final double price;

  ScheduleModel({
    required this.id,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
      departureTime: json['departureTime'] ?? '',
      price: (json['price'] ?? 0.00).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime
    };
  }
}

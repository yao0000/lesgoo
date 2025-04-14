import 'package:flutter/material.dart';
import 'package:travel/data/models/car_model.dart';
import 'package:travel/data/models/hotel_model.dart';
import 'package:travel/data/models/restaurant_model.dart';
import 'package:travel/data/models/user_model.dart';
import 'package:travel/data/repositories/index.dart';
import 'package:travel/ui/widgets/builder.dart';
import 'package:travel/ui/widgets/button_action.dart';

class UserDetailScreen extends StatefulWidget {
  final UserModel user;
  const UserDetailScreen({super.key, required this.user});

  @override
  State<StatefulWidget> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetailScreen> {
  late UserModel user;
  late double screenWidth;

  late List<HotelBookingModel> _hotelBookingList;
  late List<RestaurantBookingModel> _restaurantBookingList;
  late List<CarBookingModel> _carBookingList;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    _hotelBookingList = [];
    _restaurantBookingList = [];
    _carBookingList = [];

    _loadHotelBooking();
    _loadRestaurantBooking();
    _loadCarBooking();
  }

  Future<void> _loadHotelBooking() async {
    List<HotelBookingModel> fetchList =
        await HotelBookingRepository.getListByUser(user.uid);
    setState(() {
      _hotelBookingList = fetchList;
    });
  }

  Future<void> _loadRestaurantBooking() async {
    List<RestaurantBookingModel> fetchList =
        await RestaurantBookingRepository.getListByUser(user.uid);
    setState(() {
      _restaurantBookingList = fetchList;
    });
  }

  Future<void> _loadCarBooking() async {
    List<CarBookingModel> fetchList = await CarBookingRepository.getListByUser(
      user.uid,
    );
    setState(() {
      _carBookingList = fetchList;
    });
  }

  Future<void> _deleteUser() async {}

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[100],
        leading: const Icon(Icons.arrow_back),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            Wrap(
              spacing: 20,
              runSpacing: 12,
              children: [
                _buildInfoTile("Name", user.name),
                _buildInfoTile("Phone", user.phone),
                _buildInfoTile("Gender", user.gender),
                _buildInfoTile("Country", user.country),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Bookings",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Text("Manage", style: TextStyle(color: Colors.blue)),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Column(
                children: [
                  if (_hotelBookingList.isNotEmpty)
                    _buildBookingSection("Hotel", _hotelBookingList),
                  if (_restaurantBookingList.isNotEmpty)
                    _buildBookingSection("Restaurant", _restaurantBookingList),
                  if (_carBookingList.isNotEmpty)
                    _buildBookingSection("Cars", _carBookingList),
                ],
              ),
            ),

            Center(
              child: ButtonAction(label: "Delete User", btnColor: Colors.red, onPressed: () => _deleteUser()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(6),
            color: Colors.yellow[200],
          ),
          child: Text(value),
        ),
      ],
    );
  }

  Widget _buildBookingSection<T>(String label, List<T> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("$label\t(${list.length})"),
        buildHorizontalList(screenWidth, list),
      ],
    );
  }
}

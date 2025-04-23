import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/global.dart';
import 'package:travel/data/models/flight_model.dart';
import 'package:travel/data/models/function.dart';
import 'package:travel/data/repositories/flight_repository.dart';
import 'package:travel/data/repositories/user_repository.dart';
import 'package:travel/services/firebase_auth_service.dart';
import 'package:travel/ui/widgets/widgets.dart';

class FlightConfirmScreen extends StatelessWidget {
  final FlightBookingModel bookingModel;
  const FlightConfirmScreen({super.key, required this.bookingModel});

  Future<void> _booking(BuildContext context) async {
    bool isSuccess = false;

    bookingModel.userUid = AuthService.getCurrentUser()!.uid;
    isSuccess = await FlightBookingRepository.post(data: bookingModel);

    if (isSuccess) {
      Global.user.notifications[0] = true;
      UserRepository.update();
      Global.updateNotifications();
      showToast("Booking successfully");
      GoRouter.of(
        context,
      ).push('/paymentSuccess', extra: {'bookingItem': bookingModel});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.pop(true);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.slateBlue,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(true),
          ),
        ),
        body: Container(
          color: AppColors.bgColor,
          child: Column(
            children: [
              _buildSearchHeader(),
              _buildBookingDetails(context),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ButtonAction(
                  label: "Book Now",
                  onPressed: () => _booking(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slateBlue,
        border: Border(bottom: BorderSide(color: Colors.white70, width: 2)),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    bookingModel.departure,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    bookingModel.departureDate,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${bookingModel.pax} Pax',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (bookingModel.isRoundTrip)
                    Text(
                      bookingModel.departureTrip!.id,
                      style: TextStyle(color: Colors.white),
                    ),
                  Image.asset(
                    bookingModel.isRoundTrip
                        ? "assets/img/trip_return.png"
                        : "assets/img/trip_one_way.png",
                    width: 30,
                    height: 30,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    bookingModel.isRoundTrip
                        ? bookingModel.returnTrip!.id
                        : bookingModel.departureTrip!.id,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookingModel.destination,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    bookingModel.returnDate,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    bookingModel.type,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetails(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: Colors.white70, width: 2)),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailsSection("Passenger Name:", Global.user.name),
          _buildDetailsSection("Class", "Economy/Business"),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle("Number of Pax"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetails("Adult"),
                  _buildDetails("x${bookingModel.pax}"),
                ],
              ),
            ],
          ),
          _buildDetailsSection(
            "Total Amont",
            toPriceFormat(bookingModel.amount),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _buildTitle(label),
        _buildDetails(value),
      ],
    );
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: AppColors.slateBlue,
      ),
    );
  }

  Widget _buildDetails(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: Colors.blueGrey,
      ),
    );
  }
}

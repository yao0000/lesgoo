import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/models/flight_model.dart';
import 'package:travel/data/models/function.dart';
import 'package:travel/data/repositories/flight_repository.dart';
import 'package:travel/ui/widgets/widgets.dart';

class FlightListScreen extends StatefulWidget {
  final FlightBookingModel flightSearchModel;
  const FlightListScreen({super.key, required this.flightSearchModel});

  @override
  State<StatefulWidget> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightListScreen> {
  List<ScheduleModel> list = [];
  late FlightBookingModel bookingModel;

  @override
  void initState() {
    super.initState();
    _loadSchedule();
    bookingModel = getItem(widget.flightSearchModel);
  }

  void _loadSchedule() async {
    List<ScheduleModel> fetchList = await FlightRepository.getFlightSchedule();
    setState(() {
      list = fetchList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.slateBlue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(bookingModel.isRoundTrip),
        ),
      ),
      body: Container(
        color: AppColors.bgColor,
        child: Column(
          children: [
            _buildSearchHeader(),
            Flexible(
              child:
                  list.isEmpty
                      ? noDataScreen("No records found")
                      : ListView.builder(
                        itemCount: list.length,
                        itemBuilder:
                            (context, index) => _buildFlightCard(list[index]),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
      decoration: BoxDecoration(
        color: AppColors.slateBlue,
        border: Border(bottom: BorderSide(color: Colors.white70, width: 2)),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                (bookingModel.isRoundTrip && bookingModel.departureTrip != null) ? bookingModel.destination : bookingModel.departure,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 5),
              Text(
                (bookingModel.isRoundTrip && bookingModel.departureTrip != null) ? bookingModel.returnDate : bookingModel.departureDate,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 10),
              Text(
                '${bookingModel.pax} Pax',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
          Icon(Icons.arrow_forward, color: Colors.white, size: 50),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (bookingModel.isRoundTrip && bookingModel.departureTrip != null) ? bookingModel.departure : bookingModel.destination,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 5),
              Text(
                (bookingModel.isRoundTrip && bookingModel.departureTrip != null) ? bookingModel.returnDate : bookingModel.departureDate,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 10),
              Text(bookingModel.type, style: TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlightCard(ScheduleModel scheduleModel) {
    return WillPopScope(
      onWillPop: () async {
        context.pop(true);
        return false;
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                scheduleModel.id,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  _buildScheduleDetails(
                    scheduleModel.departureTime,
                    bookingModel.departure,
                  ),
                  Spacer(),
                  Icon(Icons.flight_takeoff, size: 24),
                  Spacer(),
                  _buildScheduleDetails(
                    scheduleModel.arrivalTime,
                    bookingModel.destination,
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      Text(
                        getPriceFormat(
                          scheduleModel,
                          bookingModel.type == "Economy" ? 1 : 3,
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text('/Pax'),
                    ],
                  ),
                  Spacer(),
                  ButtonAction(
                    label: "Select",
                    onPressed: () async {
                      double newAmount =
                          (scheduleModel.price *
                              (bookingModel.type == "Economy" ? 1 : 3) *
                              bookingModel.pax);
                      bookingModel.amount += newAmount;

                      if (bookingModel.isRoundTrip) {
                        if (bookingModel.departureTrip == null) {
                          bookingModel.departureTrip = scheduleModel;

                          bool? isReturn = await context.push(
                            '/flightsList',
                            extra: bookingModel,
                          );
                          if (isReturn == true) {
                            bookingModel.departureTrip = null;
                            bookingModel.amount -= newAmount;
                            //context.push('/flightsList', extra: bookingModel);
                          }
                        } else {
                          bookingModel.returnTrip = scheduleModel;

                          bool? isReturn = await context.push(
                            '/flightBooking',
                            extra: bookingModel,
                          );
                          if (isReturn == true) {
                            bookingModel.returnTrip = null;
                            bookingModel.amount -= newAmount;
                            //context.push('/flightsList', extra: bookingModel);
                          }
                        }
                      } else {
                        bookingModel.departureTrip = scheduleModel;
                        context.push('/flightBooking', extra: bookingModel);
                      }

                      /*if (bookingModel.departureTrip == null) {
                      bookingModel.departureTrip = scheduleModel;
                    } else {
                      bookingModel.returnTrip ??= scheduleModel;
                    }

                    if (bookingModel.isRoundTrip &&
                        bookingModel.returnTrip == null) {
                      bool? isReturn = await GoRouter.of(
                        context,
                      ).push('/flightsList', extra: bookingModel);

                      if (isReturn == true) {
                        bookingModel.departureTrip = null;
                        bookingModel.amount = 0;
                        GoRouter.of(
                          context,
                        ).replace('/flightsList', extra: bookingModel);
                      }

                      return;
                    }

                    bool? isReturn = await context.push(
                      '/flightBooking',
                      extra: bookingModel,
                    );
                    if (isReturn == true) {
                      if (bookingModel.isRoundTrip &&
                          bookingModel.returnTrip != null) {
                        bookingModel.returnTrip = null;
                        bookingModel.amount -= newAmount;
                      } else {
                        bookingModel.departureTrip = null;
                        bookingModel.amount = 0;
                      }
                      GoRouter.of(
                        context,
                      ).replace('/flightsList', extra: bookingModel);
                    }*/
                    },
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleDetails(String time, String place) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(time, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        const SizedBox(height: 10),
        Text(place),
      ],
    );
  }
}

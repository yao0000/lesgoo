import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/models/index.dart';
import 'package:travel/data/repositories/trip_repository.dart';
import 'package:travel/ui/widgets/widgets.dart';

class ItineraryPage extends StatefulWidget {
  const ItineraryPage({super.key});

  @override
  State<StatefulWidget> createState() => _ItineraryPage();
}

class _ItineraryPage extends State<ItineraryPage> {
  List<TripModel> list = [];

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    List<TripModel> fetchList = await TripRepository.getList();
    setState(() {
      list = fetchList;
    });
  }

  void onDelete(String tripUid) async {
    bool? confirm = await showConfirmationDialog(
      context,
      "Delete?",
      "Are you confirm to delete this trip record?",
    );

    if (confirm == true) {
      bool isSuccess = await TripRepository.delete(tripUid);

      if (isSuccess) {
        _loadTrips();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Trip"),
        backgroundColor: AppColors.bgColor,
      ),
      body: Column(
        children: [
          Expanded(
            child:
                list.isEmpty
                    ? _buildEmptySection()
                    : ListView.builder(
                      itemCount: list.length,
                      itemBuilder:
                          (context, index) => _buildTripCard(list[index]),
                    ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ButtonAction(
              label: "Create New Trip",
              onPressed: () async {
                final result = await GoRouter.of(context).push('/addItinerary');
                if (result == true) {
                  _loadTrips();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/img/itinerary.png", color: AppColors.navyBlue),
          const SizedBox(height: 20),
          const Text(
            "Add your itinerary now!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.navyBlue,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(TripModel tripModel) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: () {
          GoRouter.of(context).push('/itineraryDetail', extra: tripModel);
        },
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              "assets/img/itinerary.png",
              width: 28,
              height: 28,
              color: AppColors.navyBlue,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(tripModel.name, style: TextStyle(fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () => onDelete(tripModel.uid!),
              child: const Icon(Icons.delete, color: Colors.red, size: 30),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Duration: ${tripModel.dayList.length} days"),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  Expanded(child: Container()),
                  Text("Status: ", style: TextStyle(color: Colors.grey)),
                  Icon(Icons.circle, size: 10, color: getColor(tripModel)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getColor(TripModel tripModel) {
    DateTime today = DateTime.now();

    DateTime startDate = DateTime(
      tripModel.startDate.year,
      tripModel.startDate.month,
      tripModel.startDate.day,
    );
    DateTime endDate = DateTime(
      tripModel.endDate.year,
      tripModel.endDate.month,
      tripModel.endDate.day,
    );
    DateTime todayOnly = DateTime(today.year, today.month, today.day);

    if (todayOnly.isBefore(startDate)) {
    return Colors.grey; // Before start date
  } else if (todayOnly.isAfter(endDate)) {
    return Colors.red; // After end date
  } else {
    return Colors.green; // Between start and end date
  }
  }
}

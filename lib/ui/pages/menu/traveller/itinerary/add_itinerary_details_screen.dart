import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/models/function.dart';
import 'package:travel/data/models/index.dart';
import 'package:travel/data/repositories/index.dart';
import 'package:travel/ui/pages/menu/traveller/itinerary/schedule_item.dart';
import 'package:travel/ui/widgets/widgets.dart';

class AddItineraryDetailsScreen extends StatefulWidget {
  final dynamic tripModel;
  const AddItineraryDetailsScreen({super.key, required this.tripModel});

  @override
  State<StatefulWidget> createState() => _AddItineraryDetailsScreen();
}

class _AddItineraryDetailsScreen extends State<AddItineraryDetailsScreen> {
  late TripModel tripModel;
  int currentDayIndex = 0;

  @override
  void initState() {
    super.initState();
    tripModel = getItem(widget.tripModel);
  }

  Future<void> _onSubmit(BuildContext context) async {
    if (tripModel.isAnyNull()) {
      showMessageDialog(
        context: context,
        title: "Opps",
        message: "All fields are required",
      );
      return;
    }
    bool isSuccess = await TripRepository.post(data: tripModel);
    if (isSuccess) {
      showToast("Save successfully");
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Add Itinerary"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tripModel.dayList.length,
                  itemBuilder: (context, index) {
                    return _buildDayTab(index);
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  key: ValueKey(currentDayIndex),
                  itemCount:
                      tripModel.dayList[currentDayIndex].detailsList?.length,
                  itemBuilder: (context, index) {
                    return ScheduleItem(
                      time:
                          tripModel
                              .dayList[currentDayIndex]
                              .detailsList?[index]
                              .time,
                      task:
                          tripModel
                              .dayList[currentDayIndex]
                              .detailsList?[index]
                              .task,
                      onTaskChanged: (newTask) {
                        setState(() {
                          tripModel
                              .dayList[currentDayIndex]
                              .detailsList?[index]
                              .task = newTask;
                        });
                      },
                      onTimeChanged: (newTime) {
                        setState(() {
                          tripModel
                              .dayList[currentDayIndex]
                              .detailsList?[index]
                              .time = newTime;
                        });
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ButtonAction(
                  label: "Add Schedule",
                  onPressed: () {
                    setState(() {
                      tripModel.dayList[currentDayIndex].detailsList ??= [];
                      tripModel.dayList[currentDayIndex].detailsList!.add(
                        TripDetails(),
                      );
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ButtonAction(
                  label: "Save",
                  onPressed: () {
                    _onSubmit(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayTab(int index) {
    return GestureDetector(
      onTap:
          () => setState(() {
            currentDayIndex = index;
          }),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color:
              currentDayIndex == index ? AppColors.navyBlue : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Day ${index + 1}',
              style: TextStyle(
                color:
                    currentDayIndex == index
                        ? Colors.white
                        : AppColors.navyBlue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              DateFormat('MMM/d').format(tripModel.dayList[index].date!),
              style: TextStyle(
                color:
                    currentDayIndex == index ? Colors.white : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

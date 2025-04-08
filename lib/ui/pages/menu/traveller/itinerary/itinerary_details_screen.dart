import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/models/index.dart';

class ItineraryDetailsScreen extends StatefulWidget {
  final TripModel trip;
  const ItineraryDetailsScreen({super.key, required this.trip});

  @override
  State<StatefulWidget> createState() => _ItineraryDetailsScreenState();
}

class _ItineraryDetailsScreenState extends State<ItineraryDetailsScreen> {
  final weekdayStr = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun',
  };

  late TripModel trip;
  int currentDayIndex = 0;

  @override
  void initState() {
    super.initState();
    trip = widget.trip;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(trip.name),
      ),
      body: Column(
        children: [
          // Date selector
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: trip.dayList.length,
              itemBuilder: (context, index) {
                return _buildDateWidget(trip.dayList[index], index);
              },
            ),
          ),
          const Divider(height: 1),
          // Schedule list
          Expanded(
            child: ListView.builder(
              key: ValueKey(currentDayIndex),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: trip.dayList[currentDayIndex].detailsList!.length,
              itemBuilder: (context, index) {
                return _buildSchedule(
                  trip.dayList[currentDayIndex].detailsList![index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateWidget(TripSchedule schedule, int index) {
    final isSelected = currentDayIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentDayIndex = index;
        });
      },
      child: Container(
        width: 70, // Fixed width for each date item
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.navyBlue : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weekdayStr[schedule.date!.weekday]!,
              style: TextStyle(
                color: isSelected ? Colors.blue[700] : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat("MMM d").format(schedule.date!),
              style: TextStyle(
                color: isSelected ? Colors.blue[700] : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchedule(TripDetails schedule) {
    final timeText = '${schedule.time!.hour}:${schedule.time!.minute.toString().padLeft(2, '0')}';
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.access_time, size: 24, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.indigo[800]!,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),)
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    schedule.task.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    timeText,
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 14,
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:travel/constants/app_colors.dart';

class ScheduleItem extends StatefulWidget {
  final TimeOfDay? time;
  final String? task;
  final Function(String) onTaskChanged;
  final Function(TimeOfDay) onTimeChanged;

  const ScheduleItem({
    super.key,
    required this.time,
    required this.task,
    required this.onTaskChanged,
    required this.onTimeChanged,
  });

  @override
  State<StatefulWidget> createState() => _ScheduleItemState();
}

class _ScheduleItemState extends State<ScheduleItem> {
  late TimeOfDay? time;
  late TextEditingController _taskController;

  @override
  void initState() {
    super.initState();
    time = widget.time;
    _taskController = TextEditingController(text: widget.task);
  }

  Future<void> _timePicker() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: time == null ? TimeOfDay.now() : time!,
    );

    if (picked != null) {
      setState(() {
        time = picked;
        widget.onTimeChanged(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _timePicker(),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.navyBlue),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(
                    time == null
                        ? "[00:00]"
                        : "[${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}]",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.navyBlue), // Custom border
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 12,
              ), // Add padding inside the box
              child: TextField(
                controller: _taskController,
                onChanged: (newValue) {
                  widget.onTaskChanged(newValue);
                },
                decoration: InputDecoration(hintText: "[Task/Description]"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

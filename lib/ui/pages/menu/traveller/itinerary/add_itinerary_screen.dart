import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/models/index.dart';
import 'package:travel/ui/widgets/widgets.dart';

class AddItineraryScreen extends StatefulWidget {
  const AddItineraryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddItineraryScreen();
}

class _AddItineraryScreen extends State<AddItineraryScreen> {
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController(); 
  DateTime? _startDate;
  DateTime? _endDate;
  int _duration = 1;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = DateTime.now();
    _budgetController.text = '0.00'; // Initialize with default value
  }

  DateTime _getDefaultDateTime(bool isStartDate) {
    if (isStartDate && _startDate != null) {
      return _startDate!;
    } else if (!isStartDate && _endDate != null) {
      return _endDate!;
    }
    return DateTime.now();
  }

  Future<void> _datePicker(bool isStartDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _getDefaultDateTime(isStartDate),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked == null) {
      return;
    }

    bool isInvalid = false;
    if (isStartDate && _endDate != null) {
      int difference = _endDate!.difference(picked).inDays;
      isInvalid = difference < 0;
    } else if (!isStartDate && _startDate != null) {
      int difference = picked.difference(_startDate!).inDays;
      isInvalid = difference < 0;
    }

    if (isInvalid) {
      showMessageDialog(
        context: context,
        title: "Opps",
        message: "End date must bigger than start date",
      );
      return;
    }

    setState(() {
      if (isStartDate) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });

    if (_startDate != null && _endDate != null) {
      if (isSameDate(_startDate!, _endDate!)) {
        setState(() {
          _duration = 1;
        });
      } else {
        int difference = _endDate!.difference(_startDate!).inDays;
        setState(() {
          _duration = difference + 2;
        });
      }
    }
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _onSubmit() async {
    if (_nameController.text.trim().isEmpty ||
        _startDate == null ||
        _endDate == null || 
        _budgetController.text.isEmpty) {
      showMessageDialog(
        context: context,
        title: "Opps",
        message: "All fields are requried",
      );
      return;
    }

    final budget = double.tryParse(_budgetController.text) ?? 0.00;
    TripModel tripModel = TripModel(
      name: _nameController.text.trim(),
      startDate: _startDate!,
      endDate: _endDate!,
      budget: budget,
      dayList: List.generate(
        _duration,
        (index) => TripSchedule(date: _startDate!.add(Duration(days: index))),
      ),
    );

    final result = await GoRouter.of(
      context,
    ).push('/addItineraryDetail', extra: {'tripModel': tripModel});
    if (result == true) {
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
          onPressed: () => context.pop(false),
        ),
        title: Text("Add Itinerary"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              const Text(
                'Trip Name',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Name your trip',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              _buildDatePicker(true),
              const SizedBox(height: 15),
              _buildDatePicker(false),
              const SizedBox(height: 24),
              Text(
                'Duration: $_duration Days',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Total Budget',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _budgetController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  hintText: 'Enter total budget',
                  //prefixText: 'RM ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ButtonAction(
                  label: "Next",
                  onPressed: () => _onSubmit(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(bool isStartDate) {
    DateTime? dt = isStartDate ? _startDate : _endDate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isStartDate ? "Start Date" : "End Date",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _datePicker(isStartDate),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(color: Colors.grey, width: 1.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dt == null
                      ? 'Select start date'
                      : DateFormat('d/M/yyyy').format(dt),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

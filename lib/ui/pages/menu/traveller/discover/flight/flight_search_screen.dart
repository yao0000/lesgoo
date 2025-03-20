import 'package:flutter/material.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/ui/widgets/traveller/traveller_app_bar.dart';
import 'package:travel/data/models/airport_model.dart';
import 'package:travel/data/repositories/airport_repository.dart';

class FlightSearchScreen extends StatefulWidget {
  const FlightSearchScreen({super.key});

  @override
  State<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen> {
  bool isRoundTrip = false;
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController returnController = TextEditingController();
  final TextEditingController passengerController = TextEditingController();
  String selectedClass = "Economy";

  List<AirportModel>? airportList = [];

  @override
  void initState() {
    super.initState();
    _loadAirports();
  }

  Future<void> _loadAirports() async {
    airportList = await AirportRepository.getList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: TravellerAppBar(title: "Book Your Flights"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Text("One Way"),
                  selected: !isRoundTrip,
                  onSelected: (selected) => setState(() => isRoundTrip = !selected),
                  selectedColor: Colors.orange,
                ),
                SizedBox(width: 10),
                ChoiceChip(
                  label: Text("Round Trip"),
                  selected: isRoundTrip,
                  onSelected: (selected) => setState(() => isRoundTrip = selected),
                  selectedColor: Colors.orange,
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildAirportSearchField("From", fromController)),
                      SizedBox(width: 10),
                      Expanded(child: _buildAirportSearchField("To", toController)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _buildTextField("Date", dateController, isDate: true)),
                      if (isRoundTrip) ...[
                        SizedBox(width: 10),
                        Expanded(child: _buildTextField("Return", returnController, isDate: true)),
                      ]
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _buildTextField("Passengers", passengerController)),
                      SizedBox(width: 10),
                      Expanded(child: _buildDropdown("Class")),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            FloatingActionButton(
              backgroundColor: Colors.yellow,
              child: Icon(Icons.search, color: Colors.black),
              onPressed: () {
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAirportSearchField(String label, TextEditingController controller) {
    return Autocomplete<AirportModel>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<AirportModel>.empty();
        }
        return airportList!.where((airport) =>
            airport.description.toLowerCase().contains(textEditingValue.text.toLowerCase()) ||
            airport.id.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      displayStringForOption: (AirportModel option) => "${option.description} (${option.id})",
      onSelected: (AirportModel selection) {
        controller.text = "${selection.description} (${selection.id})";
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isDate = false}) {
    return TextField(
      controller: controller,
      readOnly: isDate,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onTap: isDate
          ? () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                setState(() {
                  controller.text = pickedDate.toString().split(" ")[0];
                });
              }
            }
          : null,
    );
  }

  Widget _buildDropdown(String label) {
    return DropdownButtonFormField<String>(
      value: selectedClass,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: ["Economy", "Business"].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          selectedClass = newValue!;
        });
      },
    );
  }
}

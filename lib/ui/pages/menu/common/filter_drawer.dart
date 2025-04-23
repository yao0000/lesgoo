import 'package:flutter/material.dart';
import 'package:travel/ui/widgets/widgets.dart';

class FilterDrawer extends StatefulWidget {
  final Function(String) toggleState;
  final Map<String, bool> filterState;
  final bool isCar;

  const FilterDrawer({
    super.key,
    required this.toggleState,
    required this.filterState,
    required this.isCar,
  });

  @override
  State<StatefulWidget> createState() => _FilterDrawer();
}

class _FilterDrawer extends State<FilterDrawer> {
  late Map<String, bool> localFilterState;

  @override
  void initState() {
    super.initState();
    localFilterState = Map.from(widget.filterState);
  }

  void toggleState(String key) {
    setState(() {
      localFilterState[key] = !localFilterState[key]!;
      widget.toggleState(key);
      if (key == 'desc' &&
          localFilterState[key]! == true &&
          localFilterState['asc'] == true) {
        toggleState('asc');
      } else if (key == 'asc' &&
          localFilterState[key]! == true &&
          localFilterState['desc'] == true) {
        toggleState('desc');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Container(
        padding: EdgeInsets.all(16), // Optional padding for styling
        width: double.infinity, // Ensure the parent container takes full width
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Sort by", style: TextStyle(fontWeight: FontWeight.bold)),

            // Ensure Sort Buttons Take Full Width
            SizedBox(
              width: double.infinity, // Force full width
              child: Column(
                children: [
                  ButtonAction(
                    onPressed: () => toggleState('desc'),
                    label: "From Highest Price to Lowest",
                    isSelected: localFilterState['desc'] ?? false,
                  ),
                  ButtonAction(
                    onPressed: () => toggleState('asc'),
                    label: "From Lowest Price to Highest",
                    isSelected: localFilterState['asc'] ?? false,
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),
            Text("Ratings", style: TextStyle(fontWeight: FontWeight.bold)),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ButtonAction(
                  onPressed: () => toggleState('5'),
                  label: "5 Star",
                  isSelected: localFilterState['5'] ?? false,
                ),
                ButtonAction(
                  onPressed: () => toggleState('4'),
                  label: "4 Star",
                  isSelected: localFilterState['4'] ?? false,
                ),
                ButtonAction(
                  onPressed: () => toggleState('3'),
                  label: "3 Star",
                  isSelected: localFilterState['3'] ?? false,
                ),
                ButtonAction(
                  onPressed: () => toggleState('2'),
                  label: "2 Star",
                  isSelected: localFilterState['2'] ?? false,
                ),
              ],
            ),
            if (widget.isCar)
              Text("Seats", style: TextStyle(fontWeight: FontWeight.bold)),
            if (widget.isCar)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ButtonAction(
                    onPressed: () => toggleState('7s'),
                    label: "7 Seats",
                    isSelected: localFilterState['7s'] ?? false,
                  ),
                  ButtonAction(
                    onPressed: () => toggleState('5s'),
                    label: "5 Seats",
                    isSelected: localFilterState['5s'] ?? false,
                  ),
                ],
              ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Apply"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

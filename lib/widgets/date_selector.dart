import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// A StatefulWidget that allows users to select a date.
class DateSelector extends StatefulWidget {
  // Callback function to be called when a date is selected.
  final Function(DateTime) onDateSelected;
  // Formatted date string to display.
  final String formattedDate;

  // Constructor with required fields.
  const DateSelector({
    super.key,
    required this.onDateSelected,
    required this.formattedDate,
  });

  @override
  DateSelectorState createState() => DateSelectorState();
}

// State class for DateSelector.
class DateSelectorState extends State<DateSelector> {
  // Holds the currently selected date.
  DateTime _selectedDate = DateTime.now();
  // Controls the expansion state of the ExpansionTile.
  bool _isExpanded = true;

  // Handles tap events on date tiles.
  void _onDateTap(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onDateSelected(date); // Trigger callback with selected date.
  }

  // Builds a tile representing a single date.
  Widget _buildDateTile(DateTime date, bool isSelected) {
    final dateNumber = DateFormat('d').format(date); // Extracts the day number.
    final day = DateFormat('EEE')
        .format(date)
        .substring(0, 3); // Extracts the day's name.

    return GestureDetector(
      onTap: () => _onDateTap(date),
      child: Container(
        // Styling for the date tile.
        margin: const EdgeInsets.symmetric(horizontal: 5),
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isSelected ? const Color(0xffeb6081) : const Color(0xFFeff0f4),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dateNumber,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                day,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Theme(
            data: ThemeData(dividerColor: Colors.transparent),
            child: Material(
              color: Colors
                  .transparent, // Makes Material widget background transparent.
              child: ExpansionTile(
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    _isExpanded = expanded;
                  });
                },
                initiallyExpanded: _isExpanded,
                trailing: RotatedBox(
                  quarterTurns: _isExpanded ? 0 : 2,
                  child: const Icon(
                    Icons.expand_more,
                    color: Color(0xffeb6081),
                  ),
                ),
                title: Text(
                  'Today, ${widget.formattedDate}', // Displaying formatted date.
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
                children: [
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          7, // Builds a list of 7 days starting from today.
                      itemBuilder: (BuildContext context, int index) {
                        DateTime date =
                            DateTime.now().add(Duration(days: index));
                        return _buildDateTile(
                            date, date.isSameDay(_selectedDate));
                      },
                    ),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}

// Extension on DateTime to check if two dates are the same day.
extension DateTimeExtension on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

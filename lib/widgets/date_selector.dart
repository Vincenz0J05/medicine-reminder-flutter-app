import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  final String formattedDate;

  const DateSelector({
    super.key,
    required this.formattedDate,
  });

  @override
  DateSelectorState createState() => DateSelectorState();
}

class DateSelectorState extends State<DateSelector> {
  bool _isExpanded = true;
  DateTime _selectedDate = DateTime.now();

  void _onDateTap(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  Widget _buildDateTile(DateTime date, bool isSelected) {
    final dateNumber = DateFormat('d').format(date);
    final day = DateFormat('EEE').format(date).substring(0, 3);

    return GestureDetector(
      onTap: () => _onDateTap(date),
      child: Container(
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
                  .transparent, // Set the color of Material to transparent
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
                  'Today, ${widget.formattedDate}',
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
                      itemCount: 7,
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

extension DateTimeExtension on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

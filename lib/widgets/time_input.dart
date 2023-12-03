import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TimeInputWidget extends StatefulWidget {
  final Function(List<Timestamp>) onTimeChanged;

  const TimeInputWidget({super.key, required this.onTimeChanged});

  @override
  TimeInputWidgetState createState() => TimeInputWidgetState();
}

class TimeInputWidgetState extends State<TimeInputWidget> {
  List<Widget> timeInputFields = [];
  List<Timestamp> reminderTimes = [];

  @override
  void initState() {
    super.initState();
    addTimeInputField(isInitial: true);
  }

  void addTimeInputField({bool isInitial = false}) {
    setState(() {
      int newIndex = timeInputFields.length;
      timeInputFields.add(createTimeInputField(index: newIndex, isRemovable: !isInitial));
      reminderTimes.add(Timestamp.now()); // Add a default value, adjust as needed
    });
  }

  void removeTimeInputField(int index) {
    setState(() {
      timeInputFields.removeAt(index);
      reminderTimes.removeAt(index);
      widget.onTimeChanged(reminderTimes);
    });
  }

  Widget createTimeInputField({required int index, bool isRemovable = false}) {
    TextEditingController timeController = TextEditingController();

    void handleTimeSelection() async {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Format the picked time and update the text field
        String formattedTime = pickedTime.format(context);
        timeController.text = formattedTime;

        // Convert TimeOfDay to Timestamp
        DateTime now = DateTime.now();
        DateTime selectedDateTime = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
        Timestamp timestamp = Timestamp.fromDate(selectedDateTime);

        // Update the specific index in the reminderTimes list
        reminderTimes[index] = timestamp;
        widget.onTimeChanged(reminderTimes); // Update the parent widget
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text('Gewenste tijd instellen'),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: timeController,
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.alarm_sharp),
                  hintText: '09:00',
                ),
                onTap: handleTimeSelection,
              ),
            ),
            const SizedBox(width: 15),
            if (isRemovable)
              IconButton(
                onPressed: () => removeTimeInputField(index),
                icon: const Icon(Icons.remove, color: Colors.red),
              )
            else
              IconButton(
                onPressed: addTimeInputField,
                icon: const Icon(Icons.add, color: Colors.green),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: timeInputFields.length,
            itemBuilder: (context, index) {
              return timeInputFields[index];
            },
          ),
        ),
      ],
    );
  }
}

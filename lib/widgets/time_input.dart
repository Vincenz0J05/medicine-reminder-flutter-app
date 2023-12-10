import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// A StatefulWidget that allows users to input multiple times.
class TimeInputWidget extends StatefulWidget {
  // Callback function to be called when time values change.
  final Function(List<Timestamp>) onTimeChanged;

  // Constructor with required onTimeChanged callback.
  const TimeInputWidget({super.key, required this.onTimeChanged});

  @override
  TimeInputWidgetState createState() => TimeInputWidgetState();
}

class TimeInputWidgetState extends State<TimeInputWidget> {
  // List of time input field widgets.
  List<Widget> timeInputFields = [];
  // List of selected time values as Timestamps.
  List<Timestamp> reminderTimes = [];

  @override
  void initState() {
    super.initState();
    // Add the initial time input field on widget initialization.
    addTimeInputField(isInitial: true);
  }

  // Function to add a new time input field.
  void addTimeInputField({bool isInitial = false}) {
    setState(() {
      int newIndex = timeInputFields.length;
      // Add new time input field to the list.
      timeInputFields
          .add(createTimeInputField(index: newIndex, isRemovable: !isInitial));
      // Add a default value (current time) to the reminder times.
      reminderTimes.add(Timestamp.now());
    });
  }

  // Function to remove a time input field at a specific index.
  void removeTimeInputField(int index) {
    setState(() {
      timeInputFields.removeAt(index); // Remove the field from the list.
      reminderTimes
          .removeAt(index); // Remove the corresponding time from the list.
      widget
          .onTimeChanged(reminderTimes); // Notify parent widget of the change.
    });
  }

  // Function to create a time input field.
  Widget createTimeInputField({required int index, bool isRemovable = false}) {
    TextEditingController timeController = TextEditingController();

    // Function to handle time selection using a time picker.
    void handleTimeSelection() async {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        String formattedTime =
            pickedTime.format(context); // Format the picked time.
        timeController.text =
            formattedTime; // Update the text field with the formatted time.

        // Convert the selected time to a Timestamp.
        DateTime now = DateTime.now();
        DateTime selectedDateTime = DateTime(
            now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
        Timestamp timestamp = Timestamp.fromDate(selectedDateTime);

        // Update the specific index in the reminderTimes list.
        reminderTimes[index] = timestamp;
        widget.onTimeChanged(
            reminderTimes); // Notify the parent widget of the change.
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
            'Gewenste tijd instellen'), // Label for the time input field.
        Row(
          children: [
            Expanded(
              // TextField for time input.
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
                onTap: handleTimeSelection, // Open time picker on tap.
              ),
            ),
            const SizedBox(width: 15),
            // Button to add or remove a time input field.
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
          // ListView to display all the time input fields.
          fit: FlexFit.loose,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: timeInputFields.length,
            itemBuilder: (context, index) {
              // Renders each time input field.
              return timeInputFields[index];
            },
          ),
        ),
      ],
    );
  }
}

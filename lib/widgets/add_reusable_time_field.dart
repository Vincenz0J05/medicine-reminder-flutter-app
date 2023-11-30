import 'package:flutter/material.dart';

class TimeInputWidget extends StatefulWidget {
  const TimeInputWidget({super.key});

  @override
  TimeInputWidgetState createState() => TimeInputWidgetState();
}

class TimeInputWidgetState extends State<TimeInputWidget> {
  List<Widget> timeInputFields = [];

  @override
  void initState() {
    super.initState();
    // Add the initial time input field
    timeInputFields.add(createTimeInputField());
  }

  Widget createTimeInputField({bool isRemovable = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text('Gewenste tijd instellen'),
        Row(
          children: [
            Expanded(
              child: inputStyle(
                prefixIcon: Icons.alarm_sharp,
                hintText: '09:00',
              ),
            ),
            const SizedBox(width: 15),
            if (isRemovable)
              IconButton(
                onPressed: () => removeTimeInputField(),
                icon: const Icon(Icons.remove, color: Colors.red),
              )
            else
              IconButton(
                onPressed: () => addTimeInputField(),
                icon: const Icon(Icons.add, color: Colors.green),
              ),
            const SizedBox(
              height: 80,
            )
          ],
        ),
      ],
    );
  }

  void addTimeInputField() {
    setState(() {
      timeInputFields.add(createTimeInputField(isRemovable: true));
    });
  }

  void removeTimeInputField() {
    if (timeInputFields.length > 1) {
      setState(() {
        timeInputFields.removeLast();
      });
    }
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

  Widget inputStyle({
    IconData? prefixIcon,
    String? hintText,
  }) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(prefixIcon),
        hintText: hintText,
      ),
    );
  }
}

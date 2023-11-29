import 'package:flutter/material.dart';
import 'package:medication_reminder_app/screens/create_medication_screen.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: const Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly, // Ensures even spacing
        children: [
          Expanded(child: Icon(Icons.home, size: 30)),
          FloatingActionButton(
            backgroundColor: const Color(0xffeb6081),
            onPressed: () => _onButtonPressed(context),
            elevation: 0, // Remove the default shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            mini: false,
            child: Icon(Icons.add, color: Colors.white),
          ),
          Expanded(child: Icon(Icons.history, size: 30)),
        ],
      ),
    );
  }

  
}

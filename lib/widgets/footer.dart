import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  final VoidCallback onButtonPressed;

  const Footer({super.key, required this.onButtonPressed});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Expanded(child: Icon(Icons.home, size: 30)),
          FloatingActionButton(
            backgroundColor: const Color(0xffeb6081),
            onPressed: () => widget.onButtonPressed(),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            mini: false,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const Expanded(child: Icon(Icons.history, size: 30)),
        ],
      ),
    );
  }
}

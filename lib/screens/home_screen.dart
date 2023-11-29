import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/date_selector.dart';
import '../widgets/footer.dart';
import '../widgets/medication_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            DateSelector(
              formattedDate: DateFormat('dd MMMM').format(DateTime.now()),
            ),
            const MedicationCard(),
            // Any other widgets you want to include in your home screen
          ],
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}

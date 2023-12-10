import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medication_reminder_app/models/medicine.dart';
import 'package:medication_reminder_app/screens/medication_info_screen.dart';
import '../services/medication_service.dart';

// A StatelessWidget that displays medication information as a card.
class MedicationCard extends StatelessWidget {
  // The selected date for which medication needs to be shown.
  final DateTime selectedDate;

  // Constructor with required selectedDate parameter.
  const MedicationCard({
    super.key,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    // Stream to fetch medication data from Firestore.
    Stream<QuerySnapshot> medicationStream =
        MedicationService().fetchMedicine(selectedDate);

    return StreamBuilder<QuerySnapshot>(
      stream: medicationStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Displays an error message if there's an error in the stream.
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          // Shows a progress indicator while data is loading.
          return const CircularProgressIndicator();
        }

        // Maps the snapshot data to Medicine objects.
        final medications = snapshot.data!.docs.map((doc) {
          return Medicine.fromFirestore(doc);
        }).toList();

        return Column(
          children: [
            _buildHeader(), // Header widget for the medication card.
            Column(
              // Builds a list of medication cards from the fetched data.
              children: medications.map((medicine) {
                return _buildMedicationCard(context, medicine);
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  // Builds individual medication card widget.
  Widget _buildMedicationCard(BuildContext context, Medicine medicine) {
    // Formatting the reminder time for display.
    DateTime reminderDateTime = medicine.reminderTime.isNotEmpty
        ? medicine.reminderTime.first.toDate()
        : DateTime.now();
    String formattedTime = DateFormat('HH:mm').format(reminderDateTime);

    return Container(
      // Styling for the medication card container.
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFeff0f4),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          _buildImageContainer(
              medicine.image), // Image container for the medicine.
          Expanded(
            // Details section for the medication card.
            child: _buildMedicationDetails(context, medicine, formattedTime),
          ),
        ],
      ),
    );
  }

  // Builds the header for the medication card list.
  Widget _buildHeader() {
    return Container(
      // Styling for the header container.
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(left: 15, top: 30),
      child: const Text(
        'To take',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Builds the image container for the medication card.
  Widget _buildImageContainer(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        // Styling for the image container.
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Image.asset(imageUrl), // Loads the image from the provided URL.
      ),
    );
  }

  // Builds the details section for the medication card.
  Widget _buildMedicationDetails(
      BuildContext context, Medicine medicine, String formattedTime) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Displays the name and dosage of the medication.
          Text(
            '${medicine.name}, ${medicine.dosage}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Shows the formatted reminder time.
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time_filled, size: 15),
                  Text(formattedTime),
                ],
              ),
              const SizedBox(width: 100),
              // Button to navigate to the medication details page.
              IconButton(
                icon: const Icon(
                  Icons.info,
                  size: 18,
                  color: Color(0xffeb6081),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          MedicationDetailsPage(medicine: medicine),
                    ),
                  );
                },
                padding: const EdgeInsets.all(0),
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

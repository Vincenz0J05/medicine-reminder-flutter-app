import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medication_reminder_app/models/medicine.dart';
import '../services/medication_service.dart';
import '../screens/medication_info_screen.dart';

class MedicationCard extends StatelessWidget {
  const MedicationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: MedicationService().fetchMedicine(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final medications = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Medicine.fromJson(
              data); // Assuming you have a fromJson constructor in Medicine model
        }).toList();

        return Column(
          children: [
            _buildHeader(),
            Column(
              children: medications.map((medicine) {
                return _buildMedicationCard(context, medicine);
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMedicationCard(BuildContext context, Medicine medicine) {
    // Convert Timestamp to DateTime
    DateTime reminderDateTime = medicine.reminderTime[0].toDate();
    // Format the DateTime to only show hours and minutes
    String formattedTime = DateFormat('HH:mm').format(reminderDateTime);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFeff0f4),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              _buildImageContainer(medicine.image),
              _buildMedicationDetails(
                  context, medicine.name, medicine.dosage, formattedTime, medicine),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(left: 15, top: 30),
      child: const Text(
        'To take',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildImageContainer(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Image.asset(imageUrl), // Use the provided image URL
      ),
    );
  }

  Widget _buildMedicationDetails(BuildContext context, name, String dosage,
      String formattedTime, Medicine medicine) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$name, $dosage',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
                height: 4), // Space between the text and the time row
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.access_time_filled, size: 16),
                const SizedBox(width: 5),
                Text(
                  formattedTime,
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(), // This will push the IconButton to the far right
                IconButton(
                  icon: const Icon(
                    Icons.info,
                    size: 18,
                    color: Color(0xffeb6081),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MedicationDetailsPage(
                              medicine: medicine,
                            )));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

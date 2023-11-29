import 'package:flutter/material.dart';

class MedicationCard extends StatefulWidget {

  const MedicationCard({Key? key}) : super(key: key);

  @override
  MedicationCardState createState() => MedicationCardState();
}

class MedicationCardState extends State<MedicationCard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          _buildMedicationCard(context),
        ],
      ),
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

  Widget _buildMedicationCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFeff0f4),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          _buildImageContainer(),
          _buildMedicationDetails(),
        ],
      ),
    );
  }

  Widget _buildImageContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Image.asset('assets/images/black-outlined-bottle.png'),
      ),
    );
  }

  Widget _buildMedicationDetails() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Medication Name, Dosage',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimeRow(),
              _buildInfoIcon(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow() {
    return const Row(
      children: [
        Icon(Icons.access_time_filled, size: 15),
        SizedBox(width: 5),
        Text('Time Here'),
      ],
    );
  }

  Widget _buildInfoIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: () {
          // Action for info icon tap
        },
        child: const Icon(
          Icons.info,
          color: Color(0xffeb6081),
        ),
      ),
    );
  }
}

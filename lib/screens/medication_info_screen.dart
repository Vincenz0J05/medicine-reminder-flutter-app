import 'package:flutter/material.dart';
import 'package:medication_reminder_app/services/medication_service.dart';
import '../models/medicine.dart'; // Make sure this import path is correct

class MedicationDetailsPage extends StatefulWidget {
  final Medicine medicine;

  const MedicationDetailsPage({super.key, required this.medicine});

  @override
  MedicationDetailsPageState createState() => MedicationDetailsPageState();
}

class MedicationDetailsPageState extends State<MedicationDetailsPage> {
  @override
  Widget build(BuildContext context) {
    // Get the size of the screen (or parent widget)
    var screenSize = MediaQuery.of(context).size;

    // Calculate the size of the image
    var imageWidth =
        screenSize.width * 0.5; // for example 50% of the screen width
    var imageHeight =
        imageWidth * (3 / 4); // maintain the aspect ratio of the image

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terug',
          style: TextStyle(color: Color(0xffeb6081), fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xffeb6081),
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.delete_forever_outlined,
              color: Color(0xffeb6081),
              size: 30,
            ),
            onPressed: () async {
              // Confirm before deleting
              bool confirmDelete = await showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Verijder herrinering'),
                    content: const Text(
                        'Weet u zeker dat u deze herrinering wilt verwijderen?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Verwijder'),
                        onPressed: () {
                          Navigator.of(dialogContext)
                              .pop(true); // Dismiss and return true
                        },
                      ),
                      TextButton(
                        child: const Text('Annuleer'),
                        onPressed: () {
                          Navigator.of(dialogContext)
                              .pop(false); // Dismiss and return false
                        },
                      ),
                    ],
                  );
                },
              );

              // If delete is confirmed
              if (confirmDelete) {
                String? medicineId = widget.medicine.id;
                if (medicineId != null) {
                  try {
                    MedicationService medicationService = MedicationService();
                    await medicationService.deleteMedicine(medicineId);
                    Navigator.of(context)
                        .pop(); // Go back to the previous screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Medicijne succesvol verwijderd')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Niet gelukt om het medicijne te verwijderen: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Medicine ID is null')),
                  );
                }
              }
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenSize.height * 0.02), // space from the top
            SizedBox(
              width: imageWidth,
              height: imageHeight,
              child: Image.asset(
                widget.medicine.image, // Replace with the actual image path
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.medicine.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.medicine.dosage,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the circle
                    shape: BoxShape.circle, // Makes the container a circle
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(
                            0.5), // Shadow color with some transparency
                        spreadRadius: 2, // Spread radius of the shadow
                        blurRadius: 5, // Blur radius of the shadow
                        offset: const Offset(0, 3), // Position of the shadow
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.edit_note_outlined,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      //TODO add update operation
                    }, // Icon color
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color(0xFFeff0f4),
                    ),
                    child: Center(
                        child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.medication,
                          color: Color(0xffe83395),
                          size: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.medicine.dosage,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Text('Dagdosis')
                          ],
                        )
                      ],
                    )),
                  ),
                ),
                const SizedBox(
                    width:
                        10), // This will provide spacing between the two containers
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color(0xFFeff0f4),
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.watch_later,
                            color: Color(0xff1d71d2),
                            size: 30,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.medicine.amount,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const Text('Elke dag')
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

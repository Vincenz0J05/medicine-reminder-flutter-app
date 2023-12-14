import 'package:flutter/material.dart';
import 'package:medication_reminder_app/screens/home_screen.dart';
import 'package:medication_reminder_app/services/medication_service.dart';
import '../models/medicine.dart';

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
        screenSize.width * 0.5; // for example, 50% of the screen width
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
                            content: Text('Medicijn succesvol verwijderd')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Niet gelukt om het medicijne te verwijderen: $e')),
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: screenSize.height * 0.02), // space from the top

              // Display the medication image
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

                  // Edit button
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
                        // Navigate to the HomeScreen for editing
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen(medicineToEdit: widget.medicine),
                          ),
                        );
                      },
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
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
              ),
              const SizedBox(height: 20),
              const Text('Agenda',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),

// Fixed height container with scrollable ListView inside
              Container(
                height: 200, // Set a fixed height for the container
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: const Color(0xFFeff0f4),
                ),
                child: ListView.builder(
                  padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
                  itemCount: 10, // Adjust the item count as needed
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${(index + 1) * 3 + 7}:00', // Placeholder for time
                            style: const TextStyle(
                                color: Color(0xffeb6081),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          Transform.scale(
                            scale: 1,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Checkbox(
                                  shape: const CircleBorder(),
                                  value: false, // Adjust based on your logic
                                  onChanged: (bool? newValue) {
                                    // Add your onChanged logic here
                                  },
                                  activeColor: Colors.green,
                                  checkColor: Colors.green,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                const Icon(Icons.check,
                                    size: 12,
                                    color: Colors
                                        .white), // Adjust the size as needed
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              InkWell(
                onTap: () {
                  print('Pill button pressed');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20), // Reduced horizontal padding
                  decoration: BoxDecoration(
                    color: const Color(0xffeb6081), // Button color
                    borderRadius: BorderRadius.circular(
                        30), // High border radius for pill shape
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Center the contents horizontally
                      children: [
                        Icon(Icons.camera_alt_outlined, color: Colors.white),
                        SizedBox(width: 10), // Spacing between icon and text
                        Text(
                          "Scan Barcode",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ])));
  }
}

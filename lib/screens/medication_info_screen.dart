import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:medication_reminder_app/screens/home_screen.dart';
import 'package:medication_reminder_app/services/medication_service.dart';
import 'package:http/http.dart' as http;
import '../models/medicine.dart';

class MedicationDetailsPage extends StatefulWidget {
  final Medicine medicine;

  const MedicationDetailsPage({super.key, required this.medicine});

  @override
  MedicationDetailsPageState createState() => MedicationDetailsPageState();
}

class MedicationDetailsPageState extends State<MedicationDetailsPage> {
  List<bool> checkedState = [];

  @override
  void initState() {
    super.initState();
    // Initialize the checked states for each reminder time to be unchecked (false)
    checkedState =
        List<bool>.filled(widget.medicine.reminderTime.length, false);
  }

  // Converts the list of Timestamps to a list of formatted time strings
  List<String> formatReminderTimes(List<Timestamp> reminderTimes) {
    return reminderTimes
        .map((timestamp) => DateFormat('HH:mm').format(timestamp.toDate()))
        .toList();
  }

  // Function to initiate the barcode scanning process
  Future<void> scanBarcodeAndFetchData() async {
    String barcode;
    try {
      // Trigger the barcode scanner
      barcode = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      if (barcode == "-1") {
        print("Scan cancelled"); // Log scan cancellation
      } else {
        fetchDataFromAPI(barcode); // Fetch data using the scanned barcode
      }
    } catch (e) {
      print('Barcode scan error: $e'); // Log any errors during barcode scanning
    }
  }

  // Fetch data from the FDA API using the barcode
  Future<void> fetchDataFromAPI(String barcode) async {
    var url = Uri.parse(
        'https://api.fda.gov/drug/label.json?search=openfda.product_ndc:"$barcode"');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        showFetchedDataBottomSheet(
            data); // Display the fetched data in a bottom sheet
      } else {
        print('API call failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('API call error: $e'); // Log any API call errors
    }
  }

  // Function to show a bottom sheet with the fetched medication data
  void showFetchedDataBottomSheet(Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        // Creating a list of widgets to display medication information
        return Container(
          padding: const EdgeInsets.all(10),
          child: ListView(
            // List of ListTile widgets to display different pieces of medication data
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.label),
                title: const Text('Product Name'),
                subtitle: Text(data['results'][0]['openfda']['brand_name'][0] ??
                    'Not available'),
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Active Ingredient'),
                subtitle: Text(data['results'][0]['active_ingredient'][0] ??
                    'Not available'),
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Purpose'),
                subtitle:
                    Text(data['results'][0]['purpose'][0] ?? 'Not available'),
              ),
              ListTile(
                leading: const Icon(Icons.local_hospital),
                title: const Text('Uses (Indications and Usage)'),
                subtitle: Text(data['results'][0]['indications_and_usage'][0] ??
                    'Not available'),
              ),
              ListTile(
                leading: const Icon(Icons.warning),
                title: const Text('Warnings'),
                subtitle:
                    Text(data['results'][0]['warnings'][0] ?? 'Not available'),
              ),
              ListTile(
                leading: const Icon(Icons.not_interested),
                title: const Text('Do Not Use'),
                subtitle: Text(
                    data['results'][0]['do_not_use'][0] ?? 'Not available'),
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Ask Doctor'),
                subtitle: Text(
                    data['results'][0]['ask_doctor'][0] ?? 'Not available'),
              ),
            ],
          ),
        );
      },
    );
  }

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

              // ListView.builder to display reminder times with checkboxes
              Container(
                height: 200,
                // ... container styling
                child: ListView.builder(
                  padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
                  itemCount: widget.medicine.reminderTime.length,
                  itemBuilder: (context, index) {
                    // Formatting each reminder time for display
                    String formattedTime =
                        widget.medicine.reminderTime.isNotEmpty
                            ? formatReminderTimes(
                                widget.medicine.reminderTime)[index]
                            : 'No time set';

                    // Row for each reminder time with a corresponding checkbox
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedTime,
                            style: const TextStyle(
                                color: Color(0xffeb6081),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          Checkbox(
                            value: checkedState[index],
                            onChanged: (bool? newValue) {
                              // Update the state when the checkbox is toggled
                              setState(() {
                                checkedState[index] = newValue ?? false;
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),
              InkWell(
                onTap: () {
                  fetchDataFromAPI('50090-4273');
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

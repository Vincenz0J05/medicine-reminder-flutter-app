import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medication_reminder_app/models/medicine.dart';
import 'package:medication_reminder_app/widgets/time_input.dart';
import 'package:medication_reminder_app/widgets/medication_card.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../widgets/date_selector.dart';
import '../widgets/footer.dart';
import '../widgets/input_style.dart';
import '../services/medication_service.dart';

class HomeScreen extends StatefulWidget {
  final Medicine? medicineToEdit;
  const HomeScreen(
      {super.key, this.medicineToEdit}); // Constructor for HomeScreen

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Form key for validation
  final ValueNotifier<int> selectedImageIndexNotifier = ValueNotifier<int>(-1);
  final List<String> _allDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  // List of image URLs for medication images
  List imageUrls = [
    'assets/images/—Pngtree—pharmacy drug health tablet pharmaceutical_6861618.png',
    'assets/images/black-outlined-bottle.png',
    'assets/images/black-outlined-pill.png',
    'assets/images/blue-pill.png',
    'assets/images/blue-yellow-tablet.png',
    'assets/images/colored-bottle.png',
    'assets/images/green-pill.png',
    'assets/images/orange-tablet.png',
    'assets/images/pink-pill.png',
    'assets/images/pink-tablet.png',
    'assets/images/white-tablet.png',
  ];

  // Controllers for medication input fields
  final TextEditingController _medicationNameController =
      TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();

  List<String> _selectedDays = []; // List to store selected days
  List<Timestamp> _reminderTimes = []; // List to store reminder times
  String selectedImageUrl = ''; // Selected medication image URL

  DateTime _selectedDate = DateTime.now(); // Selected date for medication

  // Function to show the medication input form as a bottom sheet
  void _showFormBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _buildMedicationFormSheet(context);
      },
    );
  }

  // Function to update the reminder times
  void _updateReminderTime(List<Timestamp> times) {
    setState(() {
      _reminderTimes = times;
    });
  }

  // Function to update the selected medication image URL
  void _updateSelectedImageUrl(int index) {
    setState(() {
      selectedImageIndexNotifier.value = index;
      selectedImageUrl = imageUrls[index];
    });
  }

  // Function to handle date selection
  void _onDateSelected(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.medicineToEdit != null) {
      // If editing an existing medicine, populate input fields
      _medicationNameController.text = widget.medicineToEdit!.name;
      _quantityController.text = widget.medicineToEdit!.amount;
      _doseController.text = widget.medicineToEdit!.dosage;
      _selectedDays = widget.medicineToEdit!.days;
      _reminderTimes = widget.medicineToEdit!.reminderTime;
      selectedImageUrl = widget.medicineToEdit!.image;
      // Trigger the bottom sheet to show after the build is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showFormBottomSheet();
      });
    }
  }

  // Function to build the medication input form as a bottom sheet
  Widget _buildMedicationFormSheet(BuildContext context) {
    return SizedBox(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Header with back button and title
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xffeb6081),
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      constraints: const BoxConstraints(),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Plan je medicijn inname in',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xffeb6081),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Medicijn Naam'),
                    const SizedBox(
                      height: 8,
                    ),
                    // Input field for medication name
                    inputStyle(
                      prefixIcon: Icons.medication_rounded,
                      hintText: 'Paracetamol/Hoestdrank',
                      controller: _medicationNameController,
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Hoeveelheid'),
                          const SizedBox(height: 8),
                          // Input field for medication quantity
                          inputStyle(
                              prefixIcon: Icons.medical_information,
                              hintText: '1 pil/tablet',
                              controller: _quantityController)
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Dosis'),
                          const SizedBox(
                            height: 8,
                          ),
                          // Input field for medication dosage
                          inputStyle(
                              prefixIcon: Icons.my_library_add_rounded,
                              hintText: '500mg/ml',
                              controller: _doseController),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // MultiSelect widget for selecting days
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MultiSelectBottomSheetField(
                      initialChildSize: 0.7,
                      maxChildSize: 0.95,
                      listType: MultiSelectListType.CHIP,
                      searchable: true,
                      buttonText: const Text('Welke dag(en)'), // Button text
                      title: const Text('Dagen'), // Title for the selection
                      items: _allDays
                          .map((day) => MultiSelectItem(day, day))
                          .toList(),
                      onConfirm: (values) {
                        // Callback when days are confirmed
                        setState(() {
                          _selectedDays = List<String>.from(values);
                        });
                      },
                      chipDisplay: MultiSelectChipDisplay(
                        onTap: (value) {
                          setState(() {
                            _selectedDays.remove(value);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // TimeInputWidget for selecting reminder times
                TimeInputWidget(
                  onTimeChanged: _updateReminderTime,
                ),

                const SizedBox(height: 12),

                // Medication image selection
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Uiterlijk'), // Title for medication image
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _updateSelectedImageUrl(
                                  index); // Update the selected image URL
                            },
                            child: ValueListenableBuilder<int>(
                              valueListenable: selectedImageIndexNotifier,
                              builder: (context, selectedImageIndex, child) {
                                return Container(
                                  width: 80,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: selectedImageIndex == index
                                          ? Colors
                                              .blue // Border color when selected
                                          : Colors
                                              .transparent, // No border when not selected
                                      width: 2.0, // Border width
                                    ),
                                  ),
                                  transform: Matrix4.identity()
                                    ..scale(0.8), // Scale down the image
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Image.asset(imageUrls[index]),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // Submit button for saving medication
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) => const Color(0xffeb6081), // Button color
                      ),
                      minimumSize: MaterialStateProperty.resolveWith<Size>(
                        (states) => Size(
                          MediaQuery.of(context).size.width * 0.95,
                          50.0,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Create or update a Medicine object
                        Medicine medicine = Medicine(
                          id: widget.medicineToEdit
                              ?.id, // Use existing ID if in update mode
                          name: _medicationNameController.text,
                          dosage: _doseController.text,
                          image: selectedImageUrl,
                          days: _selectedDays,
                          reminderTime: _reminderTimes,
                          amount: _quantityController.text,
                        );

                        MedicationService medicationService =
                            MedicationService();

                        try {
                          if (widget.medicineToEdit == null) {
                            // Create mode: Save a new medicine
                            await medicationService.createMedicine(medicine);
                            if (kDebugMode) {
                              print('Medicine created successfully');
                            }
                          } else {
                            // Update mode: Update existing medicine
                            await medicationService.updateMedicine(medicine);
                            if (kDebugMode) {
                              print('Medicine updated successfully');
                            }
                          }
                          Navigator.pop(context); // Close the bottom sheet
                        } catch (e) {
                          if (kDebugMode) {
                            print('Error processing medicine: $e');
                          }
                        }
                      }
                    },
                    child: const Text(
                      'Klaar', // Button text
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Format the selected date for display
    String formattedDate =
        DateFormat('d MMMM').format(_selectedDate); // Use _selectedDate

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Display the DateSelector widget
            DateSelector(
              formattedDate: formattedDate,
              onDateSelected: _onDateSelected, // Set up the callback
            ),
            // Display the MedicationCard widget and pass the selected date
            MedicationCard(
                selectedDate:
                    _selectedDate), // Pass the selected date to MedicationCard
          ],
        ),
      ),
      bottomNavigationBar: Footer(
        onButtonPressed: _showFormBottomSheet, // Show the medication input form
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medication_reminder_app/widgets/add_reusable_time_field.dart';
import 'package:medication_reminder_app/widgets/medication_card.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../widgets/date_selector.dart';
import '../widgets/footer.dart';
import '../widgets/input_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  List<String> _selectedDays = [];

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

  String selectedImageUrl = '';

  void _showFormBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _buildMedicationFormSheet(context);
      },
    );
  }

  Widget _buildMedicationFormSheet(BuildContext context) {
    return SizedBox(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                    inputStyle(
                      prefixIcon: Icons.medication_rounded,
                      hintText: 'Paracetamol/Hoestdrank',
                    ),
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
                          inputStyle(
                            prefixIcon: Icons.medical_information,
                            hintText: '1 pil/tablet',
                          ),
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
                          inputStyle(
                            prefixIcon: Icons.my_library_add_rounded,
                            hintText: '500mg/ml',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MultiSelectBottomSheetField(
                      initialChildSize: 0.7,
                      maxChildSize: 0.95,
                      listType: MultiSelectListType.CHIP,
                      searchable: true,
                      buttonText: const Text('Welke dag(en)'),
                      title: const Text('Dagen'),
                      items: _allDays
                          .map((day) => MultiSelectItem(day, day))
                          .toList(),
                      onConfirm: (values) {
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
                const TimeInputWidget(),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Uiterlijk'),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // Update the selectedImageIndex immediately
                              selectedImageIndexNotifier.value = index;
                            },
                            child: ValueListenableBuilder<int>(
                              valueListenable: selectedImageIndexNotifier,
                              builder: (context, selectedImageIndex, child) {
                                return Container(
                                  width: 80,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
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
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) => const Color(0xffeb6081),
                      ),
                      minimumSize: MaterialStateProperty.resolveWith<Size>(
                        (states) => Size(
                          MediaQuery.of(context).size.width * 0.95,
                          50.0,
                        ),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Done',
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

  void addReminder() {
    // Implement your logic for adding a reminder
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('d MMMM').format(DateTime.now());

    return Scaffold(
      body: Column(
        children: [
          DateSelector(formattedDate: formattedDate),
          const MedicationCard()
        ],
      ),
      bottomNavigationBar: Footer(
        onButtonPressed: _showFormBottomSheet,
      ),
    );
  }
}

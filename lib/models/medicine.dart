import 'package:cloud_firestore/cloud_firestore.dart';

class Medicine {
  String? id; // id is nullable because Firestore will generate it
  String name;
  String dosage;
  String image;
  List<String> days;
  List<Timestamp> reminderTime;
  String amount;

  Medicine({
    this.id,
    required this.name,
    required this.dosage,
    required this.image,
    required this.days,
    required this.reminderTime,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'image': image,
      'days': days,
      'reminder_time':
          reminderTime.map((e) => e.toDate().toIso8601String()).toList(),
      'amount': amount,
    };
  }

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      name: json['name'],
      dosage: json['dosage'],
      image: json['image'],
      days: List<String>.from(json['days']),
      reminderTime: (json['reminder_time'] as List)
          .map((item) => Timestamp.fromDate(DateTime.parse(item)))
          .toList(),
      amount: json['amount'],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Medicine {
  late String id;
  late String name;
  late String dosage;
  late String image;
  late List<String> days;
  late List<Timestamp> reminderTime;
  late String amount;

  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.image,
    required this.days,
    required this.reminderTime,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'image': image,
      'days': days,
      'reminder_time': reminderTime.map((e) => e.toDate().toIso8601String()).toList(),
      'amount': amount,
    };
  }

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['name'],
      dosage: json['dosage'],
      image: json['image'],
      days: List<String>.from(json['days']),
      reminderTime: (json['reminder_time'] as List).map((item) => item as Timestamp).toList(),
      amount: json['amount'],
    );
  }
}

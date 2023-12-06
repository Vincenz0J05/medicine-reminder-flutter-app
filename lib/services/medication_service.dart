import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medicine.dart';

class MedicationService {
  final CollectionReference medicineCollection =
      FirebaseFirestore.instance.collection('medicine');

  Stream<QuerySnapshot> fetchMedicine() {
    return medicineCollection.snapshots();
  }

  Future<String> createMedicine(Medicine medicine) async {
    DocumentReference docRef = await medicineCollection.add(medicine.toJson());
    print(docRef.id);
    return docRef.id; // Return the generated ID of the new document
  }

  Future<void> deleteMedicine(String id) async {
    try {
      await medicineCollection.doc(id).delete();
      print('Medicine deleted succesfully');
    } catch (e) {
      print('Error deleting medicine: $e');
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addReminderDetails(
      Map<String, dynamic> ReminderInfoMap, String id) async {
    FirebaseFirestore.instance
        .collection("Reminder")
        .doc(id)
        .set(ReminderInfoMap);
  }

//to get the data from the firestore
  Future<Stream<QuerySnapshot>> getReminderDetails() async {
    return await FirebaseFirestore.instance.collection("Reminder").snapshots();
  }

  //to update
  Future updateReminderDetail(
      String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance
        .collection("Reminder")
        .doc(id)
        .update(updateInfo);
  }

  //to delete
  Future deleteReminderDetail(String id) async {
    return await FirebaseFirestore.instance
        .collection("Reminder")
        .doc(id)
        .delete();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_group_journal/types/Student.dart';

class FirebaseHelper {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static CollectionReference users = FirebaseFirestore.instance.collection('group mates');

  static Future<List<Student>> getAllStudents() async {
    var data = await users.get();
    return data.docs.map<Student>((doc) => new Student(
      doc.get("firstName"),
      doc.get("lastName"),
      doc.get("secondName"),
      (doc.get("images") as List)?.map((item) => item as String)?.toList(),
      doc.get("birthday").toDate(),
      doc.get("latitude"),
      doc.get("longitude"),
      doc.get("videoUrl"),
    )).toList();
  }

}
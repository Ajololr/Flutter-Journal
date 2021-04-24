import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_group_journal/types/Student.dart';

class FirebaseHelper {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static CollectionReference students =
      FirebaseFirestore.instance.collection('group mates');

  static Reference imagesRef = storage.ref().child('images');
  static Reference videosRef = storage.ref().child('videos');

  static Future<List<Student>> getAllStudents() async {
    var data = await students.get();
    return data.docs
        .map<Student>((doc) => new Student(
              doc.id,
              doc.get("firstName"),
              doc.get("lastName"),
              doc.get("secondName"),
              (doc.get("images") as List)
                  ?.map((item) => item as String)
                  ?.toList(),
              doc.get("birthday").toDate(),
              doc.get("latitude"),
              doc.get("longitude"),
              doc.get("videoUrl"),
            ))
        .toList();
  }

  static Future<void> addStudent(String firstName, String lastName,
      String secondName, List<String> images, DateTime birthday) async {
    try {
      return await students.add({
        'firstName': firstName,
        'lastName': lastName,
        'secondName': secondName,
        'images': images,
        'birthday': birthday,
        'latitude': "",
        'longitude': "",
        'videoUrl': "",
      });
    } catch (e) {
      throw e;
    }
  }

  static Future<void> updateStudent(Student student) async {
    try {
      return await students.doc(student.id).update({
        'firstName': student.firstName,
        'lastName': student.lastName,
        'secondName': student.secondName,
        'images': student.images,
        'birthday': student.birthday,
        'latitude': student.latitude,
        'longitude': student.longitude,
        'videoUrl': student.videoUrl,
      });
    } catch (e) {
      throw e;
    }
  }

  static Future<String> uploadImage(File file) async {
    try {
      Reference imageRef = imagesRef.child("${Uuid().v4()}.jpeg");
      await imageRef.putFile(file);
      return await imageRef.getDownloadURL();
    } catch (e) {
      throw e;
    }
  }

  static Future<String> uploadVideo(File file) async {
    try {
      Reference videoRef = videosRef.child("${Uuid().v4()}.mov");
      await videoRef.putFile(file);
      return await videoRef.getDownloadURL();
    } catch (e) {
      throw e;
    }
  }
}

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bookario_manager/models/club_details.dart';
import 'package:bookario_manager/models/coupon_model.dart';
import 'package:bookario_manager/models/event_model.dart';
import 'package:bookario_manager/models/promoter_model.dart';
import 'package:bookario_manager/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;

class FirebaseService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('managers');
  final CollectionReference _clubCollectionReference =
      FirebaseFirestore.instance.collection('clubs');
  final CollectionReference _eventsCollectionReference =
      FirebaseFirestore.instance.collection('events');
  final CollectionReference _promotersCollectionReference =
      FirebaseFirestore.instance.collection('promoters');
  final CollectionReference _locationsCollectionReference =
      FirebaseFirestore.instance.collection('locations');

  Future updateUser(
    UserModel user,
  ) async {
    try {
      await _usersCollectionReference.doc(user.id).set(
            user.toJson(),
          );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final userData = await _usersCollectionReference.doc(uid).get();
      return UserModel.fromJson(
        userData.data()! as Map<String, dynamic>,
        userData.id,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future createUser(UserModel user) async {
    try {
      await _usersCollectionReference.doc(user.id).set(
            user.toJson(),
          );
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<ClubDetails>?> getMyClubs(String uid) async {
    List<ClubDetails> _clubDetails = [];
    final response = await _clubCollectionReference
        .where("members", arrayContains: uid)
        .get();
    for (final doc in response.docs) {
      _clubDetails.add(
          ClubDetails.fromJson(doc.data()! as Map<String, dynamic>, doc.id));
    }
    return _clubDetails;
  }

  Future getMyEvents(String clubId) async {
    List<EventModel> events = [];
    final response = await _eventsCollectionReference
        .where("clubId", isEqualTo: clubId)
        .get();
    for (final doc in response.docs) {
      log(doc.data().toString());
      events.add(
          EventModel.fromJson(doc.data()! as Map<String, dynamic>, doc.id));
    }

    return events;
  }

  Future<List<PromoterModel>> getPromoters() async {
    List<PromoterModel> promoters = [];
    final response = await _promotersCollectionReference.get();
    for (final doc in response.docs) {
      promoters.add(PromoterModel.fromJson(doc.data() as Map<String, dynamic>));
    }
    return promoters;
  }

  Future<List<String>> getLocations() async {
    List<String> locations = [];
    final response = await _locationsCollectionReference.get();
    for (final doc in response.docs) {
      locations.add((doc.data() as Map<String, dynamic>)['location']);
    }
    return locations;
  }

  Future uploadImageToFirebase(File imageFile, String eventName) async {
    fs.Reference firebaseStorageRef =
        fs.FirebaseStorage.instance.ref().child('eventsThumbnails/$eventName');
    fs.UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    fs.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
        );
    return taskSnapshot.ref.getDownloadURL();
  }

  Future<void> createEvent(Map<String, dynamic> json) async {
    await _eventsCollectionReference.doc().set(json);
  }

  void addCoupon(
      {required String eventId, required Map<String, dynamic> coupon}) {
    _eventsCollectionReference
        .doc(eventId)
        .collection("coupons")
        .doc()
        .set(coupon);
  }

  Future<List<CouponModel>> getCouponsForEvent({String? eventId}) async {
    List<CouponModel> coupons = [];
    var response = await _eventsCollectionReference
        .doc(eventId)
        .collection("coupons")
        .get();
    for (final doc in response.docs) {
      coupons.add(CouponModel.fromJson(doc.data()));
    }
    return coupons;
  }
}

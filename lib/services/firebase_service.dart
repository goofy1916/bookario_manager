import 'dart:developer';
import 'dart:io';

import 'package:bookario_manager/models/club_details.dart';
import 'package:bookario_manager/models/coupon_model.dart';
import 'package:bookario_manager/models/event_model.dart';
import 'package:bookario_manager/models/event_pass_model.dart';
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
  final CollectionReference _passesCollectionReference =
      FirebaseFirestore.instance.collection('passes');

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
    final List<String> locations = [];
    final response = await _locationsCollectionReference.get();
    final list = response.docs.first.data()! as Map<String, dynamic>;
    for (final loc in list["location"]) {
      locations.add(loc.toString());
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

  Future<void> createEvent(
    Map<String, dynamic> json,
  ) async {
    await _eventsCollectionReference.doc().set(json);
  }

  Future<void> updateEvent(Map<String, dynamic> json, String eventId) async {
    await _eventsCollectionReference.doc(eventId).set(json);
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
      coupons.add(CouponModel.fromJson(doc.data(), doc.id));
    }
    return coupons;
  }

  Future removeCoupon(CouponModel coupon, String eventId) async {
    await _eventsCollectionReference
        .doc(eventId)
        .collection('coupons')
        .doc(coupon.id)
        .delete();
  }

  removePass(String passType, String type, String eventId) async {
    await _eventsCollectionReference.doc(eventId).get().then((value) async {
      List passList = (value.data()! as Map<String, dynamic>)[passType];
      var selectedPass;
      for (final pass in passList) {
        if (pass['type'] == type) {
          selectedPass = pass;
        }
      }
      passList.remove(selectedPass);
      await _eventsCollectionReference
          .doc(eventId)
          .set({passType: passList}, SetOptions(merge: true));
    });
  }

  addPassesToEvent(String eventId, Map<String, dynamic> passes) async {
    await _eventsCollectionReference.doc(eventId).get().then((value) async {
      await _eventsCollectionReference
          .doc(eventId)
          .set(passes, SetOptions(merge: true));
    });
  }

  Future<EventModel> getEvent(String eventId) async {
    EventModel event;
    final response = await _eventsCollectionReference.doc(eventId).get();
    event = EventModel.fromJson(
        (response.data()! as Map<String, dynamic>), response.id);

    return event;
  }

  Future<EventPass?> getPass(String passId) async {
    EventPass eventPass;
    try {
      final response = await _passesCollectionReference.doc(passId).get();
      log(response.data().toString());
      if (response.exists) {
        eventPass =
            EventPass.fromJson(response.data() as Map<String, dynamic>, passId);
        return eventPass;
      } else {
        return null;
      }
    } catch (e) {
      log("Get passes: $e");
      return null;
    }
  }

  Future<List<EventPass>> getPasses(String eventId) async {
    final List<EventPass> eventPasses = [];
    try {
      final response = await _passesCollectionReference
          .where("eventId", isEqualTo: eventId)
          .get();
      for (final data in response.docs) {
        final EventPass pass =
            EventPass.fromJson(data.data()! as Map<String, dynamic>, data.id);
        eventPasses.add(pass);
      }
      return eventPasses;
    } catch (e) {
      log("Get passes: $e");
      return [];
    }
  }

  approvePass(String passId) {
    _passesCollectionReference
        .doc(passId)
        .set({"checked": true}, SetOptions(merge: true));
  }

  updateCrowd(String eventId, int maleCount, int femaleCount) async {
    _eventsCollectionReference.doc(eventId).set(
        {"totalMale": maleCount, "totalFemale": femaleCount},
        SetOptions(merge: true));
  }
}

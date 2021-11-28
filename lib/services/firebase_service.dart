import 'dart:developer';

import 'package:bookario_manager/models/club_details.dart';
import 'package:bookario_manager/models/event_model.dart';
import 'package:bookario_manager/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('managers');
  final CollectionReference _clubCollectionReference =
      FirebaseFirestore.instance.collection('clubs');
  final CollectionReference _eventsCollectionReference =
      FirebaseFirestore.instance.collection('events');

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
}

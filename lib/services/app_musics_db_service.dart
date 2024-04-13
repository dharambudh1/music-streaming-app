import "dart:developer";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:get/get.dart";

class AppMusicsDBService extends GetxService {
  factory AppMusicsDBService() {
    return _singleton;
  }

  AppMusicsDBService._internal();
  static final AppMusicsDBService _singleton = AppMusicsDBService._internal();

  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  final CollectionReference<dynamic> collectionReference =
      FirebaseFirestore.instance.collection("musics");

  void init() {
    log("AppMusicsDBService:: init():: DB:: ${firestoreInstance.databaseURL}");
    return;
  }

  Stream<QuerySnapshot<dynamic>> readMusics({
    required Function(String message) successCallback,
    required Function(String message) failureCallback,
  }) {
    Stream<QuerySnapshot<dynamic>> stream =
        const Stream<QuerySnapshot<dynamic>>.empty();
    try {
      stream = collectionReference.snapshots();
      successCallback("Records fetched successfully.");
    } on Exception catch (error) {
      log("readMusics():: Exception caught:: $error");
      failureCallback("Records not fetched. $error");
    } finally {}
    return stream;
  }

  Query<dynamic> readMusicBySearch({
    required String searchQuery,
    required Function(String message) successCallback,
    required Function(String message) failureCallback,
  }) {
    Query<dynamic> query = collectionReference;
    try {
      query = collectionReference.where(
        "name",
        isGreaterThanOrEqualTo: searchQuery,
        isLessThan: "$searchQuery\uf8ff",
      );
      successCallback("Records fetched successfully.");
    } on Exception catch (error) {
      log("readUsers():: Exception caught:: $error");
      failureCallback("Records not fetched.");
    } finally {}
    return query;
  }

  Future<void> addMusic({
    required Map<String, dynamic> data,
    required Function(String message) successCallback,
    required Function(String message) failureCallback,
  }) async {
    try {
      final DocumentReference<dynamic> result = await collectionReference.add(
        data,
      );
      log("addMusic():: result.id:: ${result.id}");
      successCallback("Music added successfully.");
    } on Exception catch (error) {
      log("addMusic():: Exception caught:: $error");
      failureCallback("Music not added.");
    } finally {}
    return Future<void>.value();
  }

  Future<void> updateMusic({
    required String id,
    required Map<String, dynamic> data,
    required Function(String message) successCallback,
    required Function(String message) failureCallback,
  }) async {
    try {
      final DocumentReference<dynamic> result = collectionReference.doc(id);
      await result.update(data);
      successCallback("Music updated successfully.");
    } on Exception catch (error) {
      log("updateMusic():: Exception caught:: $error");
      failureCallback("Music not updated.");
    } finally {}
    return Future<void>.value();
  }

  Future<void> deleteMusic({
    required String id,
    required Function(String message) successCallback,
    required Function(String message) failureCallback,
  }) async {
    try {
      final DocumentReference<dynamic> result = collectionReference.doc(id);
      await result.delete();
      successCallback("Music deleted successfully.");
    } on Exception catch (error) {
      log("deleteMusic():: Exception caught:: $error");
      failureCallback("Music not deleted.");
    } finally {}
    return Future<void>.value();
  }
}

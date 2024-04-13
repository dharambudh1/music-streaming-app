import "dart:developer";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:get/get.dart";
import "package:music_streaming_app/functions/app_functions.dart";

class AppUsersDBService extends GetxService {
  factory AppUsersDBService() {
    return _singleton;
  }

  AppUsersDBService._internal();
  static final AppUsersDBService _singleton = AppUsersDBService._internal();

  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  final CollectionReference<dynamic> collectionReference =
      FirebaseFirestore.instance.collection("users");

  void init() {
    log("AppUsersDBService:: init():: DB:: ${firestoreInstance.databaseURL}");
    return;
  }

  Stream<QuerySnapshot<dynamic>> readUsers({
    required Function(String message) successCallback,
    required Function(String message) failureCallback,
  }) {
    Stream<QuerySnapshot<dynamic>> stream =
        const Stream<QuerySnapshot<dynamic>>.empty();
    try {
      stream = collectionReference.snapshots();
      successCallback("Records fetched successfully.");
    } on Exception catch (error) {
      log("readUsers():: Exception caught:: $error");
      failureCallback("Records not fetched.");
    } finally {}
    return stream;
  }

  Stream<QuerySnapshot<dynamic>> readUserByUserId({
    required String id,
    required Function(String message) successCallback,
    required Function(String message) failureCallback,
  }) {
    Stream<QuerySnapshot<dynamic>> stream =
        const Stream<QuerySnapshot<dynamic>>.empty();
    try {
      stream = collectionReference.where(id).snapshots();
      successCallback("Records fetched successfully.");
    } on Exception catch (error) {
      log("readUsers():: Exception caught:: $error");
      failureCallback("Records not fetched.");
    } finally {}
    return stream;
  }

  Future<void> addUser({
    required Map<String, dynamic> data,
    required Function(String message) successCallback,
    required Function(String message) failureCallback,
  }) async {
    try {
      final DocumentReference<dynamic> result = await collectionReference.add(
        data,
      );
      log("addUser():: result.id:: ${result.id}");
      successCallback("User added successfully.");
    } on Exception catch (error) {
      log("addUser():: Exception caught:: $error");
      failureCallback("User not added.");
    } finally {}
    return Future<void>.value();
  }

  Future<void> updateUser({
    required String id,
    required Map<String, dynamic> data,
    required Function(String message) successCallback,
    required Function(String message) failureCallback,
  }) async {
    try {
      final DocumentReference<dynamic> result = collectionReference.doc(id);
      await result.update(data);
      successCallback("User updated successfully.");
    } on Exception catch (error) {
      log("updateUser():: Exception caught:: $error");
      failureCallback("User not updated.");
    } finally {}
    return Future<void>.value();
  }

  Future<void> deleteUser({
    required String id,
    required Function(String message) successCallback,
    required Function(String message) failureCallback,
  }) async {
    try {
      final DocumentReference<dynamic> result = collectionReference.doc(id);
      await result.delete();
      successCallback("User deleted successfully.");
    } on Exception catch (error) {
      log("deleteUser():: Exception caught:: $error");
      failureCallback("User not deleted.");
    } finally {}
    return Future<void>.value();
  }

  Future<QueryDocumentSnapshot<dynamic>?> getUserByEmailAndPass({
    required String emailAddress,
    required String password,
  }) async {
    QueryDocumentSnapshot<dynamic>? data;
    try {
      final QuerySnapshot<dynamic> result = await collectionReference
          .where("email_address", isEqualTo: emailAddress)
          .where("password", isEqualTo: encodeString(decodedString: password))
          .get();
      if (result.docs.isNotEmpty) {
        data = result.docs.first;
      } else {
        log("getUserByEmailAndPass():: User not found:: $data");
      }
    } on Exception catch (error) {
      log("getUserByEmailAndPasss():: Exception caught:: $error");
    } finally {}
    return Future<QueryDocumentSnapshot<dynamic>?>.value(data);
  }

  Future<(bool, Map<String, dynamic>)> login({
    required String emailAddress,
    required String password,
  }) async {
    bool isAvailable = false;
    Map<String, dynamic> userInfo = <String, dynamic>{};
    try {
      final QueryDocumentSnapshot<dynamic>? data = await getUserByEmailAndPass(
        emailAddress: emailAddress.trim().toLowerCase(),
        password: password.trim(),
      );
      isAvailable = data != null && data.data() != null;
      if (isAvailable) {
        final String id = getId(docsData: data);
        final Map<String, dynamic> map = Map<String, dynamic>.from(data.data());
        userInfo = <String, dynamic>{
          "user_id": id,
          ...map,
        };
      } else {}
    } on Exception catch (error) {
      log("canLogin():: Exception caught:: $error");
    } finally {}
    return Future<(bool, Map<String, dynamic>)>.value((isAvailable, userInfo));
  }
}

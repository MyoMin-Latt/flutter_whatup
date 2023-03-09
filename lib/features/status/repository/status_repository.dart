// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/common/repository/common_firebase_storage_repository.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/models/status_model.dart';
import 'package:whatsapp_ui/models/user_model.dart';

final statusReporitoryProvider = Provider(
  (ref) => StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  StatusRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imageurl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            '/status/$statusId$uid',
            statusImage,
          );

      // print('StatusRepository : imageurl : $imageurl');

      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts();
        // print('StatusRepository : contacts : $contacts');
        // log('StatusRepository : contacts : $contacts');
      }
      // print('StatusRepository : contacts length : ${contacts.length}');
      // print('StatusRepository : contacts phone : ${contacts[0].phones}');
      // print('StatusRepository : contacts phone no : ${contacts[0].phones[0]}');

      List<String> uidWhoCanSee = [];
      for (var i = 0; i < contacts.length; i++) {
        var userDataFirebase = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .get();
        // print('StatusRepository : userDataFirebase : $userDataFirebase');
        // print('StatusRepository : userDataFirebase : ${userDataFirebase.docs}');
        if (userDataFirebase.docs.isNotEmpty) {
          var userData = UserModel.fromMap(userDataFirebase.docs[0].data());
          uidWhoCanSee.add(userData.uid);
        }
      }

      // print('StatusRepository : uidWhoCanSee : $uidWhoCanSee');
      List<String> statusImageUrls = [];
      var statusesSnapshot = await firestore
          .collection('status')
          .where(
            'uid',
            isEqualTo: auth.currentUser!.uid,
          )
          .get();

      // print('StatusRepository : statusesSnapshot : $statusesSnapshot');
      if (statusesSnapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(statusesSnapshot.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageurl);

        await firestore
            .collection('status')
            .doc(statusesSnapshot.docs[0].id)
            .update({
          'photoUrl': statusImageUrls,
        });
        return;
      } else {
        // print('StatusRepository : else state : if else');
        statusImageUrls = [imageurl];
      }
      Status status = Status(
        uid: uid,
        username: username,
        phoneNumber: phoneNumber,
        photoUrl: statusImageUrls,
        createdAt: DateTime.now(),
        profilePic: profilePic,
        statusId: statusId,
        whoCanSee: uidWhoCanSee,
      );

      // print('StatusRepository : status : $status');

      await firestore.collection('status').doc(statusId).set(status.toMap());
    } catch (e) {
      // print('StatusRepository : error : ${e.toString()}');
      showSnackBar(context: context, content: e.toString());
    }
  }
}

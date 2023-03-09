import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/common/repository/common_firebase_storage_repository.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';

import '../../../models/group.dart';

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  );
});

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  GroupRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void createGroup(
    BuildContext context, {
    required String name,
    required File profilePic,
    required List<Contact> selectedContacts,
  }) async {
    try {
      List<String> uids = [];
      for (var i = 0; i < selectedContacts.length; i++) {
        log('SelectedContact: ${selectedContacts[i].phones}');
        if (selectedContacts[i].phones.isNotEmpty) {
          var userCollection = await firestore
              .collection('users')
              .where(
                'phoneNumber',
                isEqualTo:
                    selectedContacts[i].phones.first.number.replaceAll(' ', ''),
              )
              .get();
          log('UserCollection: $userCollection');

          if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
            log('UserID: ${userCollection.docs[0].data()['uid']}');
            uids.add(userCollection.docs[0].data()['uid']);
          }
        }
      }

      var groupId = const Uuid().v1();

      String groupPicUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase('/groups/$groupId', profilePic);

      log('memberUids: ${[auth.currentUser!.uid, ...uids]}');
      GroupModel group = GroupModel(
        senderId: auth.currentUser!.uid,
        name: name,
        groupId: groupId,
        lastMessage: '',
        groupPic: groupPicUrl,
        memberUids: [auth.currentUser!.uid, ...uids],
        timeSent: DateTime.now(),
      );

      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}

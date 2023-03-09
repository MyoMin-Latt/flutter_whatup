import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/group_repository.dart';

final groupControllerProvider = Provider<GroupController>((ref) {
  return GroupController(
    groupRepository: ref.watch(groupRepositoryProvider),
    ref: ref,
  );
});

class GroupController {
  final GroupRepository groupRepository;
  final ProviderRef ref;

  GroupController({
    required this.groupRepository,
    required this.ref,
  });

  void createGroup(
    BuildContext context, {
    required String name,
    required File groupPic,
    required List<Contact> selectedContacts,
  }) {
    groupRepository.createGroup(
      context,
      name: name,
      profilePic: groupPic,
      selectedContacts: selectedContacts,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/error.dart';
import '../../../common/widgets/loader.dart';
import '../../select_contacts/controller/select_contact_controller.dart';

final selectedGroupContactsProvider = StateProvider<List<Contact>>((ref) {
  return [];
});

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContactIndices = [];

  void selectContact(int index, Contact contact) {
    if (selectedContactIndices.contains(index)) {
      selectedContactIndices.removeAt(index);
    } else {
      selectedContactIndices.add(index);
    }

    setState(() {});

    ref
        .read(selectedGroupContactsProvider.notifier)
        .update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
          data: (contactList) => Expanded(
            child: ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList.elementAt(index);
                return InkWell(
                  onTap: () => selectContact(index, contact),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      leading: selectedContactIndices.contains(index)
                          ? IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.done),
                            )
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          error: (err, trace) => Expanded(
            child: ErrorScreen(error: err.toString()),
          ),
          loading: () => const Expanded(child: Loader()),
        );
  }
}

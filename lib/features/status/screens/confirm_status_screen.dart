// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/features/status/controller/status_controller.dart';

class ConfirmStatusScreen extends ConsumerWidget {
  static const String routeName = '/comfirm-status-screen';
  const ConfirmStatusScreen({
    super.key,
    required this.file,
  });

  final File file;

  void addStatus(
    WidgetRef ref,
    BuildContext context,
  ) {
    ref.read(statusControllerProvider).addStatus(file, context);
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.file(file),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
        onPressed: () {},
        // onPressed: () => addStatus(ref, context),
      ),
    );
  }
}

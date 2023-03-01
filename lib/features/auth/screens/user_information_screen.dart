import 'package:flutter/material.dart';

class UserInformationScreen extends StatelessWidget {
  static const String routeName = '/user-information';
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://pixabay.com/vectors/blank-profile-picture-mystery-man-973460'),
                  radius: 30,
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}

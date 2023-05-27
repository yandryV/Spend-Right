import 'package:flutter/material.dart';

import '../../helpers/preferences.dart';
import '../../models/user_model.dart';
import '../../widgets/bottom_navigation_bar.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

UserModel? user;
final preferences = Preferences();

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    user = UserModel.toDecodeJson(preferences.user);
    final Size size = MediaQuery.of(context).size;

    if (user != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: size.width,
                    height: size.height / 5,
                    child: Container(
                      color: Theme.of(context).colorScheme.secondary,
                      child: Container(
                        margin: EdgeInsets.only(top: size.width * 0.02),
                        width: size.width * 0.4,
                        height: size.width * 0.4,
                        // TODO: Show photo
                        // child: CircleAvatar(
                        //   backgroundColor: Colors.white,
                        //   child: Container(
                        //     width: size.width * 0.35,
                        //     height: size.width * 0.35,
                        //     decoration: BoxDecoration(
                        //       image: DecorationImage(
                        //         image: ResizeImage(
                        //             NetworkImage(user!.photoUrl),
                        //             width: (size.width * 0.45).toInt(),
                        //             allowUpscaling: true),
                        //       ),
                        //       shape: BoxShape.circle,
                        //     ),
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Wrap(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Icon(Icons.account_circle),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 30),
                          child: Text(user!.name),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _logOut(context),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavigationBarWidget(),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              _logOut(context),
            ],
          ),
        ],
      );
    }
  }

  Widget _logOut(BuildContext context) {
    return TextButton(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.grey),
        child: const Text(
          'Cerrar Sesión',
          style: TextStyle(color: Colors.white),
        ),
      ),
      onPressed: () {
        preferences.user = '';
        Navigator.pushReplacementNamed(context, '/login');
      },
    );
  }
}

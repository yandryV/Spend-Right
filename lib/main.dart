import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spend_right/blocs/auth/auth_bloc.dart';
import 'package:spend_right/blocs/navigation/navigation_bloc.dart';
import 'package:spend_right/firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final preferences = Preferences();
  // await preferences.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int sd = 1;
    String principalPage;
    if (sd == 1) {
      principalPage = '/login';
    } else{
      principalPage = '/home';
    }

    // final preferences = Preferences();
    // String principalPage;
    // if (preferences.user == "") {
    //   principalPage = '/login';
    // } else {
    //   final user = UserModel.fromJson(json.decode(preferences.user));
    //   if (user.profileCompleted()) {
    //     principalPage = '/welcome';
    //   } else {
    //     principalPage = '/user-register';
    //   }
    // }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NavigationBloc(),
        ),
        // BlocProvider(
        //   create: (context) => AuthBloc(),
        // ),
      ],
      child: Container(),
    );
  }
}

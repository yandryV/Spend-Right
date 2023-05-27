import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_right/src/helpers/preferences.dart';
import 'package:spend_right/src/helpers/responsive.dart';
import 'package:spend_right/src/models/user_model.dart';

import '../blocs/navigation/navigation_bloc.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with WidgetsBindingObserver {
  final preferences = Preferences();
  UserModel user = UserModel().init();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = UserModel.toDecodeJson(preferences.user);
    final size = MediaQuery.of(context).size;
    final Responsive responsive = Responsive.of(context);

    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        // margin: EdgeInsets.only(top: size.height * 0.2),
                        height: size.height * 0.2,
                        width: size.width,
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Spend-Right",
                              style: TextStyle(
                                color: const Color(0xff2d2e81),
                                fontSize: responsive.isMobile! ? 15 : 22,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 100, bottom: 20),
                        child: Text(
                            "Bienvenido ${user.name.contains(' ') ? user.name.substring(0, 1).toUpperCase() + user.name.substring(1, user.name.indexOf(' ')).toLowerCase() : user.name.substring(0, 1).toUpperCase() + user.name.substring(1).toLowerCase()}",
                            style: const TextStyle(
                              color: Color(0xff2d2e81),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Text(
                                'Ahora podrás tener el mejor manejo para tus finanzas',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 15,
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            _continuar(context, size),
                            // _continuar(context, size),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _continuar(BuildContext context, Size size) {
    final Responsive responsive = Responsive.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: MaterialButton(
        color: Theme.of(context).colorScheme.secondary,
        shape: const StadiumBorder(),
        child: SizedBox(
          width: responsive.isMobile! ? 310 : 360,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.forward,
                color: Colors.white,
              ),
              Padding(padding: EdgeInsets.all(5)),
              Text(
                'Continuar',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        onPressed: () {
          context
              .read<NavigationBloc>()
              .add(NavigateToPage("/transaction-home", "pushReplacementNamed"));
        },
      ),
    );
  }
}

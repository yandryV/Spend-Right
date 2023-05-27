
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_right/src/blocs/auth/auth_bloc.dart';
import 'package:spend_right/src/helpers/navigation_fade_in.dart';
import 'package:spend_right/src/helpers/preferences.dart';
import 'package:spend_right/src/helpers/responsive.dart';
import 'package:spend_right/src/pages/auth/reset_pass.dart';
import 'package:spend_right/src/pages/auth/signin.dart';
import 'package:spend_right/src/services/firebase_auth.dart';
import 'package:spend_right/src/services/firebase_database.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  LogInPageState createState() => LogInPageState();
}

class LogInPageState extends State<LogInPage> {
  final firebaseServicesAuth = FirebaseServicesAuth();
  final firebaseServicesDatabase = FirebaseServicesDatabase();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final preferences = Preferences();
  bool _obscureText = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            _backgroundWidget(size),
            _loginFormWidget(size, context),
          ],
        ));
  }

  Widget _loginFormWidget(Size size, BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return SingleChildScrollView(
      child: SizedBox(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: responsive.isMobile! ? 380 : 400,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 100.0),
                child: Column(
                  children: <Widget>[
                    _logoWidget(),
                    _emailWidget(),
                    _passwordWidget(),
                    _emailButtonWidget(),
                    _resetPasswordWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    _separation(),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _googleButtonWidget(),
                        const SizedBox(
                          width: 55,
                        ),
                        _registerButtonWidget(context),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _separation() {
    return const Text('No tienes una cuenta? Regístrate:');
  }

  Widget _registerButtonWidget(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) => MaterialButton(
            onPressed: (!(context.read<AuthBloc>().state.isLoading))
                ? () {
                    Navigator.push(
                        context, navigationFadeIn(context, const SigInPage()));
                  }
                : null,
            disabledColor: Colors.grey,
            color: context.read<AuthBloc>().state.isLoading
                ? Colors.grey
                : const Color.fromRGBO(240, 184, 43, 1),
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Image(
                image: AssetImage('assets/icons/correo.png'),
                height: 20.0,
              ),
            )));
  }

  Widget _googleButtonWidget() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) => MaterialButton(
        onPressed: (!(context.read<AuthBloc>().state.isLoading))
            ? () {
                context.read<AuthBloc>().add(OnLoginRequestWithEmail());
              }
            : null,
        disabledColor: Colors.grey,
        color: context.read<AuthBloc>().state.isLoading
            ? Colors.grey
            : const Color.fromARGB(255, 226, 226, 226),
        child: const Padding(
          padding: EdgeInsets.all(15.0),
          child: Image(
            image: AssetImage('assets/icons/google.png'),
            height: 20.0,
          ),
        ),
      ),
    );
  }

  Widget _emailButtonWidget() {
    final Responsive responsive = Responsive.of(context);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return MaterialButton(
            color: (context.read<AuthBloc>().state.password.length > 1 &&
                    context.read<AuthBloc>().state.loginButtonState &&
                    !(context.read<AuthBloc>().state.isLoading))
                ? Theme.of(context).primaryColor
                : Colors.grey,
            disabledColor: Colors.grey,
            elevation: 0.0,
            onPressed: (context.read<AuthBloc>().state.password.length > 1 &&
                    context.read<AuthBloc>().state.loginButtonState &&
                    !(context.read<AuthBloc>().state.isLoading))
                ? () {
                    context.read<AuthBloc>().add(OnLoginRequestWithEmail());
                  }
                : null,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: responsive.isMobile! ? 280 : 300,
              ),
              child: Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15.0),
                child: const Text(
                  'Ingresar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ));
      },
    );
  }

  Widget _resetPasswordWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextButton(
          onPressed: () {
            Navigator.push(
                context, navigationFadeIn(context, const ResetPasswordPage()));
          },
          child: const Text(
            '¿Olvido la contraseña?',
            style: TextStyle(color: Colors.black54),
          )),
    );
  }

  Widget _logoWidget() {
    return const Image(
      image: AssetImage('assets/brand/logo.png'),
      height: 150.0,
    );
  }

Widget _emailWidget() {
  return BlocBuilder<AuthBloc, AuthState>(
    builder: (context, state) {
      return Container(
        padding: const EdgeInsets.only(top: 30, right: 40, left: 40),
        child: TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Icon(Icons.alternate_email),
            ),
            labelText: 'Email',
            hintText: 'email@mail.com',
            errorText: (context.read<AuthBloc>().state.emailState)
                ? null
                : 'Correo electrónico inválido',
            filled: true,
            fillColor: const Color.fromARGB(106, 218, 218, 218),
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 2,
              ),
            ),
          ),
          onChanged: (value) {
            context.read<AuthBloc>().add(OnEmailChange(value));
          },
        ),
      );
    },
  );
}


  Widget _passwordWidget() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Container(
          padding:
              const EdgeInsets.only(top: 30, right: 40, left: 40, bottom: 25),
          child: TextField(
            controller: passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 20, right: 10),
                child: Icon(Icons.lock_outline),
              ),
              labelText: 'Contraseña',
              filled: true,
              fillColor: const Color.fromARGB(106, 218, 218, 218),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 2,
              ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility),
              ),
              errorText: (context.read<AuthBloc>().state.passwordState)
                  ? null
                  : 'Más de 6 caracteres por favor',
            ),
            onChanged: (value) {
              context.read<AuthBloc>().add(OnPasswordChange(value));
            },
          ),
        );
      },
    );
  }

  Widget _backgroundWidget(Size size) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icons/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      height: size.height,
      width: size.width,
    );
  }

}

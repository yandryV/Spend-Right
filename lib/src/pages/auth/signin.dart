import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spend_right/src/blocs/auth/auth_bloc.dart';
import 'package:spend_right/src/helpers/preferences.dart';
import 'package:spend_right/src/helpers/responsive.dart';
import 'package:spend_right/src/pages/auth/login.dart';
import 'package:spend_right/src/services/firebase_auth.dart';
import 'package:spend_right/src/services/firebase_database.dart';

import '../../helpers/navigation_fade_in.dart';

class SigInPage extends StatefulWidget {
  const SigInPage({Key? key}) : super(key: key);

  @override
  SigInPageState createState() => SigInPageState();
}

class SigInPageState extends State<SigInPage> {
  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final firebaseServicesAuth = FirebaseServicesAuth();
  final firebaseServicesDatabase = FirebaseServicesDatabase();
  final preferences = Preferences();
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _backgroundWidget(size),
        _formWidget(context),
      ],
    ));
  }

  Widget _formWidget(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return SingleChildScrollView(
      child: SafeArea(
          child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: responsive.isMobile! ? 380 : 400,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: <Widget>[
                _textWidget(),
                _logoWidget(),
                _emailWidget(),
                _passwordWidget(),
                _passwordConfirmWidget(),
                const SizedBox(
                  height: 20.0,
                ),
                _buttonWidget(context),
                const SizedBox(height: 5),
                toLoginButton()
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget _buttonWidget(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        bool activator = false;
        if (context.read<AuthBloc>().state.confirmPasswordState &&
            context.read<AuthBloc>().state.emailState &&
            context.read<AuthBloc>().state.passwordState &&
            context.read<AuthBloc>().state.confirmPassword.length > 1) {
          activator = true;
        }
        return MaterialButton(
            color: (activator) ? Theme.of(context).primaryColor : Colors.grey,
            elevation: 0.0,
            onPressed: () {
              if (activator) {
                context.read<AuthBloc>().add(OnSignInRequestWithEmail());
              }
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: responsive.isMobile! ? 280 : 300,
              ),
              child: Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15.0),
                child: const Text(
                  'Registrar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ));
      },
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
              hintText: 'ejemplo@correo.com',
              labelText: 'Correos electrónico',
              errorText: (context.read<AuthBloc>().state.emailState)
                  ? null
                  : 'Correo electrónico invalido',
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
              const EdgeInsets.only(top: 10, right: 40, left: 40, bottom: 15),
          child: TextField(
              controller: passwordController,
              obscureText: _obscureTextPassword,
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
                  errorText: (context.read<AuthBloc>().state.passwordState)
                      ? (context.read<AuthBloc>().state.confirmPasswordState
                          ? null
                          : 'Las contraseñas no coinciden')
                      : 'Más de 6 caracteres por favor',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureTextPassword = !_obscureTextPassword;
                      });
                    },
                    icon: Icon(_obscureTextPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                  )),
              onChanged: (value) {
                context.read<AuthBloc>().add(OnPasswordChange(value));
              }),
        );
      },
    );
  }

  Widget _passwordConfirmWidget() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.only(right: 40, left: 40, bottom: 15),
          child: TextField(
              obscureText: _obscureTextConfirmPassword,
              decoration: InputDecoration(
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 20, right: 10),
                    child: Icon(Icons.lock_outline),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(106, 218, 218, 218),
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    ),
                  ),
                  labelText: 'Confirmar contraseña',
                  errorText:
                      (context.read<AuthBloc>().state.confirmPasswordState
                          ? null
                          : 'Las contraseñas no coinciden'),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureTextConfirmPassword =
                            !_obscureTextConfirmPassword;
                      });
                    },
                    icon: Icon(_obscureTextConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                  )),
              onChanged: (value) {
                context.read<AuthBloc>().add(OnConfirmPasswordChange(value));
              }),
        );
      },
    );
  }

  Widget toLoginButton() {
    //TODO: cambiar ui del botón
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          navigationFadeIn(context, const LogInPage()),
        );
      },
      child: const Text("¿Ya tienes una cuenta? Ingresa",
          style: TextStyle(color: Colors.white)),
    );
  }

  Widget _separation() {
    return Row(
      children: [
        const Text("No tienes una cuenta?"),
        MaterialButton(
            onPressed: () {
              Navigator.push(
                  context, navigationFadeIn(context, const LogInPage()));
            },
            child: const Text('Regístrate:')),
      ],
    );
  }

  Widget _textWidget() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Text(
        "Ya casi formas parte de Nino",
        style: GoogleFonts.inter(fontSize: 24),
      ),
    );
  }

  Widget _logoWidget() {
    return const Image(
      image: AssetImage('assets/brand/logo.png'),
      height: 150.0,
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

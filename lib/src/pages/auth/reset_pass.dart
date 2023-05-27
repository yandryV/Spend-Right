import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_right/src/blocs/auth/auth_bloc.dart';
import 'package:spend_right/src/helpers/responsive.dart';
import 'package:spend_right/src/helpers/utils.dart';
import 'package:spend_right/src/services/firebase_auth.dart';
import 'package:spend_right/src/widgets/custom_appbar_widget.dart';

final firebaseServices = FirebaseServicesAuth();

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBarWidget(),
        body: Stack(
          children: [
            _formResetPassword(context),
          ],
        ));
  }

  Widget _formResetPassword(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: responsive.isMobile! ? 380 : 400,
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 30, right: 40, left: 40),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  _createLogo(),
                  const SizedBox(
                    height: 20,
                  ),
                  _createEmail(),
                  const SizedBox(
                    height: 20,
                  ),
                  _createButton(),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createButton() {
    final Responsive responsive = Responsive.of(context);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        bool activador = false;
        if (context.read<AuthBloc>().state.email.length > 1 &&
            context.read<AuthBloc>().state.emailState) {
          activador = true;
        }
        return MaterialButton(
            color: (activador) ? Theme.of(context).primaryColor : Colors.grey,
            shape: const StadiumBorder(),
            elevation: 0.0,
            onPressed: (activador) ? _resetPassword : () {},
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: responsive.isMobile! ? 270 : 300,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: const Center(
                  child: Text(
                    'Recuperar Contraseña',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ));
      },
    );
  }

  _resetPassword() async {
    showLoading(context);
    await firebaseServices.resetPassword(
        context, context.read<AuthBloc>().state.email);
  }

  Widget _createLogo() {
    return const Image(
      image: AssetImage('assets/marca/logo.png'),
      height: 150.0,
    );
  }

  Widget _createEmail() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.only(top: 30, right: 40, left: 40),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: const Icon(
                  Icons.alternate_email,
                ),
                hintText: 'ejemplo@correo.com',
                labelText: 'Correos electrónico',
                errorText: (context.read<AuthBloc>().state.emailState)
                    ? null
                    : 'Correo electrónico invalido'),
            onChanged: (value) {
              context.read<AuthBloc>().add(OnEmailChange(value));
            },
          ),
        );
      },
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_right/src/blocs/auth/auth_bloc.dart';
import 'package:spend_right/src/helpers/preferences.dart';
import 'package:spend_right/src/helpers/utils.dart';
import 'package:spend_right/src/models/user_model.dart';
import 'package:spend_right/src/services/firebase_database.dart';
import 'package:spend_right/src/services/firebase_storage.dart';

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({Key? key}) : super(key: key);

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  final preferences = Preferences();
  final firebaseServicesStorage = FirebaseServicesStorage();
  final firebaseServicesDatabase = FirebaseServicesDatabase();
  final formKey = GlobalKey<FormState>();
// Controllers
  final nameController =
      TextEditingController();
  final identificationController =
      TextEditingController();
  final phoneController = TextEditingController();

  List flagTerms = [kDebugMode ? true : false, Colors.grey];
  UserModel user = UserModel().init();
  List flagPhoto = [false, Colors.grey, ''];
  bool flagInit = false;
  bool flagValidate = false;
  File? photo;

  @override
  Widget build(BuildContext context) {
    if (!flagInit) {
      if (preferences.user != "") {
        user = UserModel.fromJson(json.decode(preferences.user));
        if (user.name != "") {
          nameController.text = user.name;
        }
      }
      flagTerms[1] = Theme.of(context).primaryColor;
      flagPhoto[1] = Theme.of(context).primaryColor;
      flagInit = true;
    }
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _photoWidget(size),
                  _nameInputWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  _buttonSubmitWidget(context),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buttonSubmitWidget(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) => MaterialButton(
          shape: const StadiumBorder(),
          color: context.read<AuthBloc>().state.isLoading
              ? Colors.grey
              : Theme.of(context).primaryColor,
          onPressed: context.read<AuthBloc>().state.isLoading
              ? null
              : () {
                  _submit(context);
                },
          disabledColor: Colors.grey,
          child: Container(
            width: MediaQuery.of(context).size.width - 120,
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: const Center(
              child: Text(
                'Crear Perfil',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )),
    );
  }

  void _submit(BuildContext context) async {
    if (flagTerms[0] == true) {
      flagTerms[1] = Colors.green;
    } else {
      flagTerms[1] = Colors.red;
    }
    if (flagPhoto[0] == true) {
      flagPhoto[1] = Colors.green;
      flagPhoto[2] = '';
    } else {
      flagPhoto[1] = Colors.red;
      flagPhoto[2] = 'Se requiere foto del usuario';
    }
    if (formKey.currentState!.validate() && flagTerms[0] == true
        // && flagPhoto[0] == true
        // TODO: Validate photo

        ) {
      formKey.currentState!.save();
      context.read<AuthBloc>().add(OnUpdateUserInformation(user, photo));
      // TODO: Updload photo
      // if (user.photoUrl == "") {
      //   user.photoUrl =
      // await firebaseServicesStorage.uploadPhoto(photo, user.uid);
      // }

      // if (await firebaseServicesDatabase.postUserData(user)) {
      //   if (!mounted) return;
      //   preferences.user = user.toEncodeJson();
      //   Navigator.pushReplacementNamed(context, 'welcome');
      // }
    }
    setState(() {});
  }

  // Widget _termsButtonWidget(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       Checkbox(
  //         checkColor: Colors.white,
  //         value: flagTerms[0],
  //         activeColor: Colors.cyan[600],
  //         onChanged: (bool? value) {
  //           setState(() {
  //             flagTerms[0] = value;
  //           });
  //         },
  //       ),
  //       TextButton(
  //           child: Text(
  //             'Aceptar términos y condiciones',
  //             style: TextStyle(color: flagTerms[1]),
  //           ),
  //           onPressed: () {
  //             Navigator.push(context,
  //                 navigationFadeIn(context, const TermsAndConditionPage()));
  //           }),
  //     ],
  //   );
  // }

  Widget _nameInputWidget() {
    return Container(
      padding: const EdgeInsets.only(top: 30, right: 40, left: 40),
      child: TextFormField(
        controller: nameController,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(labelText: 'Nombre'),
        validator: (value) {
          if (value!.length < 4) {
            return 'Ingrese el nombre completo';
          } else {
            return null;
          }
        },
        onSaved: (newValue) {
          user.name = newValue!;
          nameController.text = newValue;
        },
      ),
    );
  }

  Widget _photoWidget(Size size) {
    if (user.photoUrl != "") {
      flagPhoto[0] = true;
      return Stack(
        children: [
          SizedBox(
            width: size.width,
            child: FadeInImage(
              image: NetworkImage(user.photoUrl),
              placeholder: const AssetImage('assets/brand/logo.png'),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          _photoSelectWidget(),
        ],
      );
    } else {
      if (photo == null) {
        return Stack(
          children: [
            SizedBox(
                width: size.width,
                child: SizedBox(
                  height: size.height * 0.25,
                  width: size.width,
                )),
            Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: Image(
                  image: AssetImage(photo?.path ?? 'assets/brand/logo.png'),
                  height: 200.0,
                  width: double.infinity,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            // _photoSelectWidget(),
          ],
        );
      } else {
        return Stack(
          children: [
            kIsWeb
                ? Image.network(
                    photo!.path,
                    height: 200.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(photo!.path),
                    height: 200.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            _photoSelectWidget(),
          ],
        );
      }
    }
  }

  Widget _photoSelectWidget() {
    return Positioned(
      bottom: 5,
      right: 15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            flagPhoto[2],
            style: const TextStyle(color: Colors.red),
          ),
          IconButton(
            icon: Icon(
              Icons.photo_size_select_actual,
              color: flagPhoto[1],
            ),
            onPressed: () async {
              photo = await openGallery();
              flagPhoto[0] = true;
              user.photoUrl = "";
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(
              Icons.camera_alt,
              color: flagPhoto[1],
            ),
            onPressed: () async {
              photo = await openCamera();
              flagPhoto[0] = true;
              user.photoUrl = "";
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}

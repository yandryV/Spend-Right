import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:spend_right/src/services/firebase_auth.dart';
import 'package:uuid/uuid.dart';

final firebaseServices = FirebaseServicesAuth();

void showAlert(BuildContext context, String title, String subtitle) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Text(title),
      content: Text(subtitle == ""
          ? 'Algo salio mal, vuelva a intentarlo mas tarde'
          : subtitle),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Continuar',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w700)),
        )
      ],
    ),
  );
}

Future<void> showSnackBar(BuildContext context, String message) async {
  // TODO: Success and Error snackbar
  Future.delayed(Duration.zero, () {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  });
}

Future<File> openCamera() async {
  XFile? photo = await ImagePicker()
      .pickImage(source: ImageSource.camera, imageQuality: 50);
  File file = File(photo!.path);

  return file;
}

Future<File> openGallery() async {
  XFile? photo = await ImagePicker()
      .pickImage(source: ImageSource.gallery, imageQuality: 50);
  File file = File(photo!.path);
  return file;
}

// bool isNumber(String? s) {
//   if (s!.isEmpty) {
//     return false;
//   }
//   final n = num.tryParse(s);
//   if (n == null) {
//     return false;
//   } else {
//     return true;
//   }
// }

Future<void> showLoading(BuildContext context) async {
  showDialog(
      context: context,
      builder: (context) => Container(
          height: 20,
          width: 20,
          color: Colors.white10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
              FutureBuilder(
                future: _closeLoading(context),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'Cerrar indicador',
                            style: TextStyle(color: Colors.white),
                          )),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          )));

  // FutureProgressDialog(getFuture()));
  // mostrarAlerta(context, result, 'Tiempo exedido al esperar respuesta');
}

Future<bool> _closeLoading(BuildContext context) async {
  await Future.delayed(const Duration(seconds: 10));
  return true;
}

class Utils {
  static String generateUID() {
    var uuid = const Uuid();
    return uuid.v4();
  }
}

final List<Map<String, dynamic>> categories = [
  {
    'label': 'Seleccione...',
    'icon': Icons.category,
  },
  {
    'label': 'Alimentos y bebidas',
    'icon': Icons.restaurant,
  },
  {
    'label': 'Transporte',
    'icon': Icons.directions_car,
  },
  {
    'label': 'Vivienda',
    'icon': Icons.home,
  },
  {
    'label': 'Entretenimiento',
    'icon': Icons.movie,
  },
  {
    'label': 'Salud y cuidado personal',
    'icon': Icons.favorite,
  },
  {
    'label': 'Educación',
    'icon': Icons.school,
  },
  {
    'label': 'Facturas y servicios públicos',
    'icon': Icons.receipt,
  },
  {
    'label': 'Compras',
    'icon': Icons.shopping_cart,
  },
  {
    'label': 'Ahorro e inversión',
    'icon': Icons.account_balance,
  },
  {
    'label': 'Deudas y préstamos',
    'icon': Icons.monetization_on,
  },
  {
    'label': 'Viajes y vacaciones',
    'icon': Icons.flight,
  },
  {
    'label': 'Regalos y donaciones',
    'icon': Icons.card_giftcard,
  },
  {
    'label': 'Seguros',
    'icon': Icons.security,
  },
  {
    'label': 'Impuestos',
    'icon': Icons.attach_money,
  },
  {
    'label': 'Mascotas',
    'icon': Icons.pets,
  },
  {
    'label': 'Niños y familia',
    'icon': Icons.child_friendly,
  },
  {
    'label': 'Negocios y emprendimiento',
    'icon': Icons.business,
  },
  {
    'label': 'Otros gastos',
    'icon': Icons.category,
  },
];

final Map<String, Color> categoryColors = {
  'Seleccione...': Colors.grey,
  'Alimentos y bebidas': Colors.green,
  'Transporte': Colors.blue,
  'Vivienda': Colors.orange,
  'Entretenimiento': Colors.purple,
  'Salud y cuidado personal': Colors.pink,
  'Educación': Colors.teal,
  'Facturas y servicios públicos': Colors.indigo,
  'Compras': Colors.amber,
  'Ahorro e inversión': Colors.deepPurple,
  'Deudas y préstamos': Colors.red,
  'Viajes y vacaciones': Colors.yellow,
  'Regalos y donaciones': Colors.lightGreen,
  'Seguros': Colors.lightBlue,
  'Impuestos': Colors.deepOrange,
  'Mascotas': Colors.blueGrey,
  'Niños y familia': Colors.cyan,
  'Negocios y emprendimiento': Colors.brown,
  'Otros gastos': Colors.grey,
};

final List<Map<String, int>> categoriesLimit = [
  {
    'Alimentos': 0,
  },
  {
    'Transporte': 0,
  },
  {
    'Vivienda': 0,
  },
  {
    'Entretenimiento': 0,
  },
  {
    'Salud y cuidado personal': 0,
  },
  {
    'Educación': 0,
  },
  {
    'Facturas y servicios públicos': 0,
  },
  {
    'Compras': 0,
  },
  {
    'Ahorro e inversión': 0,
  },
  {
    'Deudas y préstamos': 0,
  },
  {
    'Viajes y vacaciones': 0,
  },
  {
    'Regalos y donaciones': 0,
  },
  {
    'Seguros': 0,
  },
  {
    'Impuestos': 0,
  },
  {
    'Mascotas': 0,
  },
  {
    'Niños y familia': 0,
  },
  {
    'Negocios y emprendimiento': 0,
  },
  {
    'Otros gastos': 0,
  },
];

final Map<String, List<String>> categoryKeywords = {
  'Alimentos y bebidas': [
    'comida',
    'comidas',
    'bebida',
    'restaurante',
    'supermercado',
    'cafetería',
    'bar',
    'cena',
    'desayuno',
    'almuerzo'
  ],
  'Transporte': [
    'transporte',
    'vehículo',
    'viaje',
    'autobús',
    'metro',
    'tren',
    'avión',
    'taxi',
    'gasolina'
  ],
  'Vivienda': [
    'vivienda',
    'casa',
    'hogar',
    'alquiler',
    'hipoteca',
    'servicios públicos',
    'agua',
    'electricidad',
    'gas'
  ],
  'Entretenimiento': [
    'entretenimiento',
    'diversión',
    'cine',
    'teatro',
    'música',
    'concierto',
    'evento',
    'parque de atracciones'
  ],
  'Salud y cuidado personal': [
    'salud',
    'cuidado personal',
    'médico',
    'medicina',
    'farmacia',
    'seguro de salud',
    'gimnasio'
  ],
  'Educación': [
    'educación',
    'escuela',
    'universidad',
    'curso',
    'libro',
    'matrícula',
    'material educativo'
  ],
  'Facturas y servicios públicos': [
    'facturas',
    'servicios públicos',
    'teléfono',
    'internet',
    'televisión',
    'agua',
    'electricidad',
    'gas'
  ],
  'Compras': [
    'compras',
    'tienda',
    'ropa',
    'zapatos',
    'accesorios',
    'electrodomésticos',
    'compras en línea'
  ],
  'Ahorro e inversión': [
    'ahorro',
    'inversión',
    'cuenta bancaria',
    'inversiones',
    'acciones',
    'fondos'
  ],
  'Deudas y préstamos': [
    'deudas',
    'préstamos',
    'tarjeta de crédito',
    'préstamo estudiantil',
    'pagos',
    'intereses'
  ],
  'Viajes y vacaciones': [
    'viajes',
    'vacaciones',
    'hotel',
    'vuelo',
    'alojamiento',
    'turismo'
  ],
  'Regalos y donaciones': [
    'regalos',
    'donaciones',
    'caridad',
    'donar',
    'obsequio'
  ],
  'Seguros': [
    'seguros',
    'seguro',
    'seguro de vida',
    'seguro de auto',
    'seguro de hogar',
    'seguro de salud'
  ],
  'Impuestos': [
    'impuestos',
    'impuesto',
    'declaración de impuestos',
    'tributos',
    'renta',
    'IVA',
    'contribuciones'
  ],
  'Mascotas': [
    'mascotas',
    'mascota',
    'perro',
    'gato',
    'pienzo',
    'alimentación de mascotas',
    'veterinario',
    'cuidado de mascotas'
  ],
  'Niños y familia': [
    'niños',
    'familia',
    'juguetes',
    'ropa infantil',
    'guardería',
    'actividades familiares'
  ],
  'Negocios y emprendimiento': [
    'negocios',
    'emprendimiento',
    'start-up',
    'inversiones',
    'negocio propio'
  ],
  'Otros gastos': ['otros', 'gastos', 'varios', 'misceláneos'],
};

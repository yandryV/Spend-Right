import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_right/src/blocs/navigation/navigation_bloc.dart';
import 'package:spend_right/src/helpers/utils.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key});

  @override
  TransactionFormState createState() => TransactionFormState();
}

class TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseFirestore db = FirebaseFirestore.instance;
  String _title = '';
  String _description = '';
  double _amount = 0.0;
  DateTime _date = DateTime.now();
  String _category = '';
  String _paymentMethod = '';

  final List<Map<String, dynamic>> _categories = categories;

  @override
  void initState() {
    super.initState();
    _category = _categories[0]['label'] as String;
  }

  String getCategoryFromDescription(String description) {
    // Diccionario de palabras clave por categoría
    final Map<String, List<String>> categoryKeywordsList = categoryKeywords;

    // Convertir la descripción y las palabras clave a minúsculas
    final lowerDescription = description.toLowerCase();

    // Contador de ocurrencias de palabras clave por categoría
    final Map<String, int> categoryMatches = {};

    // Recorrer las categorías y contar las ocurrencias de palabras clave
    for (var category in categoryKeywordsList.keys) {
      categoryMatches[category] = 0;
      for (var keyword in categoryKeywordsList[category]!) {
        if (lowerDescription.contains(keyword)) {
          categoryMatches[category] = (categoryMatches[category] ?? 0) + 1;
        }
      }
    }

    // Obtener la categoría con más ocurrencias de palabras clave
    String selectedCategory = _categories[0]['label'] as String;
    int maxMatches = 0;
    for (var category in categoryMatches.keys) {
      if (categoryMatches[category]! > maxMatches) {
        selectedCategory = category;
        maxMatches = categoryMatches[category]!;
      }
    }

    return selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de transacciones'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Título',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese un título';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                      _category = getCategoryFromDescription(_description);
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese una descripción';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Cantidad',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingrese una cantidad';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Por favor, ingrese una cantidad válida';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _amount = double.parse(value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        width: 260,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Categoría',
                          ),
                          value: _category.isNotEmpty ? _category : null,
                          items:
                              _categories.map((Map<String, dynamic> category) {
                            return DropdownMenuItem<String>(
                              value: category['label'] as String,
                              child: Row(
                                children: [
                                  Icon(category['icon'] as IconData),
                                  const SizedBox(width: 8),
                                  Text(category['label'] as String),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _category = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value == _categories[0]['label']) {
                              return 'Por favor, seleccione una categoría';
                            }
                            return null;
                          },
                          icon: _category.isNotEmpty
                              ? Icon(
                                  _categories.firstWhere(
                                    (category) =>
                                        category['label'] == _category,
                                  )['icon'] as IconData,
                                )
                              : null,
                          isExpanded: true,
                          itemHeight: 60,
                          dropdownColor: Colors.white,
                          elevation: 8,
                          style: const TextStyle(color: Colors.black),
                          selectedItemBuilder: (BuildContext context) {
                            return _categories
                                .map<Widget>((Map<String, dynamic> category) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Text(category['label'] as String),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Fecha',
                  ),
                  readOnly: true,
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _date = selectedDate;
                      });
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, seleccione una fecha';
                    }
                    return null;
                  },
                  controller: TextEditingController(
                    text: DateFormat('dd/MM/yyyy').format(_date),
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Método de pago',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese un método de pago';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _paymentMethod = value!;
                  },
                ),
                const SizedBox(height: 16),
                uploadData()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget uploadData() {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    return MaterialButton(
      child: const Text('Guardar'),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          FirebaseFirestore firestore = FirebaseFirestore.instance;
          // Agregar la transacción a la colección "transactions" en Firebase
          await firestore.collection('transactions').add({
            'uid': uid,
            'title': _title,
            'description': _description,
            'amount': _amount,
            'category': _category,
            'method': _paymentMethod,
            'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(_date),
          });
          onExit();
        } else {
          showSnackBar(context, 'Error al guardar la transacción.');
        }
      },
    );
  }

  onExit() {
    final snackBarItem = showSnackBar(context, 'Guardado con éxito');
    context.read<NavigationBloc>().add(
        NavigateToPage("/transaction-detail-page", "pushReplacementNamed"));
    return snackBarItem;
  }
}

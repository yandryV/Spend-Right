import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../helpers/utils.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key});

  @override
  BudgetScreenState createState() => BudgetScreenState();
}

class BudgetScreenState extends State<BudgetScreen> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  double _totalAmount = 0.0;
  double _amountCategory = 0.0;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String _category = '';

  double _percentage = 0.0;

  final List<Map<String, dynamic>> _categories = categories;
  List<TextEditingController> _budgetControllers = [];
  List<DropdownButtonFormField<String>> _categoryDropdowns = [];
  List<String> _selectedCategories = [];

  final ValueNotifier<double?> _percentageNotifier = ValueNotifier<double?>(null);

  @override
  void initState() {
    super.initState();
    _addBudgetField(); // Añadir el primer campo de presupuesto y categoría inicial
  }

  @override
  void dispose() {
    for (var controller in _budgetControllers) {
      controller.dispose();
    }
        _percentageNotifier.dispose();

    super.dispose();
  }

  void _addBudgetField() {
    final budgetController = TextEditingController();
    final categoryDropdown = DropdownButtonFormField<String>(
      value: _categories[0]['label'] as String,
      items: _categories.map((category) {
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
          _selectedCategories.add(value ?? '');
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
      
    );

    setState(() {
      _budgetControllers.add(budgetController);
      _categoryDropdowns.add(categoryDropdown);
    });
  }

  void _calculatePercentage() {
    if (_totalAmount != 0.0) {
      _percentage = (_amountCategory / _totalAmount) * 100;
    } else {
      _percentage = 0.0;
    }
  }

  Widget _buildBudgetField(int index) {
    final budgetController = _budgetControllers[index];

    return Row(
      children: [
        Expanded(
          flex: 4, // Ocupa el 30% del ancho
          child: TextFormField(
            controller: budgetController,
            decoration: const InputDecoration(labelText: 'Cantidad'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor, ingrese una cantidad';
              }
              if (double.tryParse(value) == null) {
                return 'Por favor, ingrese una cantidad válida';
              }
              return null;
            },
          onChanged: (value) {
            setState(() {
              _amountCategory = double.tryParse(value) ?? 0.0;
              _calculatePercentage();
            });
          },
            onSaved: (value) {
              _amountCategory = double.parse(value!);
              _calculatePercentage();
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            '${_percentage.toStringAsFixed(2)}%', // Muestra el porcentaje actualizado
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 8, // Ocupa el 70% del ancho
          child: SizedBox(
            width: 240, // Establece un ancho fijo aquí
            child: DropdownButtonFormField<String>(
              value: _categories[0]['label'] as String,
              items: _categories.map((category) {
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
                  _selectedCategories.add(value ?? '');
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
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Presupuesto'),
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
                    labelText: 'Monto total',
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
                    _totalAmount = double.parse(value!);
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Fecha de inicio',
                        ),
                        readOnly: true,
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: _startDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              _startDate = selectedDate;
                            });
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, seleccione una fecha';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                        controller: TextEditingController(
                          text: DateFormat('dd/MM/yyyy').format(_startDate),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Fecha fin',
                        ),
                        readOnly: true,
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: _endDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              _endDate = selectedDate;
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
                          text: DateFormat('dd/MM/yyyy').format(_endDate),
                        ),
                      ),
                    ),
                  ],
                ),
                for (var i = 0; i < _budgetControllers.length; i++)
                  _buildBudgetField(i),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addBudgetField,
                  child: const Text('Añadir'),
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
          Map<String, dynamic> budgetData = {
            'uid': uid,
            'title': _title,
            'totalAmount': _totalAmount,
            'categories': _selectedCategories,
            'startDate': DateFormat('yyyy-MM-dd HH:mm:ss').format(_startDate),
            'endDate': DateFormat('yyyy-MM-dd HH:mm:ss').format(_endDate),
          };
          await firestore.collection('budget').add(budgetData);
          onSuccess();
        } else {
          showSnackBar(context, 'Error al guardar la transacción.');
        }
      },
    );
  }

  onSuccess() {
    final snackBarItem = showSnackBar(context, 'Guardado con éxito');
    // context.read<NavigationBloc>().add(
    //     NavigateToPage("/transaction-detail-page", "pushReplacementNamed"));
    return snackBarItem;
  }
}

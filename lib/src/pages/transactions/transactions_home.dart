import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spend_right/src/widgets/bottom_navigation_bar.dart';

import '../../helpers/utils.dart';

class TransactionHome extends StatelessWidget {
  TransactionHome({super.key});

  final List<Map<String, dynamic>> _categories = categories;

  final Map<String, Color> _categoryColors = categoryColors;
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color.fromARGB(146, 0, 0, 0),
      appBar: AppBar(
        title: const Text('Mis Transacciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('transactions')
                .where('uid', isEqualTo: uid)
                .orderBy('date', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error al cargar los datos');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                return const Text('No hay transacciones disponibles');
              }

              Map<String, dynamic> latestTransactions = {};

              for (var transaction in snapshot.data!.docs) {
                String category = transaction['category'] ?? '';
                latestTransactions[category] = transaction;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _categories.map((category) {
                  String categoryLabel = category['label'];
                  var latestTransaction = latestTransactions[categoryLabel];

                  if (latestTransaction == null) {
                    return const SizedBox.shrink();
                  }
                  String title = latestTransaction['title'] ?? '';
                  String description = latestTransaction['description'] ?? '';
                  double amount = latestTransaction['amount'] ?? 0.0;
                  String date = latestTransaction['date'] ?? '';
                  DateTime parsedDate = DateTime.parse(date);
                  String formattedDate =
                      DateFormat.yMd().add_Hm().format(parsedDate);
                  String method = latestTransaction['method'] ?? '';
                  return Card(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: _categoryColors[categoryLabel] ?? Colors.red,
                            width: 5.0,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      category['icon'],
                                      color: _categoryColors[categoryLabel] ??
                                          Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      categoryLabel,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/chart',
                                        arguments:
                                            categoryLabel, // Pasa la categoría seleccionada como argumento
                                      );
                                    },
                                    icon: Icon(Icons.bar_chart_outlined,
                                        color: _categoryColors[categoryLabel] ??
                                            Colors.red))
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              description,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              method,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Fecha: $formattedDate',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  'Monto: \$${amount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_right/src/blocs/navigation/navigation_bloc.dart';
import 'package:spend_right/src/helpers/utils.dart';

import '../../models/transactions_model.dart';

class TransactionDetailPage extends StatelessWidget {
  const TransactionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de transacciones'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('transactions')
            .where('uid', isEqualTo: uid)
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error al cargar las transacciones: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          List<TransactionModel> transactions = snapshot.data!.docs.map((doc) {
            return TransactionModel.fromJson(
                doc.id, doc.data() as Map<String, dynamic>);
          }).toList();

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              TransactionModel transaction = transactions[index];
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) async {
                  await FirebaseFirestore.instance
                      .collection('transactions')
                      .doc(transaction.id)
                      .delete();
                },
                confirmDismiss: (direction) async {
                  try {
                    return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirmar eliminación"),
                            content: const Text(
                                "¿Estás seguro de que deseas eliminar esta transacción?"),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("Cancelar")),
                              TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("Eliminar")),
                            ],
                          );
                        });
                  } catch (e) {
                    showSnackBar(
                        context, 'Error al eliminar la transacción');
                        // print(e);
                  }
                  return null;
                },
                child: ListTile(
                  title: Text(transaction.description),
                  subtitle: Text(
                      '${transaction.amount} - ${transaction.category} - ${transaction.method}'),
                  trailing: Text(transaction.date.toIso8601String()),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context
              .read<NavigationBloc>()
              .add(NavigateToPage("/transaction", "pushReplacementNamed"));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

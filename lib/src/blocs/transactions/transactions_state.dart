part of 'transactions_bloc.dart';

@immutable
class TransactionsState {
  final String id;
  final bool idState;
  final String amount;
  final String amountState;
  final String category;
  final String categoryState;
  final String method;
  final String methodState;

  const TransactionsState({
    this.id = "",
    this.idState = true,
    this.amount = "",
    this.amountState = "",
    this.category = "",
    this.categoryState = "",
    this.method = "",
    this.methodState = "",
  });

  TransactionsState copyWith(
          {String? id,
          bool? idState,
          String? amount,
          String? amountState,
          String? category,
          String? categoryState,
          String? method,
          String? methodState}) =>
      TransactionsState(
        id: id ?? this.id,
        idState: idState ?? this.idState,
        amount: amount ?? this.amount,
        amountState: amountState ?? this.amountState,
        category: category ?? this.category,
        categoryState: categoryState ?? this.categoryState,
        method: method ?? this.method,
        methodState: methodState ?? this.methodState,
      );
}

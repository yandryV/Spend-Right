part of 'transactions_bloc.dart';

@immutable
abstract class TransactionsEvent {}

class onUploadData extends TransactionsEvent {
  final String description;
  onUploadData(this.description);
}

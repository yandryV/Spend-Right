import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../helpers/preferences.dart';
import '../../services/firebase_auth.dart';
import '../../services/firebase_database.dart';
import '../../services/firebase_storage.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {

  // final NavigationBloc _navigationBloc;
  final firebaseServicesAuth = FirebaseServicesAuth();
  final firebaseServicesDatabase = FirebaseServicesDatabase();
  final firebaseServicesStorage = FirebaseServicesStorage();

  final preferences = Preferences();

  TransactionsBloc() : super(const TransactionsState()) {
    on<onUploadData>(mapOnUploadData);
  }
}

void mapOnUploadData(event, Emitter emit) async{
}

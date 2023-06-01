import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_right/firebase_options.dart';
import 'package:spend_right/src/blocs/auth/auth_bloc.dart';
import 'package:spend_right/src/blocs/navigation/navigation_bloc.dart';
import 'package:spend_right/src/helpers/preferences.dart';
import 'package:spend_right/src/models/user_model.dart';
import 'package:spend_right/src/pages/auth/login.dart';
import 'package:spend_right/src/pages/budget/budget_screen.dart';
import 'package:spend_right/src/pages/navigation/navigation_page.dart';
import 'package:spend_right/src/pages/transactions/graphs_screen.dart';
import 'package:spend_right/src/pages/transactions/transactions.dart';
import 'package:spend_right/src/pages/transactions/transactions_home.dart';
import 'package:spend_right/src/pages/transactions/transactions_page.dart';
import 'package:spend_right/src/pages/user/user-profile.dart';
import 'package:spend_right/src/pages/user/user_register.dart';
import 'package:spend_right/src/pages/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = Preferences();
  await preferences.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final preferences = Preferences();
    String principalPage;
    if (preferences.user == "") {
      principalPage = '/login';
    } else {
      final user = UserModel.fromJson(json.decode(preferences.user));
      if (user.profileCompleted()) {
        principalPage = '/welcome';
      } else {
        principalPage = '/user-register';
      }
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NavigationBloc(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(context.read<NavigationBloc>()),
        ),
      ],
      child: MaterialApp(
        title: 'Spend Right',
        debugShowCheckedModeBanner: false,
        home: const NavigationPage(),
        initialRoute: principalPage,
        routes: {
          // '/test': (BuildContext context) => const TestPage(),
          '/login': (BuildContext context) => const LogInPage(),
          '/welcome': (BuildContext context) => const WelcomePage(),
          // '/menu': ((BuildContext context) => const MenuPage()),
          '/user-register': ((BuildContext context) =>
              const UserRegisterPage()),
          '/transaction-home': ((BuildContext context) => TransactionHome()),
          '/transaction-form': ((BuildContext context) =>
              const TransactionForm()),
          '/transaction-detail-page': ((BuildContext context) =>
              const TransactionDetailPage()),
          '/user-profile': ((BuildContext context) => const UserProfile()),
          '/chart': ((BuildContext context) =>  const GraphScreen()),  
          '/budget-screen': ((BuildContext context) => const BudgetScreen()),  
        },
        theme: ThemeData(
            colorScheme: const ColorScheme(
                primary: Color(0xFF009688),
                secondary: Color(0xFF80CBC4),
                surface: Color(0xFFFFFFFF),
                background: Color(0xFFE0F2F1),
                error: Color(0xFFB00020),
                onPrimary: Color(0xFFFFFFFF),
                onSecondary: Color(0xFF000000),
                onSurface: Color(0xFF000000),
                onBackground: Color(0xFF000000),
                onError: Color(0xFF000000),
                brightness: Brightness.light)),
      ),
    );
  }
}
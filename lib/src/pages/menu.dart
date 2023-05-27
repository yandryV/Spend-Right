// import 'package:flutter/material.dart';
// import 'package:spend_right/src/helpers/preferences.dart';
// import 'package:spend_right/src/widgets/custom_appbar_widget.dart';

// class MenuPage extends StatefulWidget {
//   const MenuPage({Key? key}) : super(key: key);

//   @override
//   State<MenuPage> createState() => _MenuPageState();
// }

// class _MenuPageState extends State<MenuPage> {
//   int _page = 0;
//   final GlobalKey _bottomNavigationKey = GlobalKey();
//   final preferences = Preferences();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBarWidget(leading: Container(), leadingWidth: 0),
//       bottomNavigationBar: CurvedNavigationBar(
//         key: _bottomNavigationKey,
//         index: 0,
//         height: 50.0,
//         items: const <Widget>[
//           Icon(
//             Icons.home,
//             size: 30,
//             color: Colors.white,
//           ),
//           Icon(
//             Icons.account_circle,
//             size: 30,
//             color: Colors.white,
//           ),
//         ],
//         color: Theme.of(context).colorScheme.primary,
//         buttonBackgroundColor: Theme.of(context).colorScheme.secondary,
//         backgroundColor: Colors.white,
//         animationCurve: Curves.easeInOut,
//         animationDuration: const Duration(milliseconds: 600),
//         onTap: (index) {
//           setState(() {
//             _page = index;
//           });
//         },
//       ),
//       body: _paginas(_page),
//     );
//   }

//   Widget _paginas(int index) {
//     switch (index) {
//       case 0:
//         return const HomePage();
//       case 1:
//         return const UserInformationPage();
//       default:
//         return const HomePage();
//     }
//   }
// }

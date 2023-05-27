import 'package:flutter/material.dart';


class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  BottomNavigationBarWidgetState createState() =>
      BottomNavigationBarWidgetState();
}

class BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });

        switch (index) {
          case 0:
          Navigator.of(context).pushReplacementNamed('/transaction-home');
            break;
          case 1:
          Navigator.of(context).pushReplacementNamed('/welcome');
            break;
          case 2:
            Navigator.of(context).pushReplacementNamed('/user-profile');

            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}

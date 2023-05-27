
import 'package:flutter/material.dart';

Route navigationFadeIn(BuildContext context, Widget pagina) {
  return PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          pagina,
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondAnimation, child) {
        return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: child);
      });
}

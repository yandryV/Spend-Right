// import 'dart:js';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class Responsive {
  double? _width, _height, _diagonal;
  bool? _isMobile;

  double? get width => _width;
  double? get height => _height;
  double? get diagonal => _diagonal;
  bool? get isMobile => _isMobile;

  static Responsive of(BuildContext context) => Responsive(context);
  
  Responsive(BuildContext context){
    final Size size = MediaQuery.of(context).size;  
    _width = size.width;
    _height = size.height;

    _diagonal = math.sqrt(math.pow(_width as num, 2)+math.pow(_width as num, 2));

    _isMobile = size.shortestSide <= 600;
  }

  double wp(double percent) => _width! * percent / 100;
  double hp(double percent) => _height! * percent / 100;
  double dp(double percent) => _diagonal! * percent / 100;

}
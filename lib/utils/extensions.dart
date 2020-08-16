/*
 * Created by Simon Pham on Jul 27, 2020
 * Email: simon@simonit.dev
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ColorExtension on Color {
  String toHex() {
    return "#${this.value.toRadixString(16).padLeft(8, '0')}";
  }
}

extension NumExtension on num {
  String get formatted {
    return NumberFormat('#,###').format(this);
  }
}

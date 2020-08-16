/*
 * Created by Simon Pham on Jul 27, 2020
 * Email: simon@simonit.dev
 */

import 'package:flutter/material.dart';

extension ColorExtension on Color {
  String toHex() {
    return "#${this.value.toRadixString(16).padLeft(8, '0')}";
  }
}

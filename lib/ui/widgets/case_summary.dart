/*
 * Created by Simon Pham on Aug 16, 2020
 * Email: simon@simonit.dev
 */

import 'package:fluda/fluda.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CaseSummary extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const CaseSummary({
    Key key,
    this.title,
    this.subtitle,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: -1,
        color: color.withOpacity(0.05),
      ),
      child: Column(
        children: [
          NeumorphicText(
            title ?? "",
            style: NeumorphicStyle(
              color: color,
            ),
            textStyle: NeumorphicTextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          NeumorphicText(
            subtitle ?? "",
            style: NeumorphicStyle(
              color: color,
            ),
          ).marginTop(),
        ],
      ).padVertical(3),
    );
  }
}

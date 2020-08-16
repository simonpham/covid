/*
 * Created by Simon Pham on Aug 16, 2020
 * Email: simon@simonit.dev
 */

import 'dart:math';

import 'package:covid/providers/covid_stats.dart';
import 'package:fluda/fluda.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../../constants/numbers.dart';
import 'map_country.dart';

class WorldMapSliverAppBar extends SliverPersistentHeaderDelegate {

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double _opacity =
        max(0.0, 1.0 - shrinkOffset / kExpandedAppBarHeight);
    return Consumer<CovidStats>(
      builder: (_, CovidStats provider, __) {
        return Stack(
          children: [
            Positioned(
              top: FludaX.x6,
              left: 0,
              right: 0,
              child: NeumorphicText(
                "Worldwide COVID-19",
                style: NeumorphicStyle(
                  color: Colors.redAccent.withOpacity(
                    _opacity,
                  ),
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: FludaX.x4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]..addAll(
            provider.countries.values.map(
                  (MapCountry country) {
                return Positioned(
                  top: 0 - shrinkOffset * 2 * country.doubleRandom,
                  left: 0 - shrinkOffset * 2 * country.doubleRandom,
                  right: 0 - shrinkOffset * 2 * country.doubleRandom,
                  bottom: -100,
                  child: Opacity(
                    opacity: _opacity,
                    child: country,
                  ),
                );
              },
            ).toList(growable: false),
          ),
        );
      },
    );
  }

  @override
  double get maxExtent => kExpandedAppBarHeight;

  @override
  double get minExtent => kCollapsedAppBarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

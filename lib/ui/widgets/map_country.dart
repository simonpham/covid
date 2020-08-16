/*
 * Created by Simon Pham on Aug 16, 2020
 * Email: simon@simonit.dev
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/colors.dart';
import '../../data/world_map.dart';
import '../../utils/extensions.dart';

class MapCountry extends StatefulWidget {
  final double doubleRandom;
  final String country;

  const MapCountry({Key key, this.country, this.doubleRandom})
      : super(key: key);

  @override
  _MapCountryState createState() => _MapCountryState();
}

class _MapCountryState extends State<MapCountry> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      '''
      <svg height="400" width="1000">
          <path d="${worldMap["shapes"][widget.country]}" stroke="${kBackgroundColor.toHex()}" stroke-width="1" fill="${(isHover ? kMostInfectedColor : kLessInfectedColor).toHex()}" />
      </svg>
          ''',
      key: UniqueKey(),
    );
  }
}

/*
 * Created by Simon Pham on Aug 16, 2020
 * Email: simon@simonit.dev
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/colors.dart';
import '../../data/world_map.dart';
import '../../utils/extensions.dart';

class MapCountry extends StatelessWidget {
  final double doubleRandom;
  final String country;
  final Color color;

  const MapCountry({Key key, this.country, this.doubleRandom, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      '''
      <svg height="400" width="1000">
          <path d="${worldMap["shapes"][country]}" stroke="${kBackgroundColor.toHex()}" stroke-width="1" fill="${(color ?? kLessInfectedColor).toHex()}" />
      </svg>
          ''',
      key: UniqueKey(),
    );
  }
}

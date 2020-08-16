/*
 * Created by Simon Pham on Aug 16, 2020
 * Email: simon@simonit.dev
 */

import 'package:flag/flag.dart';
import 'package:fluda/fluda.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../models/country.dart';
import '../../utils/extensions.dart';

enum TopCase {
  confirmed,
  recovered,
  death,
}

class TopCountries extends StatelessWidget {
  final List<Country> countries;
  final TopCase topCase;

  const TopCountries(
    this.countries, {
    Key key,
    this.topCase,
  }) : super(key: key);

  int getTotalNumber(Country country) {
    switch (topCase) {
      case TopCase.confirmed:
        return country.totalConfirmed;
      case TopCase.recovered:
        return country.totalRecovered;
      case TopCase.death:
        return country.totalDeaths;
    }
    return 0;
  }

  int getNewNumber(Country country) {
    switch (topCase) {
      case TopCase.confirmed:
        return country.newConfirmed;
      case TopCase.recovered:
        return country.newRecovered;
      case TopCase.death:
        return country.newDeaths;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      margin: const EdgeInsets.all(FludaX.x3),
      child: Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 32),
              NeumorphicText(
                "Name",
                textAlign: TextAlign.center,
                textStyle: NeumorphicTextStyle(
                  fontWeight: FontWeight.w500,
                ),
                style: NeumorphicStyle(
                  color: Colors.black,
                ),
              ).expand(),
              NeumorphicText(
                "Total",
                textAlign: TextAlign.center,
                textStyle: NeumorphicTextStyle(
                  fontWeight: FontWeight.w500,
                ),
                style: NeumorphicStyle(
                  color: Colors.black,
                ),
              ).expand(),
              NeumorphicText(
                "New",
                textAlign: TextAlign.center,
                textStyle: NeumorphicTextStyle(
                  fontWeight: FontWeight.w500,
                ),
                style: NeumorphicStyle(
                  color: Colors.black,
                ),
              ).expand(),
            ],
          ).padHorizontal(2).marginTop(3),
          ListView.builder(
            padding: const EdgeInsets.only(
              left: FludaX.x2,
              right: FludaX.x2,
              bottom: FludaX.x3,
              top: FludaX.x2,
            ),
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: countries.length,
            itemBuilder: (context, index) {
              final country = countries[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flag(
                        country.countryCode,
                        height: 24,
                        width: 24,
                      ).marginRight(),
                      Text(
                        country.country,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ).expand(),
                      Text(
                        getTotalNumber(country).formatted,
                        textAlign: TextAlign.center,
                      ).expand(),
                      Text(
                        getNewNumber(country).formatted,
                        textAlign: TextAlign.center,
                      ).expand(),
                    ],
                  ).padVertical(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

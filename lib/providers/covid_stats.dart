/*
 * Created by Simon Pham on Aug 16, 2020
 * Email: simon@simonit.dev
 */

import 'dart:math';

import 'package:covid/constants/colors.dart';
import 'package:covid/data/world_map.dart';
import 'package:covid/ui/widgets/map_country.dart';
import 'package:flutter/foundation.dart';

import '../main.dart';
import '../models/country.dart';
import '../models/world_summary.dart';

class CovidStats with ChangeNotifier {
  WorldSummary worldSummary;

  List<Country> topConfirmedCountries = [];

  List<Country> topRecoveredCountries = [];

  List<Country> topDeathCountries = [];

  Map<String, MapCountry> countries = {};

  Future<void> loadWorldSummary() async {
    worldSummary = await services.loadGlobalSummary();
    notifyListeners();
  }

  Future<void> loadTopCountries() async {
    topConfirmedCountries.addAll(worldSummary.countries);
    topDeathCountries.addAll(worldSummary.countries);
    topRecoveredCountries.addAll(worldSummary.countries);

    topConfirmedCountries.sort((a, b) => b.totalConfirmed - a.totalConfirmed);
    topDeathCountries.sort((a, b) => b.totalDeaths - a.totalDeaths);
    topRecoveredCountries.sort((a, b) => b.totalRecovered - a.totalRecovered);

    notifyListeners();
  }

  Future<void> loadMap() async {
    for (var country in worldMap["shapes"].keys) {
      final random = Random().nextDouble();
      countries[country] = MapCountry(
        country: country,
        doubleRandom: random,
      );
    }
    notifyListeners();
  }

  Future<void> updateMap() async {
    final Map<String, MapCountry> newCountries = Map.from(countries);
    for (var country in topConfirmedCountries) {
      if (country.totalConfirmed > worldSummary.global.totalConfirmed * 0.005)
        newCountries[country.countryCode.toUpperCase()] = MapCountry(
          country: country.countryCode.toUpperCase(),
          doubleRandom: Random().nextDouble(),
          color: kMostInfectedColor,
        );
    }
    countries = newCountries;
    notifyListeners();
  }
}

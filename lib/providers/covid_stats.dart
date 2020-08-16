/*
 * Created by Simon Pham on Aug 16, 2020
 * Email: simon@simonit.dev
 */

import 'package:flutter/foundation.dart';

import '../main.dart';
import '../models/country.dart';
import '../models/world_summary.dart';

class CovidStats with ChangeNotifier {
  WorldSummary worldSummary;

  List<Country> topConfirmedCountries = [];

  List<Country> topRecoveredCountries = [];

  List<Country> topDeathCountries = [];

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
}

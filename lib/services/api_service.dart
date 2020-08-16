/*
 * Created by Simon Pham on Aug 16, 2020
 * Email: simon@simonit.dev
 */

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/world_summary.dart';

const _kEndpoint = "https://api.covid19api.com";

class ApiService {
  static final ApiService _internal = ApiService.internal();

  factory ApiService() => _internal;

  ApiService.internal();

  Future<WorldSummary> loadGlobalSummary() async {
    try {
      final res = await http.get("$_kEndpoint/summary");
      if (res.statusCode == HttpStatus.ok) {
        final Map<String, dynamic> body = jsonDecode(res.body);
        return WorldSummary.fromJson(body);
      }
      throw Exception(res.statusCode);
    } catch (err) {
      rethrow;
    }
  }
}

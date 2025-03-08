import 'dart:convert';

import 'package:daily_amol/model/AmolModel.dart';
import 'package:daily_amol/service/shared_data.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Amolserve {
  static Future<List<AmolModel>> loadJsonData() async {
    final String jsonString = await rootBundle.loadString(
      'assets/json/data.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);
    List<AmolModel> jsonData =
        jsonList.map((json) => AmolModel.fromJson(json)).toList();
    return jsonData;
  }

  static bool checkInitData() {
    final init = SharedData.getBool('init');
    if (init == false || init == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<void> setAmols() async {
    SharedData.setBool('init', true);
    final amolString = json.encode(await loadJsonData());
    SharedData.setString('amols', amolString);
    SharedData.setString(
      'date',
      DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    SharedData.setInt('day', 1);
  }

  static void resetAmols() async {
    SharedData.clearAll();
    await setAmols();
  }

  static List<AmolModel> getAmols() {
    final amolString = SharedData.getString('amols');
    if (amolString != null) {
      try {
        final List<dynamic> amolsJson = json.decode(amolString);
        return amolsJson
            .map((amolJson) => AmolModel.fromJson(amolJson))
            .toList();
      } catch (e) {
        return [];
      }
    } else {
      return [];
    }
  }

  static List<AmolModel> getFavouriteAmols() {
    final amolString = SharedData.getString('amols');
    if (amolString != null) {
      try {
        final List<dynamic> amolsJson = json.decode(amolString);
        return amolsJson
            .map((amolJson) => AmolModel.fromJson(amolJson))
            .where((amol) => amol.favourite)
            .toList();
      } catch (e) {
        return [];
      }
    } else {
      return [];
    }
  }

  static String getMode() {
    final mode = SharedData.getString('mode');
    if (mode!= null) {
      return mode;
    } else {
      return 'volume_off';
    }
  }
}

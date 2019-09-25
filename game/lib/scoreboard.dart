import 'package:flutter/services.dart' show rootBundle;
import 'package:dio/dio.dart';

import 'screens/game/hats.dart';

Hat hatFromString(String value) => Hat.values.firstWhere((h) => h.toString() == value);

class ScoreBoardEntry {
  String playerId;
  int points;
  Hat hat;

  static ScoreBoardEntry fromJson(Map<String, dynamic> json) {
    return ScoreBoardEntry()
        ..hat = hatFromString(json["metadata"])
        ..points = (json["score"] as double).toInt()
        ..playerId = json["playerId"];
  }
}

class ScoreBoard {
  static String uuid;
  static const String host = "https://api.score.fireslime.xyz";

  static Future<String> getUuid() async {
    if (uuid == null) {
      uuid = await rootBundle.loadString('assets/firescore_uuid');

      uuid = uuid.replaceAll("\n", "");
    }
    return uuid;
  }

  static Future<List<ScoreBoardEntry>> fetchScoreboard() async {
    final _uuid = await getUuid();
    print("$host/scores/$_uuid?sortOrder=ASC");
    Response resp = await Dio().get("$host/scores/$_uuid?sortOrder=ASC");

    final data = resp.data;
    if (data is List) {
      return data.map((entry) => ScoreBoardEntry.fromJson(entry)).toList();
    }

    return [];
  }
}

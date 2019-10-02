import 'package:flutter/services.dart' show rootBundle;
import 'package:dio/dio.dart';

import 'screens/game/hats.dart';
import './game_data.dart';

Hat hatFromString(String value) => Hat.values.firstWhere(
    (h) => h.toString() == value,
    orElse: () => null
);

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
    Response resp = await Dio().get("$host/scores/$_uuid?sortOrder=DESC");

    final data = resp.data;
    if (data is List) {
      return data.map((entry) => ScoreBoardEntry.fromJson(entry)).toList();
    }

    return [];
  }

  static Future<bool> isPlayerIdAvailable(String playerId) async {
    final _uuid = await getUuid();
    Response resp = await Dio().get("$host/scores/$_uuid?sortOrder=DESC&playerId=$playerId");

    final data = resp.data;

    if (data is List) {
      return data.length == 0;
    }

    throw ("Could not check player id availability");
  }

  static Future<void> submit(double score) async {
    final lastSubmittedScore = await GameData.getLastSubmittedScore();

    if (lastSubmittedScore == null || score > lastSubmittedScore) {
      // Get the token
      final _uuid = await getUuid();
      final tokenResponse = await Dio().get("$host/scores/token/$_uuid");
      final token = tokenResponse.data["token"] as String;

      final currentHat = await GameData.getCurrentHat();
      final playerId = await GameData.playerId();

      if (playerId != null) {
        final submitResponse = await Dio().put(
            "$host/scores",
            data: {
              "playerId": playerId,
              "score": score,
              "metadata": currentHat != null ? currentHat.toString() : null,
            },
            options: Options(
                headers: {
                  "Authorization": "Bearer $token"
                }
            ),
        );

        print(submitResponse);
        if (submitResponse.statusCode != 204) {
          print(submitResponse);
          throw "Could not submit the score";
        } else {
          await GameData.setLastSubmittedScore(score);
        }
      }
    }
  }
}

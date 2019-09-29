import "package:shared_preferences/shared_preferences.dart";

import "screens/game/hats.dart";

class GameData {
  static void updateScore(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentScore = prefs.getInt("score") ?? 0;

    if (score > currentScore) {
      await prefs.setInt("score", score);
    }
  }

  static Future<int> getScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("score");
  }

  static void updateCoins(int coins) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("coins", coins);
  }

  static Future<int> getCoins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("coins") ?? 0;
  }

  static Future<void> setCurrentHat(Hat hat) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (hat == null) {
      prefs.remove("currentHat");
    } else {
      prefs.setString("currentHat", hat.toString());
    }
  }

  static Future<Hat> getCurrentHat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final hatString = prefs.getString("currentHat");

    if (hatString != null) {
      return _hatFromString(hatString);
    }

    return null;
  }

  static Future<void> setOwnedHats(List<Hat> hats) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("ownedHats", hats.map((hat) => hat.toString()).toList());
  }

  static Future<List<Hat>> getOwnedHats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> hatList = prefs.getStringList("ownedHats");

    if (hatList == null) return [];

    return hatList.map((hatString) => _hatFromString(hatString)).toList();
  }

  static Hat _hatFromString(String hatString) => Hat.values.firstWhere((hat) => hat.toString() == hatString);


  static Future<bool> isSoundsEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool soundsEnabled = prefs.getBool("soundsEnabled");

    if (soundsEnabled == null) return true;

    return soundsEnabled;
  }

  static Future<void> setSoundsEnabled(bool soundsEnabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("soundsEnabled", soundsEnabled);
  }

  static Future<String> playerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("playerId");
  }

  static Future<void> setPlayerId(String playerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("pplayerId", playerId);
  }
}

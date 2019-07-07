import "package:shared_preferences/shared_preferences.dart";

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
}

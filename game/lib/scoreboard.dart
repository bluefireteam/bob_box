import 'screens/game/hats.dart';

class ScoreBoardEntry {
  String playerId;
  int points;
  Hat hat;
}

class ScoreBoard {
  static Future<List<ScoreBoardEntry>> fetchScoreboard() async {
    return []
        ..add(
            ScoreBoardEntry()
              ..playerId = "Ty"
              ..points = 168
              ..hat = Hat.DIVER
        )
        ..add(
            ScoreBoardEntry()
              ..playerId = "CptBlackPixel"
              ..points = 163
              ..hat = Hat.ASSASSIN
        )
        ..add(
            ScoreBoardEntry()
              ..playerId = "Don Vito Corleone"
              ..points = 150
              ..hat = Hat.KING
        )
        ..add(
            ScoreBoardEntry()
              ..playerId = "James Bond"
              ..points = 120
              ..hat = Hat.COP
        )
        ..add(
            ScoreBoardEntry()
              ..playerId = "Jack Sparrow"
              ..points = 111
              ..hat = Hat.PIRATE_CAPTAIN
        )
        ..add(
            ScoreBoardEntry()
              ..playerId = "Ozzy Osbourne"
              ..points = 101
              ..hat = Hat.CHEF
        )
        ..add(
            ScoreBoardEntry()
              ..playerId = "Ozzy Osbourne"
              ..points = 101
              ..hat = Hat.CHEF
        )
        ..add(
            ScoreBoardEntry()
              ..playerId = "Ozzy Osbourne"
              ..points = 101
              ..hat = Hat.OLD_DIVER
        )
        ..add(
            ScoreBoardEntry()
              ..playerId = "Ozzy Osbourne"
              ..points = 101
              ..hat = Hat.OLD_DIVER
        )
        ..add(
            ScoreBoardEntry()
              ..playerId = "Ozzy Osbourne"
              ..points = 101
              ..hat = Hat.VIKING
        )
        ..add(
            ScoreBoardEntry()
              ..playerId = "Ozzy Osbourne"
              ..points = 101
              ..hat = Hat.VIKING
        )
        ..add(
            ScoreBoardEntry()
              ..playerId = "Ozzy Osbourne"
              ..points = 101
              ..hat = Hat.VIKING
        )
        ..add(
            ScoreBoardEntry()
              ..playerId = "Ozzy Osbourne"
              ..points = 101
              ..hat = Hat.VIKING
        )
        ..add(
            ScoreBoardEntry()
              ..playerId = "Ozzy Osbourne"
              ..points = 101
              ..hat = Hat.VIKING
        )
        ..add(
            ScoreBoardEntry()
              ..playerId = "Ozzy Osbourne"
              ..points = 101
              ..hat = Hat.VIKING
        )
        ..add(
            ScoreBoardEntry()
              ..playerId = "Ozzy Osbourne"
              ..points = 101
              ..hat = Hat.VIKING
        )
        ..add(
            ScoreBoardEntry()
              ..playerId = "Ozzy Osbourne"
              ..points = 101
              ..hat = Hat.VIKING
        )
        ..add(
            ScoreBoardEntry()
              ..playerId = "Ozzy Osbourne"
              ..points = 101
              ..hat = Hat.VIKING
        );
  }
}

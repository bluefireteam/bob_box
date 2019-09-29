import "package:flutter/material.dart";
import "package:flame/flame.dart";

import "../ui/button.dart" as buttons;
import "../ui/background.dart";
import "../ui/label.dart";
import "../ui/title_header.dart";

import "./game/hats.dart";

import "../game_data.dart";
import "../scoreboard.dart";
import "../main.dart";

class ScoreboardScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final builder = FutureBuilder(
        future: Future.wait([
          ScoreBoard.fetchScoreboard(),
          GameData.playerId(),
        ]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting: {
              return Center(child: Label(label: "Loading results..."));
            }
            case ConnectionState.done: {
              if (snapshot.hasError) {
                return Center(child: Label(label: "Could not fetch scoreboard."));
              }
              final _entries = snapshot.data[0] as List<ScoreBoardEntry>;
              final _playerId = snapshot.data[1] as String;

              int i = 1;
              final _list = ListView(
                padding: const EdgeInsets.all(10),
                children: _entries == null
                ? []
                : _entries.map((entry) =>
                    Container(
                        child: Row(
                            children: [
                              SizedBox(width: 120, child:
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Flame.util.spriteAsWidget(Size(60, 40), HatSprite(entry.hat, image: Main.hatsWithBackground).hatSprite),
                                            Label(label: "#${i++} ", fontSize: 14),
                                          ],
                                      )
                              ),
                              Expanded(child: SizedBox(height: 40, child:
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Label(label: "${entry.playerId}", fontSize: 14),
                                            Label(label: "${entry.points}", fontSize: 14),
                                          ]
                                      )
                              )),
                            ]
                        )
                    )
                ).toList()
              );

              if (_playerId == null) {
                return Column(children: [
                  SizedBox(height: 50),
                  buttons.PrimaryButton(
                      label: "Join the scoreboard",
                      onPress: () {
                        Navigator.pushReplacementNamed(context, "/join-scoreboard");
                      }
                  ),
                  Expanded(child: _list)
                ]);
              } else {
                return _list;
              }
            }
          }
        }
    );

    return Scaffold(
        body: Background(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                      children: [
                        Positioned(
                            left: 5,
                            top: 0,
                            child: buttons.BackButton(onPress: () {
                              Navigator.pushNamed(context, "/");
                            }),
                        ),
                        Center(
                            child: TitleHeader("Scoreboard")
                        )
                      ],
                  ),
                  Expanded( child: builder)
                ]
            )
          )
      );
  }
}


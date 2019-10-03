import 'dart:ui';
import 'package:flutter/material.dart';

import "../ui/button.dart" as buttons;
import "../ui/background.dart";
import "../ui/label.dart";
import "../ui/title_header.dart";

import "../scoreboard.dart";
import "../game_data.dart";

class JoinScoreBoardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _JoinScoreBoardScreenState();
}

class _JoinScoreBoardScreenState extends State<JoinScoreBoardScreen> {
  static const fontColor = Color(0xFF38607c);

  final playerIdTextController = TextEditingController();

  String _status = "";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    playerIdTextController.dispose();
    super.dispose();
  }

  Future<bool> _checkPlayerIdAvailability() async {
    if (playerIdTextController.text.isEmpty) {
      setState(() {
        _status = "Player id cannot be empty";
      });

      return false;
    }

    setState(() {
      _status = "Checking...";
    });

    try {
      final isPlayerIdAvailable = await ScoreBoard.isPlayerIdAvailable(playerIdTextController.text);

      setState(() {
        _status = isPlayerIdAvailable
            ? "Player id available"
            : "Player id already in use";
      });

      return isPlayerIdAvailable;
    } catch(e) {
      setState(() {
        _status = "Error";
      });
    }

    return false;
  }

  void _join() async {
    final isPlayerIdAvailable = await _checkPlayerIdAvailability();

    if (isPlayerIdAvailable) {
      await GameData.setPlayerId(playerIdTextController.text);
      await ScoreBoard.submit();

      Navigator.pushReplacementNamed(context, "/scoreboard");
    }
  }

  Widget build(BuildContext context) {
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
                  Expanded(child:
                      Container(
                          padding: EdgeInsets.all(20),
                          child: Center(child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(children: [
                                Label(label: "Choose your player id"),
                                TextField(
                                    controller: playerIdTextController,
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: fontColor)
                                        ),
                                    ),
                                    style: TextStyle(
                                        fontFamily: "PixelIntv",
                                        color: fontColor
                                    ),
                                ),
                                SizedBox(height: 50),
                                Label(fontSize: 12, label: """By joining the scoreboard you agree that we collect your score, your selected hat and the choosen player id on the field above.

Those informations are only used for the display of the scoreboar.
                                    """),
                              ]),
                              Column(children: [
                                Label(label: _status),
                                buttons.SecondaryButton(
                                    label: "Check availability",
                                    onPress: () {
                                      _checkPlayerIdAvailability();
                                    }
                                ),
                                buttons.PrimaryButton(
                                    label: "Join",
                                    onPress: () {
                                      _join();
                                    }
                                ),
                              ]),
                          ])
                        )
                      ),
                  )
                ]
            )
          )
      );
  }
}

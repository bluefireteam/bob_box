import "package:flutter/material.dart";

import "../ui/button.dart" as buttons;
import "../ui/background.dart";
import "../ui/label.dart";
import "../ui/link.dart";
import "../ui/title_header.dart";

class CreditsScreen extends StatelessWidget {

  @override
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
                              Navigator.pop(context);
                            }),
                        ),
                        Center(
                            child: TitleHeader("Credits")
                        )
                      ],
                  ),
                  Center(
                      child: Column(
                          children: [
                            // Fireslime
                            SizedBox(height: 30),
                            Image(
                                image: AssetImage("assets/images/fire-slime.png"),
                                fit: BoxFit.fill,
                                width: 250,
                            ),
                            SizedBox(height: 10),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: Label(label: "Game developed by Fireslime", textAlign: TextAlign.justify),
                            ),
                            Link(link: "https://fireslime.xyz"),

                            // Fabri sounds
                            SizedBox(height: 30),
                            Image(
                                image: AssetImage("assets/images/fabrisounds-logo.png"),
                                fit: BoxFit.fill,
                                width: 250,
                            ),
                            SizedBox(height: 10),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: Label(label: "Music composed by Fabri Sounds", textAlign: TextAlign.justify),
                            ),
                            Link(link: "https://tiny.cc/fabri"),
                          ]
                      )
                  ),
                ]
            )
        )
    );
  }
}

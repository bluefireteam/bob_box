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
                            SizedBox(height: 100),
                            Image(
                                image: AssetImage("assets/images/fire-slime.png"),
                                fit: BoxFit.fill,
                                width: 300,
                            ),
                            SizedBox(height: 10),
                            Label(label: "Game developed by Fireslime"),
                            Link(link: "https://fireslime.xyz"),
                          ]
                      )
                  ),
                ]
            )
        )
    );
  }
}

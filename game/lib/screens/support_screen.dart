import "package:flutter/material.dart";
import "package:flame/flame.dart";
import "package:flame/position.dart";
import "package:flame/animation.dart" as FlameAnimation;

import "../ui/button.dart" as buttons;
import "../ui/background.dart";
import "../ui/label.dart";
import "../ui/link.dart";
import "../ui/title_header.dart";

class SupportScreen extends StatelessWidget {

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
                            child: TitleHeader("Support")
                        )
                      ],
                  ),
                  Expanded(child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                                children: <Widget>[
                                  SizedBox(height: 20),
                                  Flame.util.animationAsWidget(
                                      Position(240, 160),
                                      FlameAnimation.Animation.sequenced("buy-coffee.png", 4, textureWidth: 48)..stepTime = 0.2,
                                  ),
                                  Container(
                                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                      child: Label(label: "If you enjoy this game, you can support this and our others game development endeavours by buying us a coffee!", textAlign: TextAlign.justify),
                                  ),
                                ]
                            ),
                            buttons.PrimaryButton(
                                label: "Buy us a coffee!",
                                onPress: () {
                                }
                            ),
                          ]
                  )),
                ]
            )
        )
    );
  }
}

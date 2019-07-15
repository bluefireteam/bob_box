import "package:flutter/material.dart";
import "package:flame/flame.dart";

import "game/hats.dart";
import "../ui/background.dart";
import "../ui/label.dart";

class HatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Background(
            child: Column(
                children: [
                  SizedBox(height: 50),
                  Label(label: "Next hat price: 100"),
                  SizedBox(height: 25),
                  Expanded(child: GridView.count(
                      crossAxisCount: 3,
                      children: Hat.values.map((hatType) {
                        final hatSprite = HatSprite(hatType);

                        return  FutureBuilder(
                            future: hatSprite.load(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return  Column(
                                    children: [
                                        Flame.util.spriteAsWidget(const Size(100, 75), hatSprite.hatSprite),
                                        Label(label: hatSprite.label, fontSize: 14),
                                    ]
                                );
                              }

                              return Label(label: "Loading");
                            }
                        );
                      }).toList()
                  ))
                ]
            )
        )
      );
  }
}

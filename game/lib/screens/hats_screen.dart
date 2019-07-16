import "package:flutter/material.dart";
import "package:flame/flame.dart";
import "package:flame/game.dart";

import "game/hats.dart";
import "game/player.dart";

import "../game_data.dart";
import "../main.dart";

import "../ui/button.dart" as buttons;
import "../ui/background.dart";
import "../ui/label.dart";
import "../ui/title_header.dart";

class Preview extends BaseGame {
  Preview(Size size, Hat hat) {

    this.size = size;

    final player = Player(this, hat: hat);
    player.y = size.height - 50;

    add(player);
  }
}


class HatsScreen extends StatefulWidget {
  Hat current;
  List<Hat> owned;
  int currentCoins;

  Image hatsImage;

  HatsScreen({ this.current, this.owned, this.currentCoins, this.hatsImage });

  @override
  State<StatefulWidget> createState() => _HatsScreenState();
}

class _HatsScreenState extends State<HatsScreen> {
  Hat _current;
  Hat _selected;
  List<Hat> _owned;
  int _currentCoins;

  Hat get current => _current ?? widget.current;
  Hat get selected => _selected ?? widget.current;
  List<Hat> get owned => _owned ?? widget.owned;
  int get currentCoins => _currentCoins ?? widget.currentCoins;
  int get price => (owned.length * 50) + 10;

  void _equipHat() async {
    await GameData.setCurrentHat(selected);
    setState(() {
      _current = selected;
    });
  }

  void _buyHat() async {
    List<Hat> hats = List.from(owned);
    hats.add(selected);

    final newBalance = currentCoins - price;

    await GameData.setCurrentHat(selected);
    await GameData.setOwnedHats(hats);
    await GameData.updateCoins(newBalance);

    setState(() {
      _owned = hats;
      _currentCoins = newBalance;
      _current = _selected;
    });
  }

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
                              child: TitleHeader("Hats store")
                          )
                      ],
                  ),
                  Center(child: Label(label: "Current coins: $currentCoins")),
                  SizedBox(
                      height: 100,
                      width: 300,
                      child: Preview(const Size(300, 150), selected).widget,
                  ),

                  SizedBox(height: 50),

                  Center(child: selected == null
                    ? Label(label: "No hat selected")
                    : owned.contains(selected)
                      ? selected == current
                        ? Label(label: "In use")
                        : buttons.PrimaryButton(label: "Equip", onPress: () { _equipHat(); })
                      :  currentCoins >= price
                        ? buttons.PrimaryButton(label: "Buy", onPress: () { _buyHat(); })
                        : Label(label: "Not enough coins")
                  ),
                  SizedBox(height: 15),

                  Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 3,
                                  color: const Color(0xFF8bd0ba),
                              ),
                          )
                      ),
                      child: Center(child: Label(label: "Next hat price: $price")),
                  ),
                  Expanded(child:
                      Container(
                          decoration: const BoxDecoration(
                              color: const Color(0xFF578aae),
                              border: Border(
                                  top: BorderSide(
                                      width: 3,
                                      color: const Color(0xFF38607c),
                                  ),
                              )
                          ),
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: GridView.count(
                              crossAxisCount: 3,
                              children: Hat.values.map((hatType) {
                                final hatSprite = HatSprite(hatType, image: Main.hatsWithBackground);

                                return  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selected = hatType;
                                      });
                                    },
                                    child: Opacity(
                                               opacity: owned.contains(hatType) ? 1 : 0.4,
                                               child:Column(
                                                   children: [
                                                     SizedBox(
                                                         width: 96,
                                                         height: 64,
                                                         child: Flame.util.spriteAsWidget(const Size(96, 64), hatSprite.hatSprite)
                                                     ),
                                                     Label(label: hatSprite.label, fontSize: 14),
                                                   ]
                                               )
                                           )
                                );
                              }).toList()
                      )))
                ]
            )
        )
      );
  }
}

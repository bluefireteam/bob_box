import "package:flutter/material.dart";
import "package:flame/flame.dart";
import "package:flame/sprite.dart";
import "package:flame/game.dart";

import "game/hats.dart";
import "game/player.dart";
import "util.dart";

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

class _SpriteCustomPainter extends CustomPainter {
  final Sprite _sprite;
  final bool _owned;

  _SpriteCustomPainter(this._sprite, this._owned);


  Paint _paint() {
    if (_owned)
      return Paint();
    else
      return Paint()..colorFilter = ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.srcATop);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_sprite.loaded()) {
      _sprite.render(canvas, width: size.width, height: size.height, overridePaint: _paint());
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) => true;
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
  int get price => calcHatPrice(owned.length);

  void _equipHat() async {
    await GameData.setCurrentHat(selected);
    setState(() {
      _current = selected;
    });
  }

  void _unEquipHat() async {
    await GameData.setCurrentHat(null);
    setState(() {
      _current = null;
      _selected = null;
      widget.current = null;
    });
  }

  void _buyHat() async {
    List<Hat> hats = List.from(owned);
    hats.add(selected);

    final newBalance = currentCoins - price;

    await GameData.setCurrentHat(selected);
    await GameData.setOwnedHats(hats);
    await GameData.updateCoins(newBalance);

    Main.soundManager.playSfxs("Buy_Hat.wav");

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
                                Navigator.pushNamed(context, "/");
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

                  SizedBox(height: 80),

                  SizedBox(height: 50, child: Center(child: selected == null
                    ? Label(label: "No hat selected")
                    : owned.contains(selected)
                      ? selected == current
                        ? buttons.PrimaryButton(label: "Unequip", onPress: () { _unEquipHat(); })
                        : buttons.PrimaryButton(label: "Equip", onPress: () { _equipHat(); })
                      :  currentCoins >= price
                        ? buttons.PrimaryButton(label: "Buy", onPress: () { _buyHat(); })
                        : Label(label: "Not enough coins")
                  )),
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
                              color: const Color(0xFFf3e67d),
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
                                    child: Column(
                                        children: [
                                          SizedBox(
                                              width: 96,
                                              height: 64,
                                              child: CustomPaint(size: const Size(96, 64), painter: _SpriteCustomPainter(hatSprite.hatSprite, owned.contains(hatType))),
                                          ),
                                          Center(child: Label(label: hatSprite.label, fontSize: 13)),
                                        ]
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

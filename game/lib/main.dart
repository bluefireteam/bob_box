import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flame/flame.dart';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

import 'screens/game/game.dart';
import 'screens/game/hats.dart';
import 'screens/title_screen.dart';
import 'screens/hats_screen.dart';
import 'screens/credits_screen.dart';
import 'screens/support_screen.dart';

import 'ui/background.dart';
import 'ui/label.dart';
import 'ui/button.dart' as buttons;

import 'game_data.dart';
import 'sound_manager.dart';

class Main {
  static Game game;

  // Caching these images so we can use this right away on our UI
  static ui.Image hatsWithBackground;
  static ui.Image hats;
  static ui.Image bob;
  static ui.Image enemies;

  static SoundManager soundManager;
}

class GameWidget extends StatefulWidget {
  @override
  _GameWidgetState createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> with WidgetsBindingObserver {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => FutureBuilder(
              future: Future.wait([
                GameData.getScore(),
                GameData.getCoins(),
              ]),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  int initialBestScore = snapshot.data[0];
                  int initialCoins = snapshot.data[1];

                  return Scaffold(body: TitleScreen(initialBestScore: initialBestScore, initialCoins: initialCoins));
                }

                return Background();
              }
          ),
          '/hats': (context) => FutureBuilder(
              future: Future.wait([
                GameData.getCurrentHat(),
                GameData.getOwnedHats(),
                GameData.getCoins()
              ]),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Hat currentHat = snapshot.data[0];
                  List<Hat> ownedHats = snapshot.data[1];
                  int currentCoins = snapshot.data[2];

                  return HatsScreen(current: currentHat, owned: ownedHats, currentCoins: currentCoins);
                }

                return Background();
              }

          ),
          '/credits': (context) => CreditsScreen(),
          '/support': (context) => FutureBuilder(
              future: Future.wait([
                FlutterInappPurchase.getProducts(
                    Platform.isAndroid ? ['support_coffee'] : ['xyz.fireslime.bob_box.support_coffee']
                ),
                FlutterInappPurchase.getPurchaseHistory(),
              ]),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Scaffold(body: Background(child:
                        Center(child:
                            Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Label(label: "Error fetching info :("),
                                  buttons.BackButton(onPress: () {
                                    Navigator.pushNamed(context, "/");
                                  })
                                ],
                            )
                        )
                    ));
                  } else {
                    IAPItem item = snapshot.data[0];
                    bool boughtAlready = (snapshot.data[1] as List<PurchasedItem>).length > 0;

                    return SupportScreen(purchaseItem: item, boughtAlready: boughtAlready);
                  }
                }
                return Background();
              }
          ),
        });
  }

  void _asyncInit() async {
    await FlutterInappPurchase.initConnection;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _asyncInit();
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();

    await FlutterInappPurchase.endConnection;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      Main.soundManager.pauseBackgroundMusic();
    }

    if (state == AppLifecycleState.resumed) {
      Main.soundManager.resumeBackgroundMusic();
    }
  }

}

void main() async {

  Main.soundManager = SoundManager();

  bool soundsEnabled = await GameData.isSoundsEnabled();
  await Main.soundManager.init(soundsEnabled);

  // Hats images cache
  Main.hatsWithBackground = await Flame.images.load("hats-background.png");
  Main.hats = await Flame.images.load("hats.png");

  Main.bob = await Flame.images.load("bob.png");
  Main.enemies = await Flame.images.load("enemies.png");

  await Flame.init(fullScreen: true, orientation: DeviceOrientation.portraitUp);

  runApp(GameWidget());

  Main.soundManager.playMenu();

  Flame.util.addGestureRecognizer(TapGestureRecognizer()
    ..onTapDown = (TapDownDetails evt) {
      if (Main.game != null) {
        Main.game.player.stop();
      }
    }
    ..onTapUp = (TapUpDetails evt) {
      if (Main.game != null) {
        Main.game.player.resume();
        Main.game.controller.onTapUp(evt);
      }
    }
  );

  Flame.util.addGestureRecognizer(ImmediateMultiDragGestureRecognizer()
      ..onStart = (Offset) {
        if (Main.game != null) {
          Main.game.player.resume();
        }
        return null;
      }
  );
}

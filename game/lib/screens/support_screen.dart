import "package:flutter/material.dart";
import "package:flame/flame.dart";
import "package:flame/position.dart";
import "package:flame/animation.dart" as FlameAnimation;

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

import "../ui/button.dart" as buttons;
import "../ui/background.dart";
import "../ui/label.dart";
import "../ui/link.dart";
import "../ui/title_header.dart";

class SupportScreen extends StatefulWidget {
  IAPItem purchaseItem;
  bool boughtAlready;

  SupportScreen({ this.purchaseItem, this.boughtAlready });

  @override
  State<StatefulWidget> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {

  bool _boughtAlready;

  get boughtAlready => _boughtAlready ?? widget.boughtAlready;

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
                                  !boughtAlready
                                    ? Column(children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                            child: Label(label: "You can support our game development endeavours by buying us a coffee!", textAlign: TextAlign.justify),
                                        ),
                                        Container(
                                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                            child: Label(label: "And as a Thanks You you will have increased chances of coins spawning in the game!", textAlign: TextAlign.justify),
                                        )
                                      ])
                                    : Container(
                                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                        child: Label(label: "Thanks a lot for your support!", textAlign: TextAlign.justify),
                                    ),
                                ]
                            ),
                            !boughtAlready
                                ?  buttons.PrimaryButton(
                                    label: "Buy us a coffee!",
                                    onPress: () async {
                                      try {
                                        print("Product id");
                                        print("- ${widget.purchaseItem.productId}");
                                        await FlutterInappPurchase.buyProduct(widget.purchaseItem.productId);
                                        setState(() {
                                          _boughtAlready = true;
                                        });
                                      } catch (error) {
                                        print("$error");
                                      }
                                    }
                                ) : Text("")
                          ]
                  )),
                ]
            )
        )
    );
  }
}

import "package:flutter/material.dart";

class Label extends StatelessWidget {

  final String label;
  final double fontSize;
  final Color fontColor;

  Label({ this.label, this.fontSize = 20, this.fontColor = const Color(0xFF38607c)});

  Widget build(BuildContext context) {
    return Text(
        label,
        style: TextStyle(
            fontSize: fontSize,
            fontFamily: "PixelIntv",
            color: fontColor,
        )
    );
  }
}

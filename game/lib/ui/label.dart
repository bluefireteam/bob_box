import "package:flutter/material.dart";

class Label extends StatelessWidget {

  final String label;
  final double fontSize;
  final Color fontColor;
  final TextAlign textAlign;

  Label({
    this.label,
    this.fontSize = 20,
    this.fontColor = const Color(0xFF38607c),
    this.textAlign = TextAlign.left,
  });

  Widget build(BuildContext context) {
    return Text(
        label,
        textAlign: textAlign,
        style: TextStyle(
            fontSize: fontSize,
            fontFamily: "PixelIntv",
            color: fontColor,
        )
    );
  }
}

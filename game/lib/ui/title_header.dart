import "package:flutter/material.dart";

class TitleHeader extends StatelessWidget {

  final String title;
  final double fontSize;

  TitleHeader(this.title, { this.fontSize = 34 });

  Widget build(BuildContext context) {
    return Text(
        title,
        style: TextStyle(
            fontSize: fontSize,
            fontFamily: "PixelIntv",
            color: Color(0xFF55a894)
        )
    );
  }
}

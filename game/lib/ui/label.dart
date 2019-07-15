import "package:flutter/material.dart";

class Label extends StatelessWidget {

  final String label;
  final double fontSize;

  Label({ this.label, this.fontSize = 20 });

  Widget build(BuildContext context) {
    return Text(
        label,
        style: TextStyle(
            fontSize: fontSize,
            fontFamily: "PixelIntv",
            color: Color(0xFF38607c)
        )
    );
  }
}

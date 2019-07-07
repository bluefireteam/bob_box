import "package:flutter/material.dart";

class Label extends StatelessWidget {

  final String label;

  Label({ this.label });

  Widget build(BuildContext context) {
    return Text(
        label,
        style: TextStyle(
            fontSize: 20,
            fontFamily: "PixelIntv",
            color: Color(0xFF38607c)
        )
    );
  }
}

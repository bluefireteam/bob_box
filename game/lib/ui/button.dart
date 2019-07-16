import "package:flutter/material.dart";

typedef OnPress = void Function();

class Button extends StatelessWidget {

  final String label;
  final OnPress onPress;

  final Color backgroundColor;
  final Color fontColor;
  final double fontSize;
  final double minWidth;

  Button({ this.label, this.onPress, this.backgroundColor, this.fontColor, this.fontSize = 20, this.minWidth = 250 });

  Widget build(BuildContext context) {
    return ButtonTheme(minWidth: minWidth, child: RaisedButton(
      onPressed: () {
        onPress();
      },
      color: backgroundColor,
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: "PixelIntv",
          color: fontColor
        )
      ),
    ));
  }
}

class PrimaryButton extends Button {
  PrimaryButton({ String label, OnPress onPress }): super(
    label: label,
    onPress: onPress,
    backgroundColor: Color(0xFF38607c),
    fontColor: Color(0xFF8bd0ba),
  );
}

class SecondaryButton extends Button {
  SecondaryButton({ String label, OnPress onPress }): super(
    label: label,
    onPress: onPress,
    backgroundColor: Color(0xFF8bd0ba),
    fontColor: Color(0xFF38607c),
  );
}

class BackButton extends Button {
  BackButton({ OnPress onPress }): super(
    label: "<",
    onPress: onPress,
    backgroundColor: Color(0xFF8bd0ba),
    fontColor: Color(0xFF38607c),
    fontSize: 30,
    minWidth: 40,
  );
}

import "package:flutter/material.dart";

typedef OnPress = void Function();

class Button extends StatelessWidget {

  final String label;
  OnPress onPress;

  Color backgroundColor;
  Color fontColor;

  Button({ this.label, this.onPress, this.backgroundColor, this.fontColor });

  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        onPress();
      },
      color: backgroundColor,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 20,
          fontFamily: "PixelIntv",
          color: fontColor
        )
      ),
    );
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

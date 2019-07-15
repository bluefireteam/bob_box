import "package:flutter/material.dart";

class Background extends StatelessWidget {
  final Widget child;

  Background({ this.child });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xFFfff8c0)),
      child: child
    );
  }
}

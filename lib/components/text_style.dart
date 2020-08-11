import 'package:flutter/material.dart';

class BoldText extends StatelessWidget {
  final double size;
  final String text;
  final Color color;

  BoldText({
    this.text,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        color: color,
        fontSize: size,
      ),
    );
  }
}

class NormalText extends StatelessWidget {
  final double size;
  final String text;
  final Color color;
  final TextOverflow overflow;

  NormalText({
    this.text,
    this.color,
    this.size,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      style: TextStyle(
        fontFamily: "nunito",
        fontWeight: FontWeight.w300,
        color: color,
        fontSize: size,
      ),
    );
  }
}

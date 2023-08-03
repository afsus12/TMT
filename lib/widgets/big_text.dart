import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BigText extends StatelessWidget {
  final Color? color;
  final TextAlign? textAlign;
  final String text;
  final double size;
  final TextOverflow overflow;
  const BigText(
      {Key? key,
      this.color = const Color(0xffFCFCFC),
      this.textAlign = TextAlign.left,
      required this.text,
      this.overflow = TextOverflow.ellipsis,
      this.size = 24})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      style: TextStyle(
        fontSize: size,
        color: color,
        fontFamily: "aileron",
        fontWeight: FontWeight.bold,
        height: 1,
      ),
    );
  }
}

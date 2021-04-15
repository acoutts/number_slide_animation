import 'package:flutter/material.dart';

import 'src/../number_col.dart';

class NumberSlideAnimation extends StatefulWidget {
  NumberSlideAnimation({
    required this.number,
    this.textStyle = const TextStyle(fontSize: 16.0),
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeIn,
  });

  /// The number that should be displayed
  ///
  /// It should fit following constraints:
  ///
  /// number != null
  /// number should contain ONLY of numeric values
  final String number;

  /// The TextStyle of each number tile
  ///
  /// defaults to: TextStyle(fontSize: 16.0)
  final TextStyle textStyle;

  /// The duration of the whole animation
  ///
  /// defaults to: const Duration(milliseconds: 1500)
  final Duration duration;

  /// The Curve in which the animation is displayed
  ///
  /// defaults to: Curves.easeIn
  final Curve curve;

  @override
  _NumberSlideAnimationState createState() => _NumberSlideAnimationState();
}

class _NumberSlideAnimationState extends State<NumberSlideAnimation> {
  @override
  void didUpdateWidget(oldWidget) {
    final increased =
        double.parse(widget.number) > double.parse(oldWidget.number);
    colorTween = ColorTween(
      begin: widget.textStyle.color,
      end: increased ? widget.increaseColor : widget.decreaseColor,
    );

    colorAnimation = colorTween.animate(animationController)
      ..addListener(() {
        print('animating');
        setState(() {});
      });

    animationController.reset();
    animationController.forward();

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...widget.number.characters.map((e) {
          final isDigit = RegExp(r'\d').hasMatch(e);

          /// If it's not a digit then just return a text widget
          /// to dispaly that character.
          if (!isDigit) {
            return Text(
              e,
              style: widget.textStyle,
            );
          }

          return NumberCol(
            number: int.parse(e),
            textStyle: widget.textStyle,
            duration: widget.duration,
            curve: widget.curve,
            increaseColor: Color(0xFF28AFB0),
            decreaseColor: Color(0xFFDF9097),
          );
        }).toList(),
      ],
    );
  }
}

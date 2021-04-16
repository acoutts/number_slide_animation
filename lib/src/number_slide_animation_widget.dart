import 'package:flutter/material.dart';
import 'package:number_slide_animation/src/last_change.dart';

import 'src/../number_col.dart';

/// For color change we need to check here when the number changes.
/// If it increases then the next change to the NumberCol widgets should
/// first animate green, then animate back to the normal color.
/// Same for decrease but with red.
class NumberSlideAnimation extends StatefulWidget {
  NumberSlideAnimation({
    required this.number,
    required this.parseNumber,
    required this.textStyle,
    required this.increaseColor,
    required this.decreaseColor,
    this.numberDuration = const Duration(milliseconds: 500),
    this.numberCurve = Curves.easeIn,
    this.colorCurve = Curves.easeOut,
    this.colorDuration = const Duration(milliseconds: 500),
  });

  /// Function used to parse the number into a double. This is
  /// used to compare if the number increases or decreases on
  /// each change. Useful if you are displaying a currency value
  /// and need a special funciton to parse that currency into its
  /// numeric representation.
  final double Function(String) parseNumber;

  /// The numeric value that should be displayed, formatted as a string.
  /// This could be a currency like `$32.00` or just a number `5.00`.
  final String number;

  /// The TextStyle to use.
  final TextStyle textStyle;

  /// Duration of number change animation.
  final Duration numberDuration;

  /// Curve for number change animation.
  final Curve numberCurve;

  /// Duration of color change animation.
  final Duration colorDuration;

  /// Curve for color change animation.
  final Curve colorCurve;

  /// Colors for number increase/decrease
  final Color increaseColor;
  final Color decreaseColor;

  @override
  _NumberSlideAnimationState createState() => _NumberSlideAnimationState();
}

class _NumberSlideAnimationState extends State<NumberSlideAnimation> {
  var latestChange = NumberChange.noChange;

  @override
  void didUpdateWidget(oldWidget) {
    final parsedNewValue = widget.parseNumber(widget.number);
    final parsedOldValue = oldWidget.parseNumber(oldWidget.number);

    setState(
      () => latestChange = parsedNewValue > parsedOldValue
          ? NumberChange.increase
          : parsedNewValue < parsedOldValue
              ? NumberChange.decrease
              : NumberChange.noChange,
    );

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
            colorCurve: widget.colorCurve,
            colorDuration: widget.colorDuration,
            number: int.parse(e),
            textStyle: widget.textStyle,
            numberDuration: widget.numberDuration,
            numberCurve: widget.numberCurve,
            increaseColor: widget.increaseColor,
            decreaseColor: widget.decreaseColor,
            latestChange: latestChange,
          );
        }).toList(),
      ],
    );
  }
}

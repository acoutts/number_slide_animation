import 'package:flutter/material.dart';
import 'package:number_slide_animation/src/last_change.dart';

/// Each [NumberCol] has the numbers 0-9 stacked inside of a [SingleChildScrollView]
/// via a [ScrollController] the position will be animated to the requested number
class NumberCol extends StatefulWidget {
  /// The numeric value that should be displayed, formatted as a string.
  /// This could be a currency like `$32.00` or just a number `5.00`.
  final int number;

  /// The TextStyle to use.
  final TextStyle textStyle;

  /// Duration of number change animation.
  final Duration numberDuration;

  /// Curve for number change animation.
  final Curve numberCurve;

  /// Whether the value has increased, decreased, or is no change
  final NumberChange latestChange;

  /// Duration of color change animation.
  final Duration colorDuration;

  /// Curve for color change animation.
  final Curve colorCurve;

  /// Colors for number increase/decrease
  final Color increaseColor;
  final Color decreaseColor;

  NumberCol({
    required this.number,
    required this.textStyle,
    required this.numberDuration,
    required this.numberCurve,
    required this.latestChange,
    required this.increaseColor,
    required this.decreaseColor,
    required this.colorCurve,
    required this.colorDuration,
  });

  @override
  _NumberColState createState() => _NumberColState();
}

class _NumberColState extends State<NumberCol>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  late final AnimationController colorAnimationController;
  late ColorTween colorTween;
  late Animation colorAnimation;

  var _elementSize = 0.0;
  var textColor = Colors.transparent;

  @override
  void initState() {
    super.initState();

    colorAnimationController = AnimationController(
      vsync: this,
      duration: widget.colorDuration,
    );

    colorTween = ColorTween(
      begin: widget.textStyle.color,
      end: widget.latestChange == NumberChange.increase
          ? widget.increaseColor
          : widget.latestChange == NumberChange.decrease
              ? widget.decreaseColor
              : widget.textStyle.color,
    );

    colorAnimation = colorTween.animate(CurvedAnimation(
      parent: colorAnimationController,
      curve: widget.colorCurve,
    ))
      ..addListener(() {
        setState(() {});
      });

    colorAnimationController.forward().whenComplete(() {
      colorAnimationController.reverse();
    });

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _elementSize = _scrollController.position.maxScrollExtent / 10;
      setState(() {});

      _scrollController.animateTo(
        _elementSize * widget.number,
        duration: widget.numberDuration,
        curve: widget.numberCurve,
      );
    });
  }

  @override
  void dispose() {
    colorAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    _scrollController.animateTo(
      _elementSize * widget.number,
      duration: widget.numberDuration,
      curve: widget.numberCurve,
    );

    if (widget.number != oldWidget.number &&
        widget.latestChange != NumberChange.noChange) {
      colorTween = ColorTween(
        begin: widget.textStyle.color,
        end: widget.latestChange == NumberChange.increase
            ? widget.increaseColor
            : widget.latestChange == NumberChange.decrease
                ? widget.decreaseColor
                : widget.textStyle.color,
      );

      colorAnimation = colorTween.animate(CurvedAnimation(
          parent: colorAnimationController, curve: widget.numberCurve))
        ..addListener(() {
          setState(() {});
        });

      colorAnimationController.forward().whenComplete(() {
        colorAnimationController.reverse();
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: _elementSize),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: List.generate(10, (position) {
              return Text(
                position.toString(),
                style: widget.textStyle.copyWith(
                  color: colorAnimation.value,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

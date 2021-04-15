import 'package:flutter/material.dart';

/// Each [NumberCol] has the numbers 0-9 stacked inside of a [SingleChildScrollView]
/// via a [ScrollController] the position will be animated to the requested number
class NumberCol extends StatefulWidget {
  /// The number the col should animate to
  final int number;

  /// The [TextStyle] of the number
  final TextStyle textStyle;

  /// The [Duration] the animation will take to slide the number into place
  final Duration duration;

  /// The curve that is used during the animation
  final Curve curve;

  NumberCol({
    required this.number,
    required this.textStyle,
    required this.duration,
    required this.curve,
  }) : assert(number >= 0 && number < 10);

  @override
  _NumberColState createState() => _NumberColState();
}

class _NumberColState extends State<NumberCol>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  late final AnimationController animationController;
  late ColorTween colorTween;
  late Animation colorAnimation;

  var _elementSize = 0.0;
  var textColor = Colors.transparent;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );

    colorTween = ColorTween(
      begin: widget.textStyle.color,
      end: widget.textStyle.color,
    );

    colorAnimation = colorTween.animate(animationController)
      ..addListener(() {
        print('animating');
        setState(() {});
      });

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _elementSize = _scrollController.position.maxScrollExtent / 10;
      setState(() {});

      _scrollController.animateTo(_elementSize * widget.number,
          duration: widget.duration, curve: widget.curve);
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    _scrollController.animateTo(_elementSize * widget.number,
        duration: widget.duration, curve: widget.curve);

    final increased = widget.number > oldWidget.number;
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

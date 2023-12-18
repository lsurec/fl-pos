import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CountdownCircleWidget extends StatefulWidget {
  const CountdownCircleWidget({
    super.key,
    required this.duration,
    required this.onAnimationEnd,
  });

  final int duration;
  final VoidCallback onAnimationEnd;

  @override
  State<CountdownCircleWidget> createState() => _CountdownCircleWidgetState();
}

class _CountdownCircleWidgetState extends State<CountdownCircleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    )..addListener(() {
        setState(() {});
      });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationEnd();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 15.0,
      lineWidth: 2.0,
      percent: 1.0 - (_controller.value),
      center: Text(
        '${widget.duration - (_controller.value * widget.duration).floor()}',
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      progressColor: Colors.white,
    );
  }
}

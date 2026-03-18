import 'package:flutter/material.dart';

class Bounce extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Function() onPressed;
  final bool isDisable;

  const Bounce({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 100),
    required this.onPressed,
    this.isDisable = false,
  });

  @override
  State<Bounce> createState() => _BounceState();
}

class _BounceState extends State<Bounce> with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: widget.duration,
        lowerBound: 0.0,
        upperBound: 0.1)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isDisable ? null : widget.onPressed,
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isDisable) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (!widget.isDisable) {
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    if (!widget.isDisable) {
      _controller.reverse();
    }
  }
}

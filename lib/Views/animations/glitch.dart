import 'dart:math';
import 'package:flutter/material.dart';

class GlitchText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const GlitchText({
    required this.text,
    required this.style,
  });

  @override
  _GlitchTextState createState() => _GlitchTextState();
}

class _GlitchTextState extends State<GlitchText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100), // Faster flickers
    )..repeat(reverse: false); // No reverse for a more chaotic glitch
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Glitchy Red Layer
            Transform.translate(
              offset: Offset(_random.nextDouble() * 8 - 4, _random.nextDouble() * 4 - 2),
              child: Opacity(
                opacity: _random.nextBool() ? 0.7 : 0.3, // Random opacity
                child: Text(
                  widget.text,
                  style: widget.style.copyWith(color: Colors.red.withOpacity(0.7)),
                ),
              ),
            ),
            // Glitchy Blue Layer
            Transform.translate(
              offset: Offset(_random.nextDouble() * 10 - 5, _random.nextDouble() * 6 - 3),
              child: Opacity(
                opacity: _random.nextBool() ? 0.7 : 0.4, // Random opacity
                child: Text(
                  widget.text,
                  style: widget.style.copyWith(color: Colors.blue.withOpacity(0.7)),
                ),
              ),
            ),
            // Main Text
            Text(
              widget.text,
              style: widget.style,
            ),
            // Horizontal Distortion Layer
            if (_random.nextBool()) // Randomly add a distortion slice
              Positioned(
                top: _random.nextDouble() * 20,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white.withOpacity(0.2),
                  height: 2,
                  width: double.infinity,
                ),
              ),
            // Random jitter layer
            Transform.translate(
              offset: Offset(_random.nextDouble() * 2 - 1, _random.nextDouble() * 2 - 1),
              child: Opacity(
                opacity: _random.nextBool() ? 0.8 : 0.2,
                child: Text(
                  widget.text,
                  style: widget.style.copyWith(color: Colors.green.withOpacity(0.6)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

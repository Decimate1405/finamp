import 'package:flutter/material.dart';

class ScrollingText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final double blankSpace;
  final double velocity;
  final Duration pauseDuration;

  const ScrollingText({
    Key? key,
    required this.text,
    this.style,
    this.blankSpace = 20.0,
    this.velocity = 25.0,
    this.pauseDuration = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  _ScrollingTextState createState() => _ScrollingTextState();
}

class _ScrollingTextState extends State<ScrollingText>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late double _textWidth;
  late double _containerWidth;
  late double _animationDistance;
  final Duration extraScrollDuration = Duration(milliseconds: 900);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScrolling();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _startScrolling() {
    if (!_scrollController.hasClients) return;

    _scrollController.jumpTo(0.0);
    final totalDistance = _animationDistance +
        (widget.velocity * extraScrollDuration.inMilliseconds / 1000);
    final totalDuration = Duration(
        milliseconds: (totalDistance / widget.velocity * 1000).toInt());

    Future.delayed(widget.pauseDuration, () {
      if (!_scrollController.hasClients) return;
      _scrollController
          .animateTo(
        totalDistance,
        duration: totalDuration,
        curve: Curves.linear,
      )
          .then((_) {
        if (!_scrollController.hasClients) return;
        _startScrolling();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: widget.text,
            style: widget.style,
          ),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: double.infinity);

        _textWidth = textPainter.width;
        _containerWidth = constraints.maxWidth;
        _animationDistance = _textWidth + widget.blankSpace;

        if (_textWidth <= _containerWidth) {
          return Text(widget.text, style: widget.style);
        }

        return SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            children: [
              Text(widget.text, style: widget.style),
              SizedBox(width: widget.blankSpace),
              Text(widget.text, style: widget.style),
            ],
          ),
        );
      },
    );
  }
}

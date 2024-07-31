import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadMoreText extends StatefulWidget {
  const ReadMoreText(
    this.text, {
    super.key,
    this.style,
    this.maxLines = 3,
    this.shouldToggle = true,
    this.onTap,
    this.readMoreStyle,
  }) : assert(
          !shouldToggle || onTap == null,
          'Please set either shouldToggle to true or provide an onTap function, but not both.',
        );

  final String text;
  final int maxLines;
  final TextStyle? style;
  final TextStyle? readMoreStyle;
  final bool shouldToggle;
  final VoidCallback? onTap;

  @override
  State<ReadMoreText> createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final span = TextSpan(text: widget.text, style: widget.style);
    final tp = TextPainter(
      text: span,
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    );

    tp.layout(maxWidth: MediaQuery.of(context).size.width);

    final exceedsMaxLines = tp.didExceedMaxLines;

    return Text.rich(
      TextSpan(
        text: _isExpanded ? widget.text : _getTruncatedText(tp),
        style: widget.style,
        children: [
          if (exceedsMaxLines) ...[
            const TextSpan(text: ' '),
            TextSpan(
              text: _isExpanded ? 'less' : 'more',
              style: widget.readMoreStyle ??
                  TextStyle(
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: context.textTheme.titleLarge?.color,
                  ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  if (widget.onTap != null) {
                    widget.onTap!();
                  } else {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  }
                },
            ),
          ],
        ],
      ),
    );
  }

  String _getTruncatedText(TextPainter tp) {
    final text = widget.text;
    var endIndex =
        tp.getPositionForOffset(Offset(tp.size.width, tp.height)).offset;

    if (endIndex == text.length) return text;

    return '${text.substring(0, endIndex)}...';
  }
}

import 'package:flutter/material.dart';

class MultipleValueLinearProgressIndicatorValue {
  final double value;
  final Color color;

  MultipleValueLinearProgressIndicatorValue(this.value, this.color);
}

class MultipleValueLinearProgressIndicator extends StatelessWidget {
  final double height;
  final Color? backgroundColor;
  final Color? defaultValueColor;
  final List<MultipleValueLinearProgressIndicatorValue> values;

  const MultipleValueLinearProgressIndicator({
    Key? key,
    required this.values,
    this.height = 4.0,
    this.backgroundColor,
    this.defaultValueColor,
  })  : assert(height >= 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
      ),
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: height,
      ),
      child: CustomPaint(
        painter: _MultipleValueLinearProgressIndicatorPainter(
          backgroundColor: backgroundColor ?? Theme.of(context).dividerColor,
          textDirection: Directionality.of(context),
          defaultValueColor: defaultValueColor ?? Theme.of(context).primaryColor,
          values: values,
        ),
      ),
    );
  }
}

class _MultipleValueLinearProgressIndicatorPainter extends CustomPainter {
  final Color backgroundColor;
  final Color defaultValueColor;
  final List<MultipleValueLinearProgressIndicatorValue> values;
  final TextDirection textDirection;

  const _MultipleValueLinearProgressIndicatorPainter({
    required this.backgroundColor,
    required this.defaultValueColor,
    required this.textDirection,
    required this.values,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, paint);

    paint.color = defaultValueColor;

    if (values.isEmpty) return;

    var containsNegativeValue = false;
    var total = 0.0;

    for (var element in values) {
      if (element.value < 0) {
        containsNegativeValue = true;
        break;
      }
      total += element.value;
    }

    if (containsNegativeValue || total <= 0) return;

    var currentPositionX = 0.0;
    for (var element in values) {
      final barWidth = (element.value / total).clamp(0.0, 1.0) * size.width;
      paint.color = element.color;

      if (barWidth <= 0.0) return;

      final left = textDirection == TextDirection.rtl ? size.width - barWidth - currentPositionX : currentPositionX;
      canvas.drawRect(Offset(left, 0.0) & Size(barWidth, size.height), paint);

      currentPositionX += barWidth;
    }
  }

  @override
  bool shouldRepaint(_MultipleValueLinearProgressIndicatorPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.defaultValueColor != defaultValueColor ||
        oldPainter.values != values ||
        oldPainter.textDirection != textDirection;
  }
}

class SingleValueLinearProgressIndicator extends StatelessWidget {
  final double height;
  final Color? backgroundColor;
  final Color? valueColor;
  final double value;

  const SingleValueLinearProgressIndicator({
    Key? key,
    this.height = 4.0,
    required this.value,
    this.backgroundColor,
    this.valueColor,
  })  : assert(value >= 0 && value <= 1),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var _percent = value.clamp(0.0, 1.0);
    return MultipleValueLinearProgressIndicator(
      height: height,
      backgroundColor: backgroundColor,
      defaultValueColor: valueColor ?? Theme.of(context).primaryColor,
      values: [
        MultipleValueLinearProgressIndicatorValue(_percent, valueColor ?? Theme.of(context).primaryColor),
        MultipleValueLinearProgressIndicatorValue(1.0 - _percent, backgroundColor ?? Theme.of(context).dividerColor),
      ],
    );
  }
}

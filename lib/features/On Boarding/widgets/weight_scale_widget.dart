import 'package:flutter/material.dart';

class WeightScaleWidget extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double initialValue;
  final Function(double) onValueChanged;
  final Color backgroundColor;
  final Color markerColor;
  final Color textColor;
  final bool showDecimal;
  final int decimalPlaces;

  const WeightScaleWidget({
    Key? key,
    this.minValue = 1.0,
    this.maxValue = 1000.0,
    required this.initialValue,
    required this.onValueChanged,
    this.backgroundColor = Colors.transparent,
    this.markerColor = Colors.white,
    this.textColor = Colors.white,
    this.showDecimal = true,
    this.decimalPlaces = 1,
  }) : super(key: key);

  @override
  State<WeightScaleWidget> createState() => _WeightScaleWidgetState();
}

class _WeightScaleWidgetState extends State<WeightScaleWidget> {
  late double _currentValue;
  late ScrollController _scrollController;
  final double _itemExtent = 15.0; // Width of each marker
  final int _divisionsPerUnit = 5; // Small markers between numbers

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;

    // Calculate initial scroll position to show the initial value
    final initialScrollOffset =
        ((_currentValue - widget.minValue) * _divisionsPerUnit * _itemExtent);

    _scrollController =
        ScrollController(initialScrollOffset: initialScrollOffset);

    // Listen to scroll changes to update the current value
    _scrollController.addListener(_updateCurrentValue);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateCurrentValue);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateCurrentValue() {
    final scrollPosition = _scrollController.offset;
    final newValue =
        widget.minValue + (scrollPosition / (_divisionsPerUnit * _itemExtent));

    // Round to the nearest division based on decimal places
    final multiplier = pow(10, widget.decimalPlaces);
    final roundedValue = (newValue * multiplier).round() / multiplier;

    if (roundedValue != _currentValue &&
        roundedValue >= widget.minValue &&
        roundedValue <= widget.maxValue) {
      setState(() {
        _currentValue = roundedValue;
      });
      widget.onValueChanged(_currentValue);
    }
  }

  // Helper method to format the display value
  String _formatValue(double value) {
    if (widget.showDecimal) {
      return value.toStringAsFixed(widget.decimalPlaces);
    } else {
      return value.round().toString();
    }
  }

  // Helper method to calculate spacing of number labels
  int _getLabelInterval() {
    final totalRange = widget.maxValue - widget.minValue;
    if (totalRange > 500) return 100;
    if (totalRange > 200) return 50;
    if (totalRange > 100) return 20;
    if (totalRange > 50) return 10;
    if (totalRange > 20) return 5;
    return 1;
  }

  double pow(double x, int exponent) {
    double result = 1.0;
    for (int i = 0; i < exponent; i++) {
      result *= x;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final totalUnits = widget.maxValue - widget.minValue;
    final totalItems = (totalUnits * _divisionsPerUnit).round() + 1;
    final labelInterval = _getLabelInterval();

    return Column(
      children: [
        Container(
          height: 100,
          color: widget.backgroundColor,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // The scrollable scale
              ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: totalItems,
                itemExtent: _itemExtent,
                itemBuilder: (context, index) {
                  final value = widget.minValue + (index / _divisionsPerUnit);
                  final isFullUnit = index % _divisionsPerUnit == 0;
                  final shouldShowLabel =
                      isFullUnit && (value.toInt() % labelInterval == 0);

                  return Center(
                    child: Container(
                      height: isFullUnit ? 50 : 30,
                      width: 2,
                      color: widget.markerColor,
                    ),
                  );
                },
              ),

              // Center indicator line
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 80,
                  width: 4,
                  color: widget.markerColor,
                ),
              ),
            ],
          ),
        ),

        // Display current value below the scale
        // Container(
        //   padding: const EdgeInsets.symmetric(vertical: 8),
        //   color: widget.backgroundColor,
        //   child: Text(
        //     "Selected: ${_formatValue(_currentValue)} kg",
        //     style: TextStyle(
        //       color: widget.textColor,
        //       fontSize: 16,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

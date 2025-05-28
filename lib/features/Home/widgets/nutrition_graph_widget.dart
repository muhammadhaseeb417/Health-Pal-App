import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:health_pal/utils/constants/colors.dart';

class NutritionGraph extends StatelessWidget {
  final double proteins;
  final double carbs;
  final double fats;
  final double proteinTarget;
  final double carbsTarget;
  final double fatsTarget;

  const NutritionGraph({
    Key? key,
    this.proteins = 0.0,
    this.carbs = 0.0,
    this.fats = 0.0,
    this.proteinTarget = 90.0,
    this.carbsTarget = 110.0,
    this.fatsTarget = 70.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: AspectRatio(
          aspectRatio: 1.3,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true, drawVerticalLine: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 45, // Space for full numbers
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(right: 5.0), // Adjust spacing
                        child: Text(
                          value.toInt().toString(), // Show full number
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40, // Increased spacing below tiles
                    getTitlesWidget: (value, meta) {
                      List<String> days = ["S", "M", "T", "W", "T", "F", "S"];
                      int selectedIndex = 3; // Selected day

                      bool isSelected = value.toInt() == selectedIndex;

                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0), // Add spacing below bottom titles
                        child: Container(
                          width: 30,
                          decoration: isSelected
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(1000),
                                  color: CustomColors.orangeColor,
                                )
                              : null, // No decoration for unselected items
                          child: Center(
                            child: Text(
                              days[value.toInt()],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minY: 0,
              maxY: [proteinTarget, carbsTarget, fatsTarget, proteins, carbs, fats].reduce((a, b) => a > b ? a : b) * 1.2,
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, proteins * 0.8),
                    FlSpot(1, proteins * 0.9),
                    FlSpot(2, proteins),
                    FlSpot(3, proteins),
                    FlSpot(4, proteins * 1.1),
                    FlSpot(5, proteins * 1.05),
                    FlSpot(6, proteins * 1.2),
                  ],
                  isCurved: true,
                  color: Colors.red,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [Colors.red.withOpacity(0.3), Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      if (spot.x == 3) {
                        return FlDotCirclePainter(
                          radius: 5,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: Colors.red,
                        );
                      }
                      return FlDotCirclePainter(
                        radius: 3,
                        color: Colors.red,
                      );
                    },
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.orange,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      if (spot.x == 3) {
                        return LineTooltipItem(
                          "Fat    ${fats.toStringAsFixed(1)}g\nCarbs ${carbs.toStringAsFixed(1)}g\nProtein ${proteins.toStringAsFixed(1)}g",
                          TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      }
                      return null;
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

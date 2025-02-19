import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:health_pal/utils/constants/colors.dart';

class NutritionGraph extends StatelessWidget {
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
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, 1000),
                    FlSpot(1, 900),
                    FlSpot(2, 1200),
                    FlSpot(3, 1500),
                    FlSpot(4, 1700),
                    FlSpot(5, 1600),
                    FlSpot(6, 2000),
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
                          "Fat    40g\nCarbs 20g\nProtein 4g",
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

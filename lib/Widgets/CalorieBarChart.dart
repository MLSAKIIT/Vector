import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalorieBarChart(),
    );
  }
}

class CalorieBarChart extends StatelessWidget {
  const CalorieBarChart({super.key});

  final List<double> yValues = const [150, 200, 200, 250, 150];

  @override
  Widget build(BuildContext context) {
    const refWidth = 350.0;
    const refHeight = 640.0;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final wScale = screenWidth / refWidth;
    final hScale = screenHeight / refHeight;

    final totalCalories = yValues.reduce((a, b) => a + b).toInt();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 190 * wScale,
          height: 160 * hScale,
          padding: EdgeInsets.all(10 * wScale),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15 * wScale),
            color: const Color(0xFF7527AC),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$totalCalories",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15 * wScale,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2 * hScale),
              Text(
                "Calories Burned!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12 * wScale,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20 * hScale),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: 300,
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: 100,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.white24,
                        strokeWidth: 1,
                      ),
                      drawVerticalLine: false,
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 100,
                          getTitlesWidget: (value, meta) => Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: const Color(0xFFD9D9D9),
                              fontSize: 10 * wScale,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final labels = ["150", "100", "200", "250", "150"];
                            return Padding(
                              padding: EdgeInsets.only(top: 5 * hScale),
                              child: Text(
                                labels[value.toInt()],
                                style: TextStyle(
                                  color: const Color(0xFFE0E0E0),
                                  fontFamily: 'Inter',
                                  fontSize: 10 * wScale,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(
                      yValues.length,
                          (index) => _bar(context, index, yValues[index], wScale),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData _bar(BuildContext context, int x, double y, double wScale) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 13 * wScale,
          borderRadius: BorderRadius.circular(12 * wScale),
          color: const Color(0xFFC27CCE),
        ),
      ],
    );
  }
}

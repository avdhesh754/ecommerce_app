import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../../core/utils/responsive_breakpoints.dart';
import '../controllers/dashboard_controller.dart';

class RevenueChartCard extends StatelessWidget {
  const RevenueChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(ResponsiveBreakpoints.getResponsiveSize(context, 16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Revenue Overview',
                  style: TextStyle(
                    fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
                SizedBox(
                  height: 300,
                  child: controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey[300],
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const style = TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                );
                                Widget text;
                                switch (value.toInt()) {
                                  case 0:
                                    text = const Text('Jan', style: style);
                                    break;
                                  case 1:
                                    text = const Text('Feb', style: style);
                                    break;
                                  case 2:
                                    text = const Text('Mar', style: style);
                                    break;
                                  case 3:
                                    text = const Text('Apr', style: style);
                                    break;
                                  case 4:
                                    text = const Text('May', style: style);
                                    break;
                                  case 5:
                                    text = const Text('Jun', style: style);
                                    break;
                                  default:
                                    text = const Text('', style: style);
                                    break;
                                }
                                return SideTitleWidget(
                                  meta: meta,
                                  child: text,
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const style = TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                );
                                return SideTitleWidget(
                                  meta: meta,
                                  child: Text('${value.toInt()}k', style: style),
                                );
                              },
                              reservedSize: 42,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        minX: 0,
                        maxX: 5,
                        minY: 0,
                        maxY: 6,
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 3),
                              FlSpot(1, 1),
                              FlSpot(2, 4),
                              FlSpot(3, 3),
                              FlSpot(4, 5),
                              FlSpot(5, 4),
                            ],
                            isCurved: true,
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.withValues(alpha: 0.8),
                                Colors.blue.withValues(alpha: 0.3),
                              ],
                            ),
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(
                              show: false,
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.withValues(alpha: 0.3),
                                  Colors.blue.withValues(alpha: 0.1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
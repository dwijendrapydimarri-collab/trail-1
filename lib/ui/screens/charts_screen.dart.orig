import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:app/ui/theme/app_theme.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  String _selectedMuscleGroup = 'Chest';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Strength Progress')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Estimated 1RM Progression', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Chest'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Back'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Legs'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Shoulders'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          const weeks = ['W1', 'W2', 'W3', 'W4', 'W5', 'W6'];
                          if (value.toInt() >= 0 && value.toInt() < weeks.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(weeks[value.toInt()], style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12)),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}kg', style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12));
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getMockDataForMuscleGroup(_selectedMuscleGroup),
                      isCurved: true,
                      color: AppTheme.accentColor,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.accentColor.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text('Weekly Volume Heatmap', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 50000,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(days[value.toInt()], style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12)),
                          );
                        },
                        reservedSize: 28,
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 15000, color: AppTheme.primaryColor, width: 16, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 0, color: AppTheme.primaryColor, width: 16, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 22000, color: AppTheme.primaryColor, width: 16, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 18000, color: AppTheme.primaryColor, width: 16, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 0, color: AppTheme.primaryColor, width: 16, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 30000, color: AppTheme.primaryColor, width: 16, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 12000, color: AppTheme.primaryColor, width: 16, borderRadius: BorderRadius.circular(4))]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedMuscleGroup == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedMuscleGroup = label;
          });
        }
      },
      selectedColor: AppTheme.primaryColor.withOpacity(0.3),
    );
  }

  List<FlSpot> _getMockDataForMuscleGroup(String muscleGroup) {
    // Return some mock progressive data for the charts based on the muscle group
    switch (muscleGroup) {
      case 'Chest':
        return const [FlSpot(0, 80), FlSpot(1, 82.5), FlSpot(2, 85), FlSpot(3, 85), FlSpot(4, 87.5), FlSpot(5, 90)];
      case 'Back':
        return const [FlSpot(0, 90), FlSpot(1, 95), FlSpot(2, 95), FlSpot(3, 100), FlSpot(4, 102.5), FlSpot(5, 105)];
      case 'Legs':
        return const [FlSpot(0, 110), FlSpot(1, 115), FlSpot(2, 120), FlSpot(3, 125), FlSpot(4, 130), FlSpot(5, 135)];
      case 'Shoulders':
        return const [FlSpot(0, 50), FlSpot(1, 52.5), FlSpot(2, 52.5), FlSpot(3, 55), FlSpot(4, 57.5), FlSpot(5, 60)];
      default:
        return const [FlSpot(0, 50), FlSpot(1, 52.5), FlSpot(2, 55), FlSpot(3, 57.5), FlSpot(4, 60), FlSpot(5, 62.5)];
    }
  }
}

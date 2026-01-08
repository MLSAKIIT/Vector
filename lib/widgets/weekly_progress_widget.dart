import 'package:flutter/material.dart';
import 'dart:math' as math;

class WeeklyProgressWidget extends StatelessWidget {
  const WeeklyProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'Weekly progress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12),
            children: [
              _buildStepsCard(
                color: Color(0xFF7527AC),
                icon: Icons.directions_run,
                steps: 2000,
                label: 'Steps left',
                progress: 0.65,
              ),
              _buildStepsCard(
                color: Color(0xFF5498CE),
                icon: Icons.pool,
                steps: 2000,
                label: 'Steps left',
                progress: 0.45,
              ),
              _buildStepsCard(
                color: Color(0xFFCA6FB0),
                icon: Icons.directions_bike,
                steps: 2000,
                label: 'Steps left',
                progress: 0.55,
              ),
              _buildRankCard(
                color: Color(0xFF7EBAE8).withOpacity(0.63),
                rank: 12,
              ),
              _buildDistanceCard(
                color: Color(0xFFCA6FB0),
                distance: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepsCard({
    required Color color,
    required IconData icon,
    required int steps,
    required String label,
    required double progress,
  }) {
    return Container(
      width: 140,
      margin: EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            steps.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
          Spacer(),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CustomPaint(
                    painter: PieChartPainter(
                      progress: progress,
                      color: Colors.white.withOpacity(0.3),
                      backgroundColor: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildRankCard({
    required Color color,
    required int rank,
  }) {
    return Container(
      width: 140,
      margin: EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '#$rank',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'This Week',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceCard({
    required Color color,
    required int distance,
  }) {
    return Container(
      width: 140,
      margin: EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$distance Km',
            style: TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'This Week',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  PieChartPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      rect,
      -math.pi / 2, // Start from top
      2 * math.pi * progress,
      true,
      progressPaint,
    );

    // Draw inner circle to create ring effect
    final innerPaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.clear;
    canvas.drawCircle(center, radius * 0.6, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

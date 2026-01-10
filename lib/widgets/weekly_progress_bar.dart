import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;


class WeeklyProgressBar extends StatelessWidget {
  final List<StepsCardData>? stepsCards;
  final RankCardData? rankCard;
  final DistanceCardData? distanceCard;
  final double height;
  final bool showHeader;
  final String headerTitle;

  const WeeklyProgressBar({
    super.key,
    this.stepsCards,
    this.rankCard,
    this.distanceCard,
    this.height = 160,
    this.showHeader = true,
    this.headerTitle = 'Weekly progress',
  });

  @override
  Widget build(BuildContext context) {
    // Default data if not provided
    final defaultStepsCards = [
      StepsCardData(
        color: const Color(0xFF7527AC),
        icon: Icons.directions_run,
        steps: 2000,
        label: 'Steps left',
        progress: 0.65,
      ),
      StepsCardData(
        color: const Color(0xFF5498CE),
        icon: Icons.pool,
        steps: 2000,
        label: 'Steps left',
        progress: 0.45,
      ),
      StepsCardData(
        color: const Color(0xFFCA6FB0),
        icon: Icons.directions_bike,
        steps: 2000,
        label: 'Steps left',
        progress: 0.55,
      ),
    ];

    final defaultRankCard = RankCardData(
      color: const Color(0xFF7EBAE8).withOpacity(0.63),
      rank: 12,
    );

    final defaultDistanceCard = DistanceCardData(
      color: const Color(0xFFCA6FB0),
      distance: 18,
    );

    final cards = stepsCards ?? defaultStepsCards;
    final rank = rankCard ?? defaultRankCard;
    final distance = distanceCard ?? defaultDistanceCard;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showHeader) ...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  headerTitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
        SizedBox(
          height: height,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              ...cards.map((card) => _StepsCard(data: card)),
              _RankCard(data: rank),
              _DistanceCard(data: distance),
            ],
          ),
        ),
      ],
    );
  }
}

// ============== Data Models ==============

class StepsCardData {
  final Color color;
  final IconData icon;
  final int steps;
  final String label;
  final double progress;

  StepsCardData({
    required this.color,
    required this.icon,
    required this.steps,
    required this.label,
    required this.progress,
  });
}

class RankCardData {
  final Color color;
  final int rank;
  final bool showUpArrow;

  RankCardData({
    required this.color,
    required this.rank,
    this.showUpArrow = true,
  });
}

class DistanceCardData {
  final Color color;
  final int distance;
  final String unit;

  DistanceCardData({
    required this.color,
    required this.distance,
    this.unit = 'Km',
  });
}

// ============== Card Widgets ==============

class _StepsCard extends StatelessWidget {
  final StepsCardData data;

  const _StepsCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: data.color,
        borderRadius: BorderRadius.circular(20.29),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            data.steps.toString(),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 23.75,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            data.label,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.8),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 88,
                  height: 88,
                  child: CustomPaint(
                    painter: _PieChartPainter(
                      progress: data.progress,
                      color: Colors.white.withOpacity(0.3),
                      backgroundColor: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: data.color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 19,
                      height: 18,
                      child: Opacity(
                        opacity: 0.8,
                        child: Icon(
                          data.icon,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RankCard extends StatelessWidget {
  final RankCardData data;

  const _RankCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: data.color,
        borderRadius: BorderRadius.circular(20.29),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '#${data.rank}',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 23.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (data.showUpArrow) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_drop_up,
                  color: Colors.white,
                  size: 32,
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'This Week',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const Spacer(),
          // Bar chart visualization
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar(40, Colors.white.withOpacity(0.4)),
              _buildBar(70, Colors.white.withOpacity(0.5)),
              _buildBar(55, Colors.white.withOpacity(0.45)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double height, Color color) {
    return Container(
      width: 40,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _DistanceCard extends StatelessWidget {
  final DistanceCardData data;

  const _DistanceCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: data.color,
        borderRadius: BorderRadius.circular(20.29),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${data.distance} ${data.unit}',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 23.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'This Week',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const Spacer(),
          // Flag icon visualization
          Icon(
            Icons.flag,
            color: Colors.white.withOpacity(0.4),
            size: 60,
          ),
        ],
      ),
    );
  }
}

// ============== Pie Chart Painter ==============

class _PieChartPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _PieChartPainter({
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

import 'package:flutter/material.dart';
import '../widgets/weekly_progress_widget.dart';
import '../widgets/streak.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Weekly Progress Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.emoji_events, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Weekly progress',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildStepsCard(
                    color: const Color(0xFF7527AC),
                    icon: Icons.directions_run,
                    steps: 2000,
                    label: 'Steps left',
                    progress: 0.65,
                  ),
                  _buildStepsCard(
                    color: const Color(0xFF5498CE),
                    icon: Icons.pool,
                    steps: 2000,
                    label: 'Steps left',
                    progress: 0.45,
                  ),
                  _buildStepsCard(
                    color: const Color(0xFFCA6FB0),
                    icon: Icons.directions_bike,
                    steps: 2000,
                    label: 'Steps left',
                    progress: 0.55,
                  ),
                  _buildRankCard(
                    color: const Color(0xFF7EBAE8).withOpacity(0.63),
                    rank: 12,
                  ),
                  _buildDistanceCard(
                    color: const Color(0xFFCA6FB0),
                    distance: 18,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Streak Section
            const StreakWidget(),
            const SizedBox(height: 20),
            // You can add more content here
          ],
        ),
      ),
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
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.29),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            steps.toString(),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 23.75,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
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
                    painter: PieChartPainter(
                      progress: progress,
                      color: Colors.white.withOpacity(0.3),
                      backgroundColor: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 19,
                      height: 18,
                      child: Opacity(
                        opacity: 0.8,
                        child: Icon(
                          icon,
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

  Widget _buildCaloriesCard({
    required Color color,
    required int calories,
    required String label,
  }) {
    return Container(
      width: 110,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.29),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            calories.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23.5,
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
          const Spacer(),
          // Bar chart visualization
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar(60, Colors.white.withOpacity(0.3)),
              _buildBar(80, Colors.white.withOpacity(0.5)),
              _buildBar(100, Colors.white.withOpacity(0.7)),
              _buildBar(85, Colors.white.withOpacity(0.5)),
              _buildBar(70, Colors.white.withOpacity(0.4)),
            ],
          ),
          const SizedBox(height: 8),
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

  Widget _buildRankCard({
    required Color color,
    required int rank,
  }) {
    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: color,
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
                '#$rank',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 23.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_up,
                color: Colors.white,
                size: 32,
              ),
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

  Widget _buildDistanceCard({
    required Color color,
    required int distance,
  }) {
    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.29),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$distance Km',
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

  Widget _buildStreakWidget() {
    const int streakCount = 40;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$streakCount days streak!",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "This is what consistency looks like",
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Text("🔥", style: TextStyle(fontSize: 30)),
            ],
          ),
          const SizedBox(height: 30),
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(height: 2, color: Colors.white10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStreakNode(isFirst: true, label: "31\ndec"),
                  _buildStreakNode(icon: Icons.directions_run, isCompleted: true),
                  _buildStreakNode(icon: Icons.ice_skating, isCompleted: true),
                  _buildStreakNode(icon: Icons.directions_bike, isCompleted: false),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakNode({
    String? label,
    IconData? icon,
    bool isFirst = false,
    bool isCompleted = false,
  }) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFirst
            ? const Color(0xFF3D5AFE)
            : (isCompleted ? const Color(0xFF2E7D32) : const Color(0xFF2C2C2E)),
      ),
      child: Center(
        child: icon != null
            ? Icon(icon, color: isCompleted ? Colors.white : Colors.white24, size: 20)
            : Text(
                label!,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vector/view_models/session_view_model.dart';
import 'package:vector/models/session_tracking_model.dart';
import 'package:vector/core/constants.dart';
import 'package:vector/views/live_tracking_view.dart';
import 'package:vector/views/profile_page.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  ActivityType _selectedActivity = ActivityType.running;

  @override
  void initState() {
    super.initState();
    // Load today's sessions when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SessionViewModel>().loadTodaySessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessionVM = context.watch<SessionViewModel>();

    return Scaffold(
      backgroundColor: const Color(colorBackground),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),

              const SizedBox(height: 20),

              // Activity Selector Circle
              _buildActivitySelector(),

              const SizedBox(height: 20),

              // Current Activity Card (Pink)
              _buildCurrentActivityCard(sessionVM),

              const SizedBox(height: 24),

              // TODAY Label
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'TODAY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Activity Cards Grid
              _buildActivityCardsGrid(sessionVM),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Row(
              children: [
                Icon(Icons.chevron_left, color: Colors.white, size: 28),
                Text(
                  'Back',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Session',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white54, width: 2),
              ),
              child: const Icon(Icons.person_outline, color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(colorSessionDarkPurple),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActivityButton(
            icon: Icons.directions_run,
            label: 'Run',
            activityType: ActivityType.running,
          ),
          _buildPlayButton(),
          _buildActivityButton(
            icon: Icons.directions_walk,
            label: 'Walk',
            activityType: ActivityType.walking,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityButton({
    required IconData icon,
    required String label,
    required ActivityType activityType,
  }) {
    final isSelected = _selectedActivity == activityType;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedActivity = activityType;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.2),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? const Color(colorSessionDarkPurple)
                      : Colors.white,
                  size: 28,
                ),
              ),
              if (isSelected)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayButton() {
    return GestureDetector(
      onTap: () => _startSession(),
      child: Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: const Icon(
          Icons.play_arrow,
          color: Color(colorSessionDarkPurple),
          size: 36,
        ),
      ),
    );
  }

  Future<void> _startSession() async {
    final sessionVM = context.read<SessionViewModel>();

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(colorSessionPink)),
      ),
    );

    final success = await sessionVM.startSession(_selectedActivity);

    // Close loading
    if (mounted) Navigator.pop(context);

    if (success && mounted) {
      // Navigate to live tracking
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LiveTrackingView()),
      );
    } else if (mounted && sessionVM.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(sessionVM.error!)));
    }
  }

  Widget _buildCurrentActivityCard(SessionViewModel sessionVM) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(colorSessionPink),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            _selectedActivity.displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                value: _getDistanceForActivity(sessionVM),
                unit: 'km',
                label: 'Distance',
              ),
              _buildStatItem(
                value: _getDurationForActivity(sessionVM),
                unit: '',
                label: 'Time',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getDistanceForActivity(SessionViewModel sessionVM) {
    switch (_selectedActivity) {
      case ActivityType.walking:
        return (sessionVM.todaySummary.walkingDistance / 1000).toStringAsFixed(
          1,
        );
      case ActivityType.running:
        return (sessionVM.todaySummary.runningDistance / 1000).toStringAsFixed(
          1,
        );
      case ActivityType.cycling:
        return (sessionVM.todaySummary.cyclingDistance / 1000).toStringAsFixed(
          1,
        );
    }
  }

  String _getDurationForActivity(SessionViewModel sessionVM) {
    Duration duration;
    switch (_selectedActivity) {
      case ActivityType.walking:
        duration = sessionVM.todaySummary.walkingDuration;
        break;
      case ActivityType.running:
        duration = sessionVM.todaySummary.runningDuration;
        break;
      case ActivityType.cycling:
        duration = sessionVM.todaySummary.cyclingDuration;
        break;
    }
    return sessionVM.todaySummary.formatDuration(duration);
  }

  Widget _buildStatItem({
    required String value,
    required String unit,
    required String label,
  }) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: unit,
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildActivityCardsGrid(SessionViewModel sessionVM) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildActivityCard(
                  icon: Icons.directions_walk,
                  title: 'Walking',
                  distance:
                      '${(sessionVM.todaySummary.walkingDistance / 1000).toStringAsFixed(1)} Km',
                  duration: sessionVM.todaySummary.formatDuration(
                    sessionVM.todaySummary.walkingDuration,
                  ),
                  onTap: () {
                    setState(() => _selectedActivity = ActivityType.walking);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActivityCard(
                  icon: Icons.directions_bike,
                  title: 'Cycling',
                  distance:
                      '${(sessionVM.todaySummary.cyclingDistance / 1000).toStringAsFixed(1)} Km',
                  duration: sessionVM.todaySummary.formatDuration(
                    sessionVM.todaySummary.cyclingDuration,
                  ),
                  onTap: () {
                    setState(() => _selectedActivity = ActivityType.cycling);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActivityCard(
                  icon: Icons.directions_run,
                  title: 'Running',
                  distance:
                      '${(sessionVM.todaySummary.runningDistance / 1000).toStringAsFixed(1)} Km',
                  duration: sessionVM.todaySummary.formatDuration(
                    sessionVM.todaySummary.runningDuration,
                  ),
                  onTap: () {
                    setState(() => _selectedActivity = ActivityType.running);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActivityCard(
                  icon: Icons.local_fire_department,
                  title: 'Calories',
                  distance:
                      '${sessionVM.todaySummary.totalCalories.toStringAsFixed(0)} Cal',
                  duration: _getTotalDuration(sessionVM),
                  isCalories: true,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getTotalDuration(SessionViewModel sessionVM) {
    final total =
        sessionVM.todaySummary.walkingDuration +
        sessionVM.todaySummary.runningDuration +
        sessionVM.todaySummary.cyclingDuration;
    return sessionVM.todaySummary.formatDuration(total);
  }

  Widget _buildActivityCard({
    required IconData icon,
    required String title,
    required String distance,
    required String duration,
    required VoidCallback onTap,
    bool isCalories = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(colorSessionCard),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              isCalories ? 'Calories burned' : 'Distance covered',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              distance,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Time Taken',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              duration,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

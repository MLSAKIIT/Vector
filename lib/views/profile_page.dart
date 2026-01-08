import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vector/view_models/profile_view_model.dart';
import 'package:vector/models/session_tracking_model.dart';
import 'package:vector/core/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(colorBackground),
      body: SafeArea(
        child: Consumer<ProfileViewModel>(
          builder: (context, profileVM, child) {
            return Column(
              children: [
                // Purple header with profile info
                _buildProfileHeader(profileVM),

                // Session history section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Session history',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Filter tabs
                        _buildFilterTabs(profileVM),

                        const SizedBox(height: 20),

                        // Session list
                        Expanded(
                          child: profileVM.isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(colorSessionPink),
                                  ),
                                )
                              : profileVM.sessionHistory.isEmpty
                              ? _buildEmptyState()
                              : _buildSessionList(profileVM),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileViewModel profileVM) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4A2C6A), Color(colorSessionDarkPurple)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        border: Border.all(color: Colors.cyan.withValues(alpha: 0.5), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          children: [
            // Back button row
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      Icon(
                        Icons.chevron_left,
                        color: Colors.white.withValues(alpha: 0.9),
                        size: 28,
                      ),
                      Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: profileVM.photoUrl != null
                  ? ClipOval(
                      child: Image.network(
                        profileVM.photoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
                      ),
                    )
                  : _buildDefaultAvatar(),
            ),

            const SizedBox(height: 16),

            // Name
            Text(
              profileVM.displayName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Location
            GestureDetector(
              onTap: () => _updateLocationFromGPS(profileVM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.redAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    profileVM.location,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                  if (profileVM.location == 'Location not set') ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.my_location,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 16,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Edit Profile button
            ElevatedButton(
              onPressed: () => _showEditProfileDialog(profileVM),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return const Icon(Icons.person_outline, size: 50, color: Colors.white54);
  }

  Widget _buildFilterTabs(ProfileViewModel profileVM) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(colorSessionDarkPurple),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          _buildFilterTab('Week', HistoryFilter.week, profileVM),
          _buildFilterTab('Month', HistoryFilter.month, profileVM),
          _buildFilterTab('Year', HistoryFilter.year, profileVM),
        ],
      ),
    );
  }

  Widget _buildFilterTab(
    String label,
    HistoryFilter filter,
    ProfileViewModel profileVM,
  ) {
    final isSelected = profileVM.currentFilter == filter;

    return Expanded(
      child: GestureDetector(
        onTap: () => profileVM.setFilter(filter),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(colorSessionDarkPurple)
                    : Colors.white,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_run,
            size: 64,
            color: Colors.grey.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No sessions yet',
            style: TextStyle(
              color: Colors.grey.withValues(alpha: 0.7),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a workout to see your history',
            style: TextStyle(
              color: Colors.grey.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionList(ProfileViewModel profileVM) {
    final grouped = profileVM.groupedSessions;
    final dateKeys = grouped.keys.toList();

    return ListView.builder(
      itemCount: dateKeys.length,
      itemBuilder: (context, index) {
        final dateKey = dateKeys[index];
        final sessions = grouped[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 8),
              child: Text(
                dateKey,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Session cards for this date
            ...sessions.map((session) => _buildSessionCard(session)),

            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildSessionCard(SessionModel session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(colorSessionCard),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Activity icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(colorSessionPink),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getActivityIcon(session.activityType),
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Activity details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.activityType.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(session.totalDistance / 1000).toStringAsFixed(1)} Km',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
                Text(
                  'distance covered',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _formatDuration(session.duration),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Time taken',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // Calories
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                session.caloriesBurned.toStringAsFixed(0),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Calories burned',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getActivityIcon(ActivityType activityType) {
    switch (activityType) {
      case ActivityType.walking:
        return Icons.directions_walk;
      case ActivityType.running:
        return Icons.directions_run;
      case ActivityType.cycling:
        return Icons.directions_bike;
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void _showEditProfileDialog(ProfileViewModel profileVM) {
    final nameController = TextEditingController(
      text: profileVM.profile?.name ?? profileVM.displayName,
    );
    final locationController = TextEditingController(
      text: profileVM.profile?.location ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(colorSessionPink)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: locationController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Location',
                labelStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                hintText: 'e.g., Delhi, India',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(colorSessionPink)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await profileVM.updateProfile(
                name: nameController.text.trim(),
                location: locationController.text.trim(),
              );
              if (success && context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated!'),
                    backgroundColor: Color(colorSessionPink),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(colorSessionPink),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateLocationFromGPS(ProfileViewModel profileVM) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Getting your location...'),
        duration: Duration(seconds: 1),
      ),
    );

    final success = await profileVM.updateLocationFromGPS();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Location updated!' : 'Could not get location',
          ),
          backgroundColor: success ? const Color(colorSessionPink) : Colors.red,
        ),
      );
    }
  }
}

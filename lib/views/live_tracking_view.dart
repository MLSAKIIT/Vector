import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:vector/view_models/session_view_model.dart';
import 'package:vector/models/session_tracking_model.dart';
import 'package:vector/core/constants.dart';

class LiveTrackingView extends StatefulWidget {
  const LiveTrackingView({super.key});

  @override
  State<LiveTrackingView> createState() => _LiveTrackingViewState();
}

class _LiveTrackingViewState extends State<LiveTrackingView> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final sessionVM = context.watch<SessionViewModel>();
    final activeSession = sessionVM.activeSession;

    if (activeSession == null) {
      return const Scaffold(
        backgroundColor: Color(colorBackground),
        body: Center(
          child: Text(
            'No active session',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    // Build polyline from route points
    final polylinePoints = activeSession.route
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    // Get current position for camera
    final currentPos = sessionVM.currentPosition;
    final center = currentPos != null
        ? LatLng(currentPos.latitude, currentPos.longitude)
        : const LatLng(0, 0);

    return Scaffold(
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: center, initialZoom: 16),
            children: [
              // OpenStreetMap tile layer
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.vector',
              ),

              // Route polyline
              if (polylinePoints.length >= 2)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: polylinePoints,
                      color: const Color(0xFF2196F3),
                      strokeWidth: 6,
                    ),
                  ],
                ),

              // Markers
              MarkerLayer(
                markers: [
                  // Start marker
                  if (polylinePoints.isNotEmpty)
                    Marker(
                      point: polylinePoints.first,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  // Current position marker
                  if (currentPos != null)
                    Marker(
                      point: LatLng(currentPos.latitude, currentPos.longitude),
                      width: 24,
                      height: 24,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          // Bottom control panel
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildControlPanel(sessionVM, activeSession),
          ),

          // Center on user button
          Positioned(
            right: 16,
            bottom: 280,
            child: FloatingActionButton.small(
              onPressed: () {
                if (currentPos != null) {
                  _mapController.move(
                    LatLng(currentPos.latitude, currentPos.longitude),
                    16,
                  );
                }
              },
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel(SessionViewModel sessionVM, dynamic activeSession) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag indicator
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn(
                value: activeSession.distanceInKm.toStringAsFixed(2),
                unit: 'km',
                label: 'Distance',
              ),
              _buildStatColumn(
                value: activeSession.formattedDuration,
                unit: '',
                label: 'Duration',
              ),
              _buildStatColumn(
                value: sessionVM.currentSpeedKmh.toStringAsFixed(1),
                unit: 'km/h',
                label: 'Speed',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Activity icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                ),
                child: Icon(
                  _getActivityIcon(activeSession.activityType),
                  color: Colors.grey[700],
                  size: 28,
                ),
              ),

              // Stop button
              GestureDetector(
                onTap: () => _stopSession(sessionVM),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(colorSessionPink),
                  ),
                  child: const Icon(Icons.stop, color: Colors.white, size: 36),
                ),
              ),

              // Speed display button
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      sessionVM.currentSpeedKmh.toStringAsFixed(0),
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'km/h',
                      style: TextStyle(color: Colors.grey[500], fontSize: 8),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStatColumn({
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
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (unit.isNotEmpty)
                TextSpan(
                  text: ' $unit',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
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

  Future<void> _stopSession(SessionViewModel sessionVM) async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Session?'),
        content: const Text('Are you sure you want to end this session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(colorSessionPink),
            ),
            child: const Text('End', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: Color(colorSessionPink)),
        ),
      );

      await sessionVM.stopSession();

      // Close loading and go back
      if (mounted) {
        Navigator.pop(context); // Close loading
        Navigator.pop(context); // Go back to sessions page
      }
    }
  }
}

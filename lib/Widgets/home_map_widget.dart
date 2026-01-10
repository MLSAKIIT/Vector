import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class HomeMapWidget extends StatefulWidget {
  const HomeMapWidget({super.key});

  @override
  State<HomeMapWidget> createState() => _HomeMapWidgetState();
}

class _HomeMapWidgetState extends State<HomeMapWidget> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController(
      initPosition: GeoPoint(
        latitude: 20.2961, 
        longitude: 85.8245,
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: 170, 
        width: double.infinity,
        child: OSMFlutter(
          controller: _mapController,
          osmOption: OSMOption(
            zoomOption: const ZoomOption(
              initZoom: 14,
              minZoomLevel: 3,
              maxZoomLevel: 18,
            ),
            userTrackingOption: const UserTrackingOption(
              enableTracking: true,
              unFollowUser: false,
            ),
            showZoomController: false,
            showContributorBadgeForOSM: false,
            roadConfiguration: const RoadOption(
              roadColor: Colors.blueAccent,
            ),
          ),
        ),
      ),
    );
  }
}

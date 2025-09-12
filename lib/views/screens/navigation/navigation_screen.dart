import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;

import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../../controller/services/mapbox_service.dart';

class NavigationScreen extends StatefulWidget {
  final double destinationLat;
  final double destinationLng;
  final String destinationName;

  const NavigationScreen({
    super.key,
    required this.destinationLat,
    required this.destinationLng,
    required this.destinationName,
  });

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  MapboxMap? _mapboxMap;
  PointAnnotationManager? _pointAnnotationManager;
  geo.Position? _currentPosition;
  bool _isNavigating = false;
  PolylineAnnotationManager? _polylineAnnotationManager;

  @override
  void initState() {
    super.initState();
    _initializeNavigation();
  }

  Future<void> _initializeNavigation() async {
    try {
      _currentPosition = await geo.Geolocator.getCurrentPosition();
      if (_currentPosition != null) {
        if (_mapboxMap != null) {
          await _moveCameraToUser();
        }
        await _updateRoute();
      }
    } catch (e) {
      print('Error initializing navigation: $e');
    }
  }

  Future<void> _moveCameraToUser() async {
    if (_mapboxMap == null || _currentPosition == null) return;
    await _mapboxMap!.setCamera(
      CameraOptions(
        center: Point(
          coordinates: Position(
            _currentPosition!.longitude,
            _currentPosition!.latitude,
          ),
        ),
        zoom: 15.0,
      ),
    );
  }

  Future<void> _updateRoute() async {
    if (_currentPosition == null || _mapboxMap == null) return;

    try {
      final route = await MapboxService.getNavigationRoute(
        _currentPosition!,
        widget.destinationLat,
        widget.destinationLng,
      );

      // Draw polyline
      if (_polylineAnnotationManager == null) {
        _polylineAnnotationManager = await _mapboxMap!.annotations.createPolylineAnnotationManager();
      } else {
        await _polylineAnnotationManager!.deleteAll();
      }

      final geometry = route['geometry'] as List<dynamic>;
      if (geometry.isNotEmpty) {
        final coordinates = geometry.map<Position>((e) => Position(e[0] as double, e[1] as double)).toList();
        await _polylineAnnotationManager!.create(
          PolylineAnnotationOptions(
            geometry: LineString(coordinates: coordinates),
            lineColor: 0xFF0071BC,
            lineWidth: 5.0,
          ),
        );
      }
    } catch (e) {
      print('Error updating route: $e');
    }
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    mapboxMap.annotations.createPointAnnotationManager().then((value) async {
      _pointAnnotationManager = value;
      await _addUserMarker();
      await _addDestinationMarker();
      await _moveCameraToUser();
    });
  }

  Future<void> _addDestinationMarker() async {
    if (_pointAnnotationManager == null) return;

    final options = PointAnnotationOptions(
      geometry: Point(
        coordinates: Position(
          widget.destinationLng,
          widget.destinationLat,
        ),
      ),
      iconSize: 1.0,
    );
    await _pointAnnotationManager!.create(options);
  }

  Future<void> _addUserMarker() async {
    if (_pointAnnotationManager == null || _currentPosition == null) return;
    final options = PointAnnotationOptions(
      geometry: Point(
        coordinates: Position(
          _currentPosition!.longitude,
          _currentPosition!.latitude,
        ),
      ),
      iconSize: 1.0,
    );
    await _pointAnnotationManager!.create(options);
  }

  @override
  void dispose() {
    _mapboxMap?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.destinationName,
          style: AppTextStyles.titleBoldUpper.copyWith(
            color: AppColor.whiteColor,
            fontSize: 18.sp,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColor.whiteColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
         MapWidget(
  key: const ValueKey("mapWidget"),
  onMapCreated: _onMapCreated,
),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isNavigating = !_isNavigating;
                });
                if (_isNavigating) {
                  _updateRoute();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _isNavigating ? 'Stop Navigation' : 'Start Navigation',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppColor.whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
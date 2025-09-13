import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';

import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../../controller/services/mapbox_service.dart';
import '../../../views/widgets/payment_bottom_sheet.dart';
import '../../../views/custom_widgets/custom_widgets.dart';

class NavigationScreen extends StatefulWidget {
  final double destinationLat;
  final double destinationLng;
  final String destinationName;
  final double parkingPrice; // New field for price
  final String parkingId;

  const NavigationScreen({
    super.key,
    required this.destinationLat,
    required this.destinationLng,
    required this.destinationName,
    required this.parkingPrice, // Require price
    required this.parkingId,
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
  StreamSubscription<geo.Position>? _positionStreamSubscription;
  PointAnnotation? _userAnnotation;
  PointAnnotation? _destinationAnnotation;

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
      }

      // Start listening to position updates
      _positionStreamSubscription = geo.Geolocator.getPositionStream(
        locationSettings: const geo.LocationSettings(
          accuracy: geo.LocationAccuracy.high,
          distanceFilter: 10, // Update every 10 meters
        ),
      ).listen((geo.Position position) {
        setState(() {
          _currentPosition = position;
        });
        _updateUserMarker();
        if (_isNavigating) {
          _updateRoute();
        }
      });
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

      // Load and add custom images to the map style
      final locationBytes = await _loadImage('assets/pngs/map_icons/location.png');
      final arrowBytes = await _loadImage('assets/pngs/map_icons/arrow.png');
      await (_mapboxMap!.style as dynamic).addImage('location-icon', locationBytes);
      await (_mapboxMap!.style as dynamic).addImage('arrow-icon', arrowBytes);

      await _addUserMarker();
      await _addDestinationMarker();
      await _moveCameraToUser();
    });

    // Add re-center button
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
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
      iconImage: 'arrow',
      iconSize: 1.0,
    );
    _destinationAnnotation = await _pointAnnotationManager!.create(options);
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
      iconImage: 'location',
      iconSize: 1.0,
      iconRotate: _currentPosition!.heading,
    );
    _userAnnotation = await _pointAnnotationManager!.create(options);
  }

  Future<void> _updateUserMarker() async {
    if (_userAnnotation != null) {
      await _pointAnnotationManager!.delete(_userAnnotation!);
    }
    await _addUserMarker();
  }

  Future<Uint8List> _loadImage(String path) async {
    final data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    final byteData = await frame.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _polylineAnnotationManager?.deleteAll();
    _mapboxMap?.dispose();
    super.dispose();
  }

  Future<void> _clearRoute() async {
    if (_polylineAnnotationManager != null) {
      await _polylineAnnotationManager!.deleteAll();
    }
  }

  Future<void> _zoomToRoute() async {
    if (_mapboxMap == null || _polylineAnnotationManager == null) return;
    // For simplicity, zoom to 15
    await _mapboxMap!.setCamera(
      CameraOptions(
        zoom: 15.0,
      ),
    );
  }

  Future<void> _zoomOut() async {
    if (_mapboxMap == null) return;
    // Zoom out to 10 or a broader view
    await _mapboxMap!.setCamera(
      CameraOptions(
        zoom: 10.0,
      ),
    );
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
            bottom: 70,
            left: 16,
            right: 16,
            child: CustomElevatedButton(
              backgroundColor: Colors.red,
              borderColor: Colors.red,
              
              verticalPadding: 8,
              text: 'Make Payment',
              textStyle: TextStyle(
                  fontSize: 18.sp,
                  color: AppColor.whiteColor,
                ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => PaymentBottomSheet(parkingPrice: widget.parkingPrice, parkingId: widget.parkingId,),
                );
              },
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: SizedBox(
              height: 42,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isNavigating = !_isNavigating;
                  });
                  if (_isNavigating) {
                    await _updateRoute();
                    await _zoomToRoute();
                  } else {
                    await _clearRoute();
                    await _zoomOut();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 6),
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
          ),
          // Positioned(
          //   bottom: 100,
          //   right: 16,
          //   child: FloatingActionButton(
          //     onPressed: _moveCameraToUser,
          //     backgroundColor: AppColor.primaryColor,
          //     child: Icon(
          //       Icons.my_location,
          //       color: AppColor.whiteColor,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
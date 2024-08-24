import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleMaping extends StatefulWidget {
  const GoogleMaping({super.key});

  @override
  State<GoogleMaping> createState() => _GoogleMapingState();
}

class _GoogleMapingState extends State<GoogleMaping> {
  final locationController = Location();

  LatLng? currentPosition;
  final List<Marker> markerList = [];
  int _markerIdCounter = 1;

  // Variables to store the start and end positions for polyline
  LatLng? _startPosition;
  LatLng? _endPosition;

  final Map<PolylineId, Polyline> _polylines = {};
  final String googleMapsApiKey = "YOUR_GOOGLE_MAPS_API_KEY";

  void _addMarker(LatLng position) async {
    final String markerIdVal = '$_markerIdCounter';
    _markerIdCounter++;
    final address = await _getAddressFromLatLng(position);

    final Marker marker = Marker(
      markerId: MarkerId(markerIdVal),
      position: position,
      infoWindow: InfoWindow(
        title: address,
      ),
      onTap: () {
        print('$markerIdVal clicked');
        // Set start or end position based on the existing markers
        if (_startPosition == null) {
          setState(() {
            _startPosition = position;
          });
        } else if (_endPosition == null) {
          setState(() {
            _endPosition = position;
          });
          // _generatePolyline(); // Generate polyline once both start and end positions are set
        }
      },
    );
    setState(() {
      markerList.add(marker);
    });
  }

  Future<String> _getAddressFromLatLng(LatLng position) async {
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleMapsApiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'].isNotEmpty) {
        return data['results'][0]['formatted_address'] ?? 'No address found';
      } else {
        return 'No address found';
      }
    } else {
      return 'Failed to load address';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async => initializeMap());
  }

  Future<void> initializeMap() async {
    await getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    final bool canDrawPolygon = markerList.length >= 1;
    final Set<Polygon> polygons = canDrawPolygon
        ? {
      Polygon(
        polygonId: PolygonId('polygon_1'),
        points: markerList.map((marker) => marker.position).toList(),
        strokeWidth: 1,
        strokeColor: Colors.cyan,
        fillColor: Colors.black.withOpacity(0.15),
      ),
    }
        : {};

    return Scaffold(
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 13,
        ),
        markers: Set<Marker>.of(markerList),
        polygons: polygons,
        polylines: Set<Polyline>.of(_polylines.values),
        onTap: (LatLng position) {
          _addMarker(position);
        },
      ),
    );
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
        print(currentPosition);
      }
    });
  }

  // Method to generate polyline between start and end positions
  // Future<void> _generatePolyline() async {
  //   if (_startPosition != null && _endPosition != null) {
  //     final polylinePoints = PolylinePoints();
      // final result = await polylinePoints.getRouteBetweenCoordinates(
      //   googleApiKey: googleMapsApiKey,
      //   origin: PointLatLng(_startPosition!.latitude, _startPosition!.longitude),
      //   destination: PointLatLng(_endPosition!.latitude, _endPosition!.longitude),
      // );

      // if (result.points.isNotEmpty) {
      //   final polylineCoordinates = result.points
      //       .map((point) => LatLng(point.latitude, point.longitude))
      //       .toList();
      //
      //   const id = PolylineId('polyline');
      //   final polyline = Polyline(
      //     polylineId: id,
      //     color: Colors.cyan,
      //     points: polylineCoordinates,
      //     width: 5,
      //   );
    //
    //     setState(() {
    //       _polylines[id] = polyline;
    //     });
    //   } else {
    //     debugPrint(result.errorMessage);
    //   }
    // }
  }


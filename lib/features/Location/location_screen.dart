import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Position? currentPosition;
  String googleApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  GoogleMapController? mapController;
  Set<Marker> markers = {};

  Future<void> _getUserLocation() async {
    // Request permission if not already granted
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 10,
        ),
      );

      setState(() {
        currentPosition = position;
        _updateMapLocation();
      });
    }
  }

  void _updateMapLocation() {
    if (currentPosition != null && mapController != null) {
      final LatLng position = LatLng(
        currentPosition!.latitude,
        currentPosition!.longitude,
      );

      mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 15,
        ),
      ));

      setState(() {
        markers = {
          Marker(
            markerId: const MarkerId('current_location'),
            position: position,
            infoWindow: const InfoWindow(title: 'My Location'),
          ),
        };
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Don't make initState async — use a separate method
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    onMapCreated: (controller) {
                      mapController = controller;
                      _updateMapLocation();
                    },
                    initialCameraPosition: CameraPosition(
                      target: currentPosition != null
                          ? LatLng(
                              currentPosition!.latitude,
                              currentPosition!.longitude,
                            )
                          : const LatLng(0, 0), // Default position
                      zoom: 15,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    markers: markers,
                  ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentPosition != null
                        ? 'Lat: ${currentPosition!.latitude.toStringAsFixed(4)}, Long: ${currentPosition!.longitude.toStringAsFixed(4)}'
                        : 'Location not available',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _getUserLocation,
                        child: const Text('Refresh Location'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/home');
                        },
                        child: const Text('Go to Home'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

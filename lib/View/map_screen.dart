import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  final double lat;
  final double lng;

  const MapScreen({super.key, required this.lat, required this.lng});

  @override
  Widget build(BuildContext context) {
    LatLng position = LatLng(lat, lng);

    return Scaffold(
      appBar: AppBar(title: Text("User Location")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: position,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId("user"),
            position: position,
          )
        },
      ),
    );
  }
}
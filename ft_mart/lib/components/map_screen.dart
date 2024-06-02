import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final ValueChanged<LatLng> onLocationSelected;

  const MapScreen({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng _center = const LatLng(37.7749, -122.4194); // Default center (San Francisco)
  late Marker _marker;

  @override
  void initState() {
    super.initState();
    _marker = Marker(
      markerId: MarkerId('selected_location'),
      position: _center,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Delivery Location')),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: Set<Marker>.of([_marker]),
            onTap: (LatLng location) {
              setState(() {
                _marker = _marker.copyWith(positionParam: location);
              });
            },
            onCameraMove: (CameraPosition position) {
              setState(() {
                _marker = _marker.copyWith(positionParam: position.target);
              });
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                widget.onLocationSelected(_marker.position);
                Navigator.of(context).pop();
              },
              child: const Text('Select This Location'),
            ),
          ),
        ],
      ),
    );
  }
}

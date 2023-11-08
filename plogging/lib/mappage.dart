import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:plogging/upload_state.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  Position? currentPosition;
  bool isLocationPermissionGranted = false;
  Set<Marker> markers = {}; // 마커를 저장할 Set

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    Position position;
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 권한 확인 후 상태를 업데이트합니다.
    setState(() {
      currentPosition = position;
      isLocationPermissionGranted = true; // 권한이 부여되었음을 표시합니다.
    });

    // 위치 권한이 있는 경우에만 카메라를 현재 위치로 이동합니다.
    if (isLocationPermissionGranted) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15.0,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final markerState = Provider.of<MarkerState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () {
              if (currentPosition != null) {
                mapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(
                        currentPosition!.latitude, currentPosition!.longitude),
                    zoom: 15.0,
                  ),
                ));
              }
            },
          ),
        ],
      ),
      body: Consumer<UploadState>(
        builder: (context, uploadState, child) {
          if (uploadState.isUploaded && currentPosition != null) {
            final marker = Marker(
              markerId: MarkerId('uploadedLocation'),
              position: LatLng(currentPosition!.latitude, currentPosition!.longitude),
            );

            markerState.addMarker(marker);
          }

          return GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0),
              zoom: 10,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: markerState.markers.toSet(),
          );
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
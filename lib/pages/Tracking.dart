import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:car_management/components/globals.dart' as globals;

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  final LatLng _center =  LatLng(3.056648475066696, 101.7005614);
  
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override

  //Have to initialize markers in initState otherwise will ctrash the app
  void initState() {
    super.initState();
    _markers.add(
      Marker(
        markerId: MarkerId('1'),
        position: LatLng(globals.locationData["Car1"]![0],globals.locationData["Car1"]![1]),
        infoWindow: InfoWindow(title: 'Car1 Location'),
      ),
    );

    _markers.add(
      Marker(
        markerId: MarkerId('2'),
        position: LatLng(globals.locationData["Car2"]![0],globals.locationData["Car2"]![1]),
        infoWindow: InfoWindow(title: 'Car2 Location'),
      ),
    );

    _markers.add(
      Marker(
        markerId: MarkerId('3'),
        position: LatLng(globals.locationData["Car3"]![0],globals.locationData["Car3"]![1]),
        infoWindow: InfoWindow(title: 'Car3 Location'),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), // Adjust as needed
            ),
            clipBehavior: Clip.antiAlias, // This line is important
            width: MediaQuery.of(context).size.height * 0.4,
            height: MediaQuery.of(context).size.height * 0.6,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition:
                  CameraPosition(target: _center, zoom: 11.0),
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              markers: _markers,
            ),
          ),
        ],
      ),
    ));
  }
}

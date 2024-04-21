import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Filter;

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    // widget.setFloatingActionButton(FloatingActionButton.extended(
    //   onPressed: _goToTheLake,
    //   label: const Text('To the lake!'),
    //   icon: const Icon(Icons.directions_boat),
    // ));
    FirebaseFirestore db = FirebaseFirestore.instance;
    final docRef = db.collection("stalls").doc("RphFhWrY3pizzXER2SwX");
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        print(data);
      },
      onError: (e) => print("Error getting document: $e"),
    );

    return GoogleMap(
      myLocationButtonEnabled: true,
      mapType: MapType.terrain,
      initialCameraPosition: _kGooglePlex,
      // cameraTargetBounds: CameraTargetBounds(LatLngBounds(
      //   northeast: const LatLng(1.4658552799691218, 104.02754205378703),
      //   southwest: const LatLng(1.2128625367214978, 103.5809025879886),
      // )),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Polylines extends StatefulWidget {
  const Polylines({super.key});

  @override
  State<Polylines> createState() => _PolylinesState();
}

class _PolylinesState extends State<Polylines> {
  Completer<GoogleMapController> _controler = Completer();
  // initial position
  static final CameraPosition _kGooglePlex =
      const CameraPosition(target: LatLng(31.460639, 74.292534), zoom: 18);

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  List<LatLng> latlang = [
    LatLng(31.460639, 74.292534),
    LatLng(31.466792, 74.308866),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < latlang.length; i++) {
      _markers.add(
        Marker(
            markerId: MarkerId(i.toString()),
            position: latlang[i],
            icon: BitmapDescriptor.defaultMarker,
            infoWindow:
                InfoWindow(title: 'Starting point:', snippet: '5 star rating')),
      );
      setState(() {});
      _polylines.add(Polyline(
          polylineId: PolylineId('1'),
          points: latlang,
          color: Colors.lightBlue));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: GoogleMap(
          markers: _markers,
          initialCameraPosition: _kGooglePlex,
          polylines: _polylines,
          mapType: MapType.normal,
          //mapType : MapType.satellite,
          // mapType: MapType.hybrid,
          myLocationEnabled: true,
          compassEnabled: true,

          onMapCreated: (GoogleMapController controller) {
            // call that controller here
            _controler.complete(controller);
          },
        ),
      ),
    );
  }
}

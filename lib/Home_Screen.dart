import 'dart:async';
import 'dart:collection';
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_integration/conver_latlang_to_address.dart';
import 'package:google_maps_integration/google_places_api.dart';
import 'package:google_maps_integration/polylines.dart';
import 'package:google_maps_integration/stylegooglemap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controler =
      Completer(); // here we create controller
  Uint8List? markerImage;
  List<String> assets = [
    'assets/cricket.png',
    'assets/burger.png',
  ]; //list for icons on map

// initial position
  static final CameraPosition _kGooglePlex =
      const CameraPosition(target: LatLng(31.460639, 74.292534), zoom: 18);

  Set<Polygon> _polygon = HashSet<Polygon>();
// list to add polugon
  List<LatLng> points = [
    LatLng(31.457468, 74.294336),
    LatLng(31.464103, 74.288695),
    LatLng(31.466692, 74.308934),
    LatLng(31.452687, 74.290602),
    LatLng(31.457468, 74.294336),
  ];

// here we create marker to show  marker on our current location manually which we add
  List<Marker> _marker = [];

  List<Marker> _list = [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(31.460639, 74.292534),
        infoWindow: InfoWindow(title: 'My Current Location')),
    Marker(
        markerId: MarkerId('2'),
        position: LatLng(31.462996, 74.290084),
        infoWindow: InfoWindow(title: 'BEER GROUND')),
  ];

  final List<LatLng> _latlang = <LatLng>[
    LatLng(31.462996, 74.290084),
    LatLng(31.460639, 74.292534),
  ]; // list where we want to add icons

  // Here we create a future function to get a current user loation
  // import geolocater
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _marker.addAll(_list);
    loadData();
    _polygon.add(Polygon(
        polygonId: PolygonId('1'),
        points: points,
        fillColor: Colors.lightBlue.withOpacity(0.4),
        geodesic: true,
        strokeColor: Colors.blue));
  }

  loadData() async {
    for (int i = 0; i < assets.length; i++) {
      final Uint8List markerIcon = await getBytesFromAssets(assets[i], 100);
      _marker.add(
        Marker(
            markerId: MarkerId(i.toString()),
            position: _latlang[i],
            icon: BitmapDescriptor.fromBytes(markerIcon),
            infoWindow:
                InfoWindow(title: 'This is title marker:' + i.toString())),
      );
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GooglePlacesApi()));
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConverLatlangToAddress()));
            },
            icon: Icon(Icons.change_circle),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Polylines()));
            },
            icon: Icon(Icons.route),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StyleGoogleMapScreen()));
            },
            icon: Icon(Icons.mode),
          )
        ],
        title: Text('Google Maps'),
      ),
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,

          mapType: MapType.normal,
          //mapType : MapType.satellite,
          // mapType: MapType.hybrid,
          myLocationEnabled: true,
          compassEnabled: true,
          polygons: _polygon,
          markers: Set<Marker>.of(_marker),
          onMapCreated: (GoogleMapController controller) {
            // call that controller here
            _controler.complete(controller);
          },
        ),
      ),

      // this floating action button is create to move on your loction where we set it
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_disabled_outlined),
          onPressed: () async {
            //1.Manually which we add

            // GoogleMapController controller = await _controler.future;
            // controller.animateCamera(CameraUpdate.newCameraPosition(
            //     CameraPosition(                                               // here we set it by manualy
            //         target: LatLng(31.460639, 74.292534), zoom: 14)));

            //2. automaticaly using geolocator pacakge
            getUserCurrentLocation().then((value) async {
              print('My curreny Location');
              print(value.latitude.toString() +
                  " " +
                  value.longitude.toString() +
                  value.timestamp.toString());

              _marker.add(
                Marker(
                    markerId: MarkerId('3'),
                    position: LatLng(value.latitude, value.longitude),
                    infoWindow: InfoWindow(title: 'My Current Location')),
              );
              CameraPosition cameraPosition = CameraPosition(
                  zoom: 14, target: LatLng(value.latitude, value.longitude));

              final GoogleMapController controller = await _controler.future;
              controller.animateCamera(
                  CameraUpdate.newCameraPosition(cameraPosition));

              setState(() {});
            });
          }),
    );
  }
}

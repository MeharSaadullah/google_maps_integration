import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StyleGoogleMapScreen extends StatefulWidget {
  const StyleGoogleMapScreen({super.key});

  @override
  State<StyleGoogleMapScreen> createState() => _StyleGoogleMapScreenState();
}

class _StyleGoogleMapScreenState extends State<StyleGoogleMapScreen> {
  String mapTheme = '';
  Completer<GoogleMapController> _controler =
      Completer(); // here we create controller
  // initial position
  static final CameraPosition _kGooglePlex =
      const CameraPosition(target: LatLng(31.460639, 74.292534), zoom: 18);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DefaultAssetBundle.of(context)
        .loadString('assets/maptheme/night_theme.json')
        .then((value) {
      mapTheme = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Map Theme'),
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                        onTap: () {
                          _controler.future.then((value) {
                            DefaultAssetBundle.of(context)
                                .loadString('assets/maptheme/silver_theme.json')
                                .then((string) {
                              value.setMapStyle(string);
                            });
                          });
                        },
                        child: Text('Silver')),
                    PopupMenuItem(
                        onTap: () {
                          _controler.future.then((value) {
                            DefaultAssetBundle.of(context)
                                .loadString('assets/maptheme/retro_theme.json')
                                .then((string) {
                              value.setMapStyle(string);
                            });
                          });
                        },
                        child: Text('Retro')),
                    PopupMenuItem(
                        onTap: () {
                          _controler.future.then((value) {
                            DefaultAssetBundle.of(context)
                                .loadString('assets/maptheme/night_theme.json')
                                .then((string) {
                              value.setMapStyle(string);
                            });
                          });
                        },
                        child: Text('Night')),
                    PopupMenuItem(
                        onTap: () {
                          _controler.future.then((value) {
                            DefaultAssetBundle.of(context)
                                .loadString(
                                    'assets/maptheme/aubergine_theme.json')
                                .then((string) {
                              value.setMapStyle(string);
                            });
                          });
                        },
                        child: Text('Aubergine')),
                  ]),
        ],
      ),
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,

          mapType: MapType.normal,
          //mapType : MapType.satellite,
          // mapType: MapType.hybrid,
          myLocationEnabled: true,
          compassEnabled: true,

          onMapCreated: (GoogleMapController controller) {
            controller.setMapStyle(mapTheme);
            // call that controller here
            _controler.complete(controller);
          },
        ),
      ),
    );
  }
}

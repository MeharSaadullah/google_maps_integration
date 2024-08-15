import 'package:flutter/material.dart';
import 'package:google_maps_integration/Home_Screen.dart';
import 'package:google_maps_integration/conver_latlang_to_address.dart';
import 'package:google_maps_integration/google_places_api.dart';
import 'package:google_maps_integration/polylines.dart';
import 'package:google_maps_integration/stylegooglemap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: //StyleGoogleMapScreen()
            //Polylines()
            HomeScreen()
        //ConverLatlangToAddress()
        );
  }
}

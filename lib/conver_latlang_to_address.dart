// add pacakge geocoding

import 'package:flutter/material.dart';

import 'package:geocoding/geocoding.dart';

class ConverLatlangToAddress extends StatefulWidget {
  const ConverLatlangToAddress({super.key});

  @override
  State<ConverLatlangToAddress> createState() => _ConverLatlangToAddressState();
}

class _ConverLatlangToAddressState extends State<ConverLatlangToAddress> {
  String Address = ''; // to show conversion of adrres to longnitude and latiude

  String STAdress = ''; // to show conversion of langlat to address
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Google Map'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(Address),
          Text(STAdress),
          GestureDetector(
            onTap: () async {
// From a query
              List<Location> locations =
                  await locationFromAddress("Gronausestraat 710, Enschede");
// From coordinates
              //final coordinates = new Coordinates(31.461573, 74.292803);

              List<Placemark> placemarks =
                  await placemarkFromCoordinates(52.2165157, 6.9437819);
              setState(() {
                Address = locations.last.latitude.toString() +
                    "  " +
                    locations.last.longitude.toString();
                STAdress = placemarks.reversed.last.country.toString() +
                    " " +
                    placemarks.reversed.last.street.toString();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.lightBlue),
                height: 80,
                child: Center(
                    child: Text(
                  'Convert',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

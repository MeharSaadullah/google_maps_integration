// use hhtp and uuid pacakge also enable api from google map console

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class GooglePlacesApi extends StatefulWidget {
  const GooglePlacesApi({super.key});

  @override
  State<GooglePlacesApi> createState() => _GooglePlacesApiState();
}

class _GooglePlacesApiState extends State<GooglePlacesApi> {
  TextEditingController Searchcontroller = TextEditingController();
  var uuid = Uuid(); // use to get device id
  String _sessionToken = '12345';
  List<dynamic> _placeList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Searchcontroller.addListener(() {
      onchange();
    });
  }

  void onchange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4(); // here we add device ID
      });
    }
    getsuggestion(Searchcontroller.text);
  }

  void getsuggestion(String input) async {
    String kPLACES_API_KEY =
        'AIzaSyCKZgBdeolrn29sLWEToPZl9Un81_WWDwU'; // get from google map console

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();

    print(response.body.toString());
    if (response.statusCode == 200) {
      _placeList = jsonDecode(response.body.toString())['predictions'];
    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Center(
            child: Text(
          'Google Search Places Api',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            TextFormField(
              controller: Searchcontroller,
              decoration: InputDecoration(hintText: "Search with Name"),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: _placeList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_placeList[index]['description']),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}

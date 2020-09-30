import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:ungteachnic/utility/my_style.dart';

class AddInformation extends StatefulWidget {
  @override
  _AddInformationState createState() => _AddInformationState();
}

class _AddInformationState extends State<AddInformation> {
  double lat, lng;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    LocationData data = await findLocation();
    setState(() {
      lat = data.latitude;
      lng = data.longitude;
      print('lat = $lat, lng = $lng');
    });
  }

  Future<LocationData> findLocation() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          buildRow(),
          buildContainerAddress(),
          buildContainerPhone(),
          buildExpanded()
        ],
      ),
    );
  }

  Expanded buildExpanded() => Expanded(
        child: lat == null
            ? MyStyle().showProgress()
            : Container(
                margin: EdgeInsets.all(16),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(lat, lng),
                    zoom: 16,
                  ),
                  onMapCreated: (controller) {},
                  markers: <Marker>[
                    Marker(
                      markerId: MarkerId('id'),
                      position: LatLng(lat, lng),
                      infoWindow: InfoWindow(
                          title: 'You Here', snippet: 'Lat = $lat, Lng = $lng'),
                    ),
                  ].toSet(),
                ),
              ),
      );

  Container buildContainerAddress() {
    return Container(
      width: 250,
      child: TextField(
        decoration: InputDecoration(labelText: 'Address'),
      ),
    );
  }

  Container buildContainerPhone() {
    return Container(
      width: 250,
      child: TextField(
        decoration: InputDecoration(labelText: 'Phone'),
      ),
    );
  }

  File file;

  Row buildRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: () => chooseImage(ImageSource.camera),
        ),
        Container(
          width: 200,
          height: 200,
          child: file == null ? Image.asset('images/avatar.png') : Image.file(file) ,
        ),
        IconButton(
          icon: Icon(Icons.add_photo_alternate),
          onPressed: () => chooseImage(ImageSource.gallery),
        ),
      ],
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker()
          .getImage(source: source, maxWidth: 800, maxHeight: 800);
      setState(() {
        file = File(result.path);
      });
    } catch (e) {}
  }
}

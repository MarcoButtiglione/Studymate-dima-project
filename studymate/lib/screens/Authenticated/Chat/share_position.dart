import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:studymate/models/user.dart';
import '../../../service/storage_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SharePosition extends StatefulWidget {
  final double latitute;
  final double longitude;
  final String rue;
  final Users reciver;
  const SharePosition(
      {super.key,
      required this.reciver,
      required this.latitute,
      required this.longitude,
      required this.rue});
  @override
  _SharePositionState createState() => _SharePositionState();
}

class _SharePositionState extends State<SharePosition> {
  final Completer<GoogleMapController> _controller = Completer();
  LocationData? currentLocation;

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
        print("${currentLocation}");
      },
    );
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 13.5,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    final LatLng destination = LatLng(widget.latitute, widget.longitude);
    return Scaffold(
        body: Container(
      color: const Color.fromARGB(18, 233, 64, 87),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.only(top: 60.0, bottom: 10),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: FutureBuilder(
                          future: storage
                              .downloadURL(widget.reciver.profileImageURL),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text("Something went wrong!");
                            } else if (snapshot.hasData) {
                              return Image(
                                image: NetworkImage(snapshot.data!),
                              );
                            } else {
                              return const Card(
                                margin: EdgeInsets.zero,
                              );
                            }
                          }),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      widget.rue,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
            Expanded(
              child: currentLocation == null
                  ? const Center(child: Text("Loading"))
                  : GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(currentLocation!.latitude!,
                            currentLocation!.longitude!),
                        zoom: 13.5,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId("MyPosition"),
                          position: LatLng(currentLocation!.latitude!,
                              currentLocation!.longitude!),
                        ),
                        Marker(
                          markerId: MarkerId(
                              "${widget.reciver.firstname} ${widget.reciver.lastname}"),
                          position: destination,
                        ),
                      },
                      onMapCreated: (mapController) {
                        _controller.complete(mapController);
                      },
                    ),
            )
          ]),
    ));
  }
}

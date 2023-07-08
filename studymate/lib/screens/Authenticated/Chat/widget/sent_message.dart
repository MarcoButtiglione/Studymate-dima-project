import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

import 'custom_shape.dart';

class SentMessage extends StatelessWidget {
  final String? message;
  final Timestamp? addTime;
  final bool? view;
  const SentMessage({super.key, this.message, this.addTime, this.view});

  @override
  Widget build(BuildContext context) {
    String pos = message!;
    double latitude = 45.465665;
    double longitude = 9.1892020;
    try {
      latitude = double.parse(pos.substring(5, pos.indexOf(";")));

      longitude = double.parse(pos.substring(pos.indexOf(";") + 5));
    } catch (e) {
      // Handle parsing errors here
      print("Error parsing number: $e");
    }
    return Padding(
      padding: const EdgeInsets.only(right: 18.0, left: 50, top: 15, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const SizedBox(height: 30),
          messageTextGroup(latitude, longitude),
        ],
      ),
    );
  }

  Widget messageTextGroup(double latitude, double longitude) => Flexible(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 233, 64, 87),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    (message!.contains("l4t:") && message!.contains("l0n:"))
                        ? Stack(
                            children: [
                              Container(
                                height: 150,
                                width: 200,
                                child: GoogleMap(
                                    myLocationButtonEnabled: false,
                                    myLocationEnabled: false,
                                    zoomControlsEnabled: false,
                                    zoomGesturesEnabled: false,
                                    scrollGesturesEnabled: false,
                                    compassEnabled: false,
                                    rotateGesturesEnabled: false,
                                    mapToolbarEnabled: false,
                                    tiltGesturesEnabled: false,
                                    //onMapCreated: _onMapCreated,
                                    initialCameraPosition: CameraPosition(
                                        target: LatLng(latitude, longitude),
                                        zoom: 30),
                                    markers: {
                                      Marker(
                                        markerId: MarkerId("destination"),
                                        position: LatLng(latitude, longitude),
                                        icon: BitmapDescriptor.defaultMarker,
                                      ),
                                    }),
                              ),
                              SizedBox(
                                height: 150,
                                width: 100,
                              ),
                            ],
                          )
                        : Text(
                            message!,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text: DateFormat.Hm().format(addTime!.toDate()),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14)),
                      const WidgetSpan(
                        child: SizedBox(
                          width: 5,
                        ),
                      ),
                      WidgetSpan(
                          child: (view == true)
                              ? const Icon(
                                  Icons.done_all,
                                  color: Colors.indigo,
                                  size: 20,
                                )
                              : const Icon(
                                  Icons.done_all,
                                  color: Colors.white,
                                  size: 20,
                                ))
                    ])),
                  ],
                )),
          ),
          CustomPaint(
              painter: CustomShape(const Color.fromARGB(255, 233, 64, 87))),
        ],
      ));
}

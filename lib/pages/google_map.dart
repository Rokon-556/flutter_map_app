import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MyGoogleMap extends StatefulWidget {
  final String? name;
  final double? latitude;
  final double? longitude;

  MyGoogleMap({this.name, this.latitude, this.longitude});

  @override
  _MyGoogleMapState createState() => _MyGoogleMapState();
}

PolylinePoints polylinePoints = PolylinePoints();
Map<PolylineId, Polyline> polylines = {};

Map<MarkerId, Marker> markers = {};

class _MyGoogleMapState extends State<MyGoogleMap> {
  //Completer<GoogleMapController> _controller1 = Completer();
  var currentAddress = '';
  TravelMode navigationType=TravelMode.driving;

  getAddress() async {
    final coordinates = Coordinates(currentLat, currentLon);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    currentAddress = first.addressLine;
    print("first");
    print(first.addressLine);
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId? markerId1;
  Marker? marker1;
  MarkerId? markerId2;
  Marker? marker2;

  double currentLat = 0.0;
  double currentLon = 0.0;

  LatLng _initialcameraposition = LatLng(23.8103, 90.3563);
  GoogleMapController? _controller;

  Location _location = Location();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _originController = TextEditingController();

  void _onMapCreated(GoogleMapController cntlr) {
    _controller = cntlr;
    _location.onLocationChanged.listen(
      (l) {
        setState(
          () {
            currentLat = l.latitude!;
            currentLon = l.longitude!;
          },
        );
        getAddress();
        _getPolyline(
            currentLat, currentLon, widget.latitude!, widget.longitude!);

        markerId1 = MarkerId('Current');
        marker1 = Marker(
          markerId: markerId1!,
          position: LatLng(l.latitude!, l.longitude!),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );
        markerId2 = MarkerId('Destination');
        marker2 = Marker(
          markerId: markerId2!,
          position: LatLng(widget.latitude!, widget.longitude!),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        );

        markers[markerId1!] = marker1!;
        markers[markerId2!] = marker2!;

        _controller!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 10),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _initialcameraposition),
              mapType: MapType.normal,
              myLocationEnabled: true,
              tiltGesturesEnabled: true,
              compassEnabled: true,
              onMapCreated: _onMapCreated,
              markers: Set<Marker>.of(markers.values),
              polylines: Set<Polyline>.of(polylines.values),
            ),
            Positioned(
              top: 15.0,
              right: 15.0,
              left: 15.0,
              child: Container(
                height: 100.0,
                width: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.blueGrey.shade200,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 8,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: _originController,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  hintText: currentAddress,
                                  fillColor: Colors.white60,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  contentPadding:
                                      EdgeInsets.only(left: 15.0, top: 15.0),
                                ),
                                onChanged: (value) {
                                  print(value);
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _searchController,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  hintText: widget.name,
                                  fillColor: Colors.white60,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  contentPadding:
                                      EdgeInsets.only(left: 15.0, top: 15.0),
                                ),
                                onChanged: (value) {
                                  print(value);
                                },
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        navigationType=TravelMode.driving;
                                      });
                                    },
                                    icon: Icon(Icons.local_taxi),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        navigationType=TravelMode.transit;
                                      });
                                    },
                                    icon: Icon(Icons.directions_transit),
                                  ),IconButton(
                                    onPressed: () {
                                      setState(() {
                                        navigationType=TravelMode.bicycling;
                                      });
                                    },
                                    icon: Icon(Icons.directions_bike),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        navigationType=TravelMode.walking;
                                      });
                                    },
                                    icon: Icon(Icons.directions_run),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.search),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
  }

  void _getPolyline(double originLat, double originLon, double destinationLat,
      double destinationLon) async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "Enter Your API KEY",
      PointLatLng(originLat, originLon),
      PointLatLng(destinationLat, destinationLon),
      travelMode: navigationType,
    );
    if (result.points.isNotEmpty) {
      print(result);
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:map/map/GPS.dart';
import 'package:map/map/maker.dart';
import 'package:map/map/show_details.dart';

class LoadMap extends StatefulWidget {
  const LoadMap({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoadMapState();
  }
}

class LoadMapState extends State<LoadMap> {
  bool isMapLoaded = false;

  final MapController mapController = MapController();

  LatLng? currentPosition;

  List<Marker> makers = [];

  late Future<LatLng> futurePositon;

  String placeName = '';

  LatLng? selectedPosition;

  Future<void> loadInitialPosition() async {
    LatLng pos = await getCurrentPosition();

    setState(() {
      currentPosition = pos;
    });
  }

  Future<void> moveToCurrentLocation() async {
    Location location = Location();

    var pos = await location.getLocation();

    LatLng newPosition = LatLng(pos.latitude!, pos.longitude!);

    setState(() {
      makers.clear();

      makers.add(
        Marker(
          point: newPosition,
          width: 80,
          height: 80,
          child: const Icon(Icons.location_on, color: Colors.red, size: 40),
        ),
      );
    });

    mapController.move(newPosition, 16);
  }

  void onMapTap(LatLng point) async {
    String name = await getPlaceName(point);

    setState(() {
      placeName = name;

      makers.clear();

      makers.add(
        Marker(
          point: point,
          width: 80,
          height: 80,
          child: const Icon(Icons.location_on, color: Colors.red, size: 40),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    loadInitialPosition();
  }

  @override
  Widget build(BuildContext context) {
    if (currentPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        maker(currentPosition!, makers, onMapTap),

        if (placeName.isNotEmpty)
          Positioned(
            top: 20,
            left: 20,
            right: 20,

            child: Container(
              padding: const EdgeInsets.all(10),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(blurRadius: 5, color: Colors.black26),
                ],
              ),

              child: Row(
                children: [
                  Icon(Icons.search),
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,

                      children: [
                        const TextSpan(
                          text: 'Địa điểm: ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        TextSpan(text: placeName),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

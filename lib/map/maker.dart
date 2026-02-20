import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

Widget maker(LatLng postion, List<Marker> markers, Function(LatLng) onTapMap) {
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: FlutterMap(
      options: MapOptions(
        initialCenter: postion,
        initialZoom: 13,
        onTap: (tapPosition, point) {
          onTapMap(point);
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.map',
          maxZoom: 19,
        ),

        MarkerLayer(markers: markers),
      ],
    ),
  );
}

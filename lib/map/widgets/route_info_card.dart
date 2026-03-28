import 'package:flutter/material.dart';
import 'package:map/map/loadmap.dart';

class RouteInfoCard extends StatelessWidget {
  final LoadMapState mapState;

  const RouteInfoCard({super.key, required this.mapState});

  @override
  Widget build(BuildContext context) {
    if (mapState.startName.isEmpty &&
        mapState.endName.isEmpty &&
        mapState.routeText.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mapState.startName.isNotEmpty)
            Text('Điểm đi: ${mapState.startName}'),
          if (mapState.endName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('Điểm đến: ${mapState.endName}'),
            ),
          if (mapState.routeText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                mapState.routeText,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}

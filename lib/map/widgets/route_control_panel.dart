import 'package:flutter/material.dart';
import 'package:map/map/loadmap.dart';

class RouteControlPanel extends StatelessWidget {
  final LoadMapState mapState;
  final Future<void> Function() onDrawRoute;
  final Future<void> Function() onMoveToCurrentLocation;
  final VoidCallback onShowHistory;
  final Future<void> Function() onSaveRoute;
  final VoidCallback onClearRoute;

  const RouteControlPanel({
    super.key,
    required this.mapState,
    required this.onDrawRoute,
    required this.onMoveToCurrentLocation,
    required this.onShowHistory,
    required this.onSaveRoute,
    required this.onClearRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: mapState.loadingRoute ? null : onDrawRoute,
                  icon: const Icon(Icons.alt_route),
                  label: const Text('Tìm đường'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onMoveToCurrentLocation,
                  icon: const Icon(Icons.location_on, color: Colors.red),
                  label: const Text('Vị trí tôi'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onShowHistory,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      icon: Icon(Icons.list, color: Colors.white),
                      label: const Text(
                        "Đã lưu",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onSaveRoute,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Colors.blue),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: const Text(
                        "Lưu đường đi",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: onClearRoute,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                icon: const Icon(Icons.clear, color: Colors.white),
                label: const Text(
                  'Xóa đường đi',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

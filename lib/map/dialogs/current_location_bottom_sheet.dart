import 'package:flutter/material.dart';
import 'package:map/map/loadmap.dart';

Future<void> showCurrentLocationBottomSheet({
  required BuildContext context,
  required GlobalKey<LoadMapState> mapKey,
}) async {
  try {
    final currentMapState = mapKey.currentState;
    if (currentMapState == null) {
      debugPrint('mapKey.currentState == null');
      return;
    }

    await currentMapState.moveToCurrentLocation();

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final sheetMapState = mapKey.currentState;

        return SafeArea(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 180),
            padding: const EdgeInsets.all(16),
            child: sheetMapState == null
                ? const Center(child: Text('Không lấy được dữ liệu vị trí'))
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thông tin vị trí',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        sheetMapState.startName.isNotEmpty
                            ? sheetMapState.startName
                            : 'Chưa lấy được tên vị trí hiện tại',
                        style: const TextStyle(fontSize: 15),
                      ),
                      if (sheetMapState.routeText.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            sheetMapState.routeText,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        );
      },
    );
  } catch (e) {
    debugPrint('Lỗi mở bottom sheet: $e');
  }
}

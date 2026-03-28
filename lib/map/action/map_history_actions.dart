import 'package:flutter/foundation.dart';
import 'package:map/map/loadmap.dart';
import 'package:map/model/database.dart';
import 'package:map/model/mylocation.dart';

class MapHistoryActions {
  static Future<void> saveRoute({
    required MyDataBase db,
    required LoadMapState mapState,
  }) async {
    try {
      final startLat = double.parse(mapState.startLatCtrl.text.trim());
      final startLng = double.parse(mapState.startLngCtrl.text.trim());
      final endLat = double.parse(mapState.endLatCtrl.text.trim());
      final endLng = double.parse(mapState.endLngCtrl.text.trim());

      final mylocation = Mylocation(
        latitudeStart: startLat,
        longitudeStart: startLng,
        longitudeEnd: endLng,
        latitudeEnd: endLat,
        addressStart: mapState.startName.isNotEmpty
            ? mapState.startName
            : 'Chưa có địa chỉ bắt đầu',
        addressEnd: mapState.endName.isNotEmpty
            ? mapState.endName
            : 'Chưa có địa chỉ kết thúc',
      );

      final kq = await db.insertMyLocation(mylocation);
      debugPrint(kq.toString());
    } catch (e) {
      debugPrint("Lỗi $e");
    }
  }

  static Future<void> deleteHistoryItem({
    required MyDataBase db,
    required Mylocation item,
  }) async {
    final id = int.tryParse(item.id.toString());
    if (id != null) {
      await db.deleteMyLocation(id);
    } else {
      debugPrint("id không hợp lệ: ${item.id}");
    }
  }

  static Future<void> selectHistoryRoute({
    required LoadMapState? mapState,
    required Mylocation item,
  }) async {
    if (mapState == null) return;

    mapState.startLatCtrl.text = item.latitudeStart?.toString() ?? '';
    mapState.startLngCtrl.text = item.longitudeStart?.toString() ?? '';
    mapState.endLatCtrl.text = item.latitudeEnd?.toString() ?? '';
    mapState.endLngCtrl.text = item.longitudeEnd?.toString() ?? '';

    await mapState.drawRoute();
  }
}

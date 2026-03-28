import 'package:map/map/loadmap.dart';

class MapLocationActions {
  static Future<void> moveToCurrentLocation({
    required LoadMapState mapState,
    required void Function() onRefresh,
  }) async {
    await mapState.moveToCurrentLocation();
    onRefresh();
  }
}

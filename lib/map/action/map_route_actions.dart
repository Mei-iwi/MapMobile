import 'package:map/map/loadmap.dart';

class MapRouteActions {
  static Future<void> drawRoute({
    required LoadMapState mapState,
    required void Function() onRefresh,
  }) async {
    await mapState.drawRoute();
    onRefresh();
  }
}

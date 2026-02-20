import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

Future<LatLng> getCurrentPosition() async {
  Location location = Location();

  var pos = await location.getLocation();

  return LatLng(pos.latitude!, pos.longitude!);
}

import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

Future<LatLng> getCurrentPosition() async {
  final Location location = Location();

  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      throw Exception('Dịch vụ vị trí đang tắt');
    }
  }

  PermissionStatus permissionGranted = await location.hasPermission();

  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
  }

  if (permissionGranted == PermissionStatus.deniedForever) {
    throw Exception('Quyền vị trí bị từ chối vĩnh viễn');
  }

  if (permissionGranted != PermissionStatus.granted) {
    throw Exception('Quyền truy cập vị trí bị từ chối');
  }

  final LocationData pos = await location.getLocation();

  if (pos.latitude == null || pos.longitude == null) {
    throw Exception('Không lấy được tọa độ hiện tại');
  }

  return LatLng(pos.latitude!, pos.longitude!);
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

Future<String> getPlaceName(LatLng point) async {
  final url =
      "https://nominatim.openstreetmap.org/reverse"
      "?format=json"
      "&lat=${point.latitude}"
      "&lon=${point.longitude}"
      "&zoom=18"
      "&addressdetails=1";

  final respone = await http.get(
    Uri.parse(url),
    headers: {'User-Agent': 'com.example.map'},
  );

  if (respone.statusCode == 200) {
    final data = json.decode(respone.body);

    return data['display_name'];
  }
  return 'Không thể tìm thấy địa danh';
}

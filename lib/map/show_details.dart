import 'dart:convert';
import 'package:flutter/material.dart';
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

  final response = await http.get(
    Uri.parse(url),
    headers: {'User-Agent': 'com.example.map'},
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['display_name'] ?? 'Không rõ địa điểm';
  }

  return 'Không thể tìm thấy địa danh';
}


// Thêm hàm này vào show_details.dart
Future<LatLng?> searchAddress(String address) async {
  final url = "https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(address)}&format=json&limit=1";

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {'User-Agent': 'com.example.map'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      if (data.isNotEmpty) {
        final lat = double.parse(data[0]['lat']);
        final lon = double.parse(data[0]['lon']);
        return LatLng(lat, lon);
      }
    }
  } catch (e) {
    debugPrint("Lỗi searchAddress: $e");
  }
  return null;
}
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'GPS.dart';
import 'route_service.dart';
import 'show_details.dart';

class LoadMap extends StatefulWidget {
  const LoadMap({super.key});

  @override
  State<LoadMap> createState() => LoadMapState();
}

class LoadMapState extends State<LoadMap> {
  final MapController mapController = MapController();

  final TextEditingController startLatController = TextEditingController();
  final TextEditingController startLngController = TextEditingController();
  final TextEditingController endLatController = TextEditingController();
  final TextEditingController endLngController = TextEditingController();

  LatLng? currentPosition;
  LatLng? startPoint;
  LatLng? endPoint;

  List<Marker> markers = [];
  List<LatLng> routePoints = [];

  String startPlaceName = '';
  String endPlaceName = '';
  String routeInfo = '';
  String? errorMessage;
  bool isLoadingRoute = false;
  bool isSatellite = false;

  TextEditingController get startLatCtrl => startLatController;
  TextEditingController get startLngCtrl => startLngController;
  TextEditingController get endLatCtrl => endLatController;
  TextEditingController get endLngCtrl => endLngController;

  String get startName => startPlaceName;
  String get endName => endPlaceName;
  String get routeText => routeInfo;
  bool get loadingRoute => isLoadingRoute;

  @override
  void initState() {
    super.initState();
    loadInitialPosition();
  }

  @override
  void dispose() {
    startLatController.dispose();
    startLngController.dispose();
    endLatController.dispose();
    endLngController.dispose();
    super.dispose();
  }

  Future<void> loadInitialPosition() async {
    try {
      final pos = await getCurrentPosition();
      if (!mounted) return;

      setState(() {
        currentPosition = pos;
        startPoint = pos;

        startLatController.text = pos.latitude.toStringAsFixed(6);
        startLngController.text = pos.longitude.toStringAsFixed(6);

        markers = [
          Marker(
            point: pos,
            width: 80,
            height: 80,
            child: GestureDetector(
              onTap: () =>
                  _showMarkerInfo('Vị trí hiện tại', 'Đang tải...', pos),
              child: const Icon(Icons.location_on, color: Colors.red, size: 35),
            ),
          ),
        ];
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Không lấy được vị trí hiện tại';
      });
    }
  }

  Future<void> moveToCurrentLocation() async {
    try {
      final pos = await getCurrentPosition();
      final name = await getPlaceName(pos);

      if (!mounted) return;

      setState(() {
        currentPosition = pos;
        startPoint = pos;

        startLatController.text = pos.latitude.toStringAsFixed(6);
        startLngController.text = pos.longitude.toStringAsFixed(6);

        startPlaceName = name;

        routePoints = [];
        routeInfo = '';

        markers = [
          Marker(
            point: pos,
            width: 80,
            height: 80,
            child: GestureDetector(
              onTap: () => _showMarkerInfo('Điểm bắt đầu', startPlaceName, pos),
              child: const Icon(Icons.location_on, color: Colors.red, size: 35),
            ),
          ),
          if (endPoint != null)
            Marker(
              point: endPoint!,
              width: 80,
              height: 80,
              child: GestureDetector(
                onTap: () =>
                    _showMarkerInfo('Điểm kết thúc', endPlaceName, endPoint!),
                child: const Icon(
                  Icons.my_location,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
            ),
        ];
      });

      mapController.move(pos, 16);
    } catch (e) {
      debugPrint('Lỗi moveToCurrentLocation: $e');
    }
  }

  LatLng? parseLatLng(String latText, String lngText) {
    final lat = double.tryParse(latText.trim());
    final lng = double.tryParse(lngText.trim());

    if (lat == null || lng == null) return null;
    if (lat < -90 || lat > 90) return null;
    if (lng < -180 || lng > 180) return null;

    return LatLng(lat, lng);
  }

  void updateMarkers() {
    final List<Marker> newMarkers = [];

    if (startPoint != null) {
      newMarkers.add(
        Marker(
          point: startPoint!,
          width: 80,
          height: 80,
          child: GestureDetector(
            // GỌI POPUP Ở ĐÂY
            onTap: () =>
                _showMarkerInfo('Điểm bắt đầu', startPlaceName, startPoint!),
            child: const Icon(Icons.my_location, color: Colors.blue, size: 35),
          ),
        ),
      );
    }

    if (endPoint != null) {
      newMarkers.add(
        Marker(
          point: endPoint!,
          width: 80,
          height: 80,
          child: GestureDetector(
            // GỌI POPUP Ở ĐÂY
            onTap: () =>
                _showMarkerInfo('Điểm kết thúc', endPlaceName, endPoint!),
            child: const Icon(Icons.location_on, color: Colors.red, size: 40),
          ),
        ),
      );
    }

    markers = newMarkers;
  }

  Future<void> drawRoute() async {
    final start = parseLatLng(startLatController.text, startLngController.text);
    final end = parseLatLng(endLatController.text, endLngController.text);

    if (start == null || end == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đúng lat/lng cho 2 vị trí'),
        ),
      );
      return;
    }

    setState(() {
      isLoadingRoute = true;
      startPoint = start;
      endPoint = end;
      routePoints = [];
      routeInfo = '';
      startPlaceName = '';
      endPlaceName = '';
      updateMarkers();
    });

    try {
      final route = await getRoute(start, end);
      final startNameResult = await getPlaceName(start);
      final endNameResult = await getPlaceName(end);

      if (!mounted) return;

      setState(() {
        startPlaceName = startNameResult;
        endPlaceName = endNameResult;

        if (route != null && route.points.isNotEmpty) {
          routePoints = route.points;

          final km = (route.distance / 1000).toStringAsFixed(2);
          final minutes = (route.duration / 60).toStringAsFixed(0);
          routeInfo = 'Quãng đường: $km km | Thời gian: $minutes phút';
        } else {
          routePoints = [];
          routeInfo = 'Không tìm được đường đi';
        }

        updateMarkers();
      });

      final center = LatLng(
        (start.latitude + end.latitude) / 2,
        (start.longitude + end.longitude) / 2,
      );
      mapController.move(center, 13);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        routeInfo = 'Lỗi khi tìm đường';
        routePoints = [];
      });
    } finally {
      if (!mounted) return;
      setState(() {
        isLoadingRoute = false;
      });
    }
  }

  void clearRoute() {
    setState(() {
      endPoint = null;
      routePoints = [];
      routeInfo = '';
      endPlaceName = '';
      endLatController.clear();
      endLngController.clear();
      updateMarkers();
    });
  }

  Future<void> onMapTap(LatLng point) async {
    if (startPoint == null) return;

    setState(() {
      endPoint = point;
      endLatController.text = point.latitude.toStringAsFixed(6);
      endLngController.text = point.longitude.toStringAsFixed(6);
      updateMarkers();
    });

    await drawRoute();
  }

  // Hàm hiển thị Popup khi bấm vào Marker
  void _showMarkerInfo(String title, String address, LatLng point) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(
                title == 'Điểm bắt đầu' ? Icons.my_location : Icons.location_on,
                color: title == 'Điểm bắt đầu' ? Colors.blue : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Địa chỉ: ${address.isNotEmpty ? address : 'Đang tải...'}"),
              const SizedBox(height: 8),
              Text(
                "Tọa độ: ${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}",
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Đóng"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  // Thêm vào trong class LoadMapState trong loadmap.dart
  Future<void> searchLocation(String address) async {
    setState(() => isLoadingRoute = true);
    try {
      final LatLng? result = await searchAddress(address);
      if (!mounted) return;

      if (result != null) {
        final name = await getPlaceName(result);
        setState(() {
          startPoint = result;
          startPlaceName = name;
          // Tự động cập nhật tọa độ vào các ô nhập liệu trong Drawer
          startLatController.text = result.latitude.toStringAsFixed(6);
          startLngController.text = result.longitude.toStringAsFixed(6);

          // Reset đường đi cũ khi tìm vị trí mới
          endPoint = null;
          routePoints = [];
          routeInfo = '';
          updateMarkers();
        });
        mapController.move(result, 16);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không tìm thấy địa chỉ: $address')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoadingRoute = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Center(
        child: Text(errorMessage!, style: const TextStyle(fontSize: 16)),
      );
    }

    if (currentPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: currentPosition!,
            initialZoom: 16,
            onTap: (tapPosition, point) => onMapTap(point),
          ),
          children: [
            TileLayer(
              urlTemplate: isSatellite
                  ? 'https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}'
                  : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.map',
              maxZoom: 19,
            ),
            if (routePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: routePoints,
                    strokeWidth: 5,
                    color: Colors.blue,
                  ),
                ],
              ),
            MarkerLayer(markers: markers),
          ],
        ),

        Positioned(
          right: 16,
          top: 80,
          child: Column(
            children: [
              // 1. NÚT CHUYỂN ĐỔI BẢN ĐỒ (MỚI THÊM)
              FloatingActionButton(
                backgroundColor: Colors.white,
                mini: true,
                heroTag: 'map_layer',
                onPressed: () {
                  setState(() {
                    isSatellite = !isSatellite; // Đảo ngược trạng thái
                  });
                },
                // Nếu đang là vệ tinh thì hiện icon Map mặc định, ngược lại hiện icon Vệ tinh
                child: Icon(
                  isSatellite ? Icons.map : Icons.satellite_alt,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),

              // 2. Nút Phóng to (+)
              FloatingActionButton(
                backgroundColor: Colors.white,
                mini: true,
                heroTag: 'zoom_in',
                onPressed: () {
                  final center = mapController.camera.center;
                  final zoom = mapController.camera.zoom;
                  mapController.move(center, zoom + 1);
                },
                child: const Icon(Icons.add, color: Colors.black87),
              ),
              const SizedBox(height: 8),

              // 2. Nút Thu nhỏ
              FloatingActionButton(
                backgroundColor: Colors.white,
                mini: true,
                heroTag: 'zoom_out',
                onPressed: () {
                  final center = mapController.camera.center;
                  final zoom = mapController.camera.zoom;
                  mapController.move(center, zoom - 1);
                },
                child: const Icon(Icons.remove, color: Colors.black87),
              ),
              const SizedBox(height: 8),

              // 3. LA BÀN (MỚI THÊM)
              StreamBuilder<MapEvent>(
                stream: mapController
                    .mapEventStream, // Lắng nghe sự kiện xoay bản đồ
                builder: (context, snapshot) {
                  // Lấy góc xoay hiện tại của camera
                  final rotation = mapController.camera.rotation;

                  return FloatingActionButton(
                    backgroundColor: Colors.white,
                    mini: true,
                    heroTag: 'compass',
                    onPressed: () {
                      // Khi bấm vào: Trả góc xoay của bản đồ về 0 (Hướng Bắc)
                      mapController.rotate(0);
                    },
                    child: Transform.rotate(
                      // Chuyển đổi độ (degrees) sang radian để xoay icon ngược lại
                      angle: -rotation * (math.pi / 180),
                      child: const Icon(
                        Icons
                            .navigation, // Dùng icon mũi tên điều hướng làm la bàn
                        color: Colors.red, // Màu đỏ cho mũi tên chỉ hướng Bắc
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

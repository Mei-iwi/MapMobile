import 'package:flutter/material.dart';
import 'package:map/map/loadmap.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey<LoadMapState> mapKey = GlobalKey<LoadMapState>();

  Widget buildInputBox({
    required String label,
    required TextEditingController latController,
    required TextEditingController lngController,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: latController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Latitude',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: lngController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Longitude',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapState = mapKey.currentState;

    return SafeArea(
      child: Scaffold(
        onDrawerChanged: (_) {
          setState(() {});
        },
        appBar: AppBar(
          elevation: 10,
          shadowColor: Colors.black,
          centerTitle: true,
          title: const Text(
            'Map OpenStreetMap',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        drawer: Drawer(
          child: mapState == null
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Tìm đường đi',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        buildInputBox(
                          label: 'Điểm bắt đầu',
                          latController: mapState.startLatCtrl,
                          lngController: mapState.startLngCtrl,
                        ),

                        buildInputBox(
                          label: 'Điểm kết thúc',
                          latController: mapState.endLatCtrl,
                          lngController: mapState.endLngCtrl,
                        ),

                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 4),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: mapState.loadingRoute
                                          ? null
                                          : () async {
                                              await mapState.drawRoute();
                                              if (mounted) setState(() {});
                                            },
                                      icon: const Icon(Icons.alt_route),
                                      label: const Text('Tìm đường'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        await mapState.moveToCurrentLocation();
                                        if (mounted) setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                      ),
                                      label: const Text('Vị trí tôi'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    mapState.clearRoute();
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.clear),
                                  label: const Text('Xóa đường đi'),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Bạn vẫn có thể chạm lên bản đồ để chọn điểm đến',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),

                        if (mapState.startName.isNotEmpty ||
                            mapState.endName.isNotEmpty ||
                            mapState.routeText.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 4),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (mapState.startName.isNotEmpty)
                                  Text('Điểm đi: ${mapState.startName}'),
                                if (mapState.endName.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      'Điểm đến: ${mapState.endName}',
                                    ),
                                  ),
                                if (mapState.routeText.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      mapState.routeText,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 16),

                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: const Text('Cài đặt'),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Thông báo'),
                                  content: const Text('Đang phát triển'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        body: LoadMap(key: mapKey),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 70, right: 20),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
              boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 5)],
            ),
            child: IconButton(
              color: Colors.blue,
              onPressed: () async {
                try {
                  final currentMapState = mapKey.currentState;
                  if (currentMapState == null) {
                    debugPrint('mapKey.currentState == null');
                    return;
                  }

                  await currentMapState.moveToCurrentLocation();

                  if (!mounted) return;

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
                              ? const Center(
                                  child: Text('Không lấy được dữ liệu vị trí'),
                                )
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

                                    Column(
                                      children: [
                                        Text(
                                          sheetMapState.startName.isNotEmpty
                                              ? sheetMapState.startName
                                              : 'Chưa lấy được tên vị trí hiện tại',
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
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
              },
              icon: const Icon(Icons.my_location),
            ),
          ),
        ),
      ),
    );
  }
}

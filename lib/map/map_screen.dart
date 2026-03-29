import 'package:flutter/material.dart';
import 'package:map/map/action/map_history_actions.dart';
import 'package:map/map/action/map_location_actions.dart';
import 'package:map/map/action/map_route_actions.dart';
import 'package:map/map/loadmap.dart';
import 'package:map/map/dialogs/current_location_bottom_sheet.dart';
import 'package:map/map/dialogs/history_location_dialog.dart';
import 'package:map/map/dialogs/setting_dialog.dart';
import 'package:map/map/widgets/map_app_bar.dart';
import 'package:map/map/widgets/map_input_box.dart';
import 'package:map/map/widgets/route_control_panel.dart';
import 'package:map/map/widgets/route_info_card.dart';
import 'package:map/model/database.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey<LoadMapState> mapKey = GlobalKey<LoadMapState>();
  final MyDataBase db = MyDataBase.instance;

  @override
  Widget build(BuildContext context) {
    final mapState = mapKey.currentState;

    return SafeArea(
      child: Scaffold(
        onDrawerChanged: (_) => setState(() {}),
        appBar: buildMapAppBar(),
        drawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.9,
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

                        MapInputBox(
                          label: 'Điểm bắt đầu',
                          latController: mapState.startLatCtrl,
                          lngController: mapState.startLngCtrl,
                        ),

                        MapInputBox(
                          label: 'Điểm kết thúc',
                          latController: mapState.endLatCtrl,
                          lngController: mapState.endLngCtrl,
                        ),

                        RouteControlPanel(
                          mapState: mapState,
                          onDrawRoute: () async {
                            await MapRouteActions.drawRoute(
                              mapState: mapState,
                              onRefresh: () {
                                if (mounted) setState(() {});
                              },
                            );
                          },
                          onMoveToCurrentLocation: () async {
                            await MapLocationActions.moveToCurrentLocation(
                              mapState: mapState,
                              onRefresh: () {
                                if (mounted) setState(() {});
                              },
                            );
                          },
                          onShowHistory: () {
                            showHistoryLocationDialog(
                              context: context,
                              db: db,
                              mapKey: mapKey,
                              onRefresh: () {
                                if (mounted) setState(() {});
                              },
                            );
                          },
                          onSaveRoute: () async {
                            await MapHistoryActions.saveRoute(
                              db: db,
                              mapState: mapState,
                            );
                          },
                          onClearRoute: () {
                            mapState.clearRoute();
                            if (mounted) setState(() {});
                          },
                        ),

                        const SizedBox(height: 8),
                        const Text(
                          'Bạn vẫn có thể chạm lên bản đồ để chọn điểm đến',
                          style: TextStyle(fontSize: 13),
                        ),

                        RouteInfoCard(mapState: mapState),

                        const SizedBox(height: 16),

                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: const Text('Cài đặt'),
                          onTap: () => showSettingDialog(context),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        body: Stack(
          children: [
            // Lớp bản đồ chính
            LoadMap(key: mapKey),

            // Thanh tìm kiếm nổi lên trên
            Positioned(
              top: 15,
              left: 15,
              right: 15,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      hintText: 'Tìm kiếm địa điểm...',
                      prefixIcon: Icon(Icons.search, color: Colors.blue),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        // Gọi hàm searchLocation thông qua mapKey
                        mapKey.currentState?.searchLocation(value.trim());
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
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
                await showCurrentLocationBottomSheet(
                  context: context,
                  mapKey: mapKey,
                );
                if (mounted) setState(() {});
              },
              icon: const Icon(Icons.my_location),
            ),
          ),
        ),
      ),
    );
  }
}

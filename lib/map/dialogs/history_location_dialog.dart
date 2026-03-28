import 'package:flutter/material.dart';
import 'package:map/map/action/map_history_actions.dart';
import 'package:map/map/loadmap.dart';
import 'package:map/model/database.dart';
import 'package:map/model/mylocation.dart';

void showHistoryLocationDialog({
  required BuildContext context,
  required MyDataBase db,
  required GlobalKey<LoadMapState> mapKey,
  required VoidCallback onRefresh,
}) {
  final mapState = mapKey.currentState;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text("Danh sách đã lưu"),
        content: SizedBox(
          width: 500,
          height: 500,
          child: FutureBuilder<List<Mylocation>>(
            future: db.getAllLocation(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Lỗi: ${snapshot.error}"));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Không có dữ liệu"));
              }

              final locations = snapshot.data!;

              return ListView.builder(
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  final item = locations[index];

                  return ListTile(
                    title: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(
                            text: "Từ: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                "(${item.latitudeStart?.toStringAsFixed(5)}, ${item.longitudeStart?.toStringAsFixed(5)})\n",
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                          ),
                          const TextSpan(
                            text: "Đến: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                "(${item.latitudeEnd?.toStringAsFixed(5)}, ${item.longitudeEnd?.toStringAsFixed(5)})",
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        const Text(
                          "Bắt đầu tại:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(item.addressStart ?? "Chưa có địa chỉ bắt đầu"),
                        const SizedBox(height: 4),
                        const Text(
                          "Kết thúc tại:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(item.addressEnd ?? "Chưa có địa chỉ kết thúc"),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await MapHistoryActions.deleteHistoryItem(
                                  db: db,
                                  item: item,
                                );
                                if (!dialogContext.mounted) return;
                                Navigator.of(dialogContext).pop();
                                onRefresh();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text(
                                "Xóa",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: mapState?.loadingRoute == true
                                  ? null
                                  : () async {
                                      await MapHistoryActions.selectHistoryRoute(
                                        mapState: mapState,
                                        item: item,
                                      );
                                      if (!dialogContext.mounted) return;
                                      Navigator.of(dialogContext).pop();
                                      onRefresh();
                                    },
                              icon: const Icon(Icons.alt_route),
                              label: const Text('Tìm đường'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text("Thoát"),
          ),
        ],
      );
    },
  );
}

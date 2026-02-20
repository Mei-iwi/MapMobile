import 'package:flutter/material.dart';
import 'package:map/map/loadmap.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key});

  final GlobalKey<LoadMapState> mapkey = GlobalKey<LoadMapState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black),
      title: 'Map-OpenStreetMap',
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 10,
            shadowColor: Colors.black,
            title: Text(
              "Map OpenStreetMap",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            centerTitle: true,
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.red),
                      Text("Vị trí của tôi"),
                    ],
                  ),
                  onTap: () => {mapkey.currentState?.moveToCurrentLocation()},
                ),
                Builder(
                  builder: (context) {
                    return ListTile(
                      title: Row(
                        children: [Icon(Icons.settings), Text("Cài đặt")],
                      ),
                      onTap: () => {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Thông báo'),
                              content: const Text('Đang phát triển'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Ok"),
                                ),
                              ],
                            );
                          },
                        ),
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          body: LoadMap(key: mapkey),

          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 70, right: 20),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white,

                boxShadow: [BoxShadow(color: Colors.black, blurRadius: 5)],
              ),
              child: IconButton(
                mouseCursor: SystemMouseCursors.click,
                color: Colors.blue,
                onPressed: () {
                  mapkey.currentState?.moveToCurrentLocation();
                },
                icon: Icon(Icons.my_location),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

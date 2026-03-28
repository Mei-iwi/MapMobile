import 'package:flutter/material.dart';

PreferredSizeWidget buildMapAppBar() {
  return AppBar(
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
  );
}

import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFFB67315);

  static const white = Colors.white;
  static const black = Colors.black;

  // warna UI
  static const grey = Color(0xFFD6D6D6);
  static const hintColor = Color(0xFF9E9E9E);

  static const red = Colors.red;
  static const shadow = Colors.black26;

  // STATUS
  static const statusDibuka = Colors.green;
  static const statusDitutup = Colors.red;
  static const statusPending = Colors.orange;

  // gradient globaql
  static const LinearGradient gradient = LinearGradient(
    colors: [primary, white],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

static Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'dibuka':
    case 'diterima':
      return statusDibuka;

    case 'ditutup':
    case 'ditolak':
      return statusDitutup;

    case 'menunggu verifikasi':
    case 'diproses':
    case 'pending':
      return statusPending;

    default:
      return statusPending;
  }
}
}

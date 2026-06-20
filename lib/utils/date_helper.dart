import 'package:cloud_firestore/cloud_firestore.dart';

class DateHelper {
  static String formatTanggal(dynamic date) {
    if (date == null) return "-";

    DateTime d;

    if (date is String) {
      d = DateTime.parse(date);
    } else if (date is Timestamp) {
      d = date.toDate();
    } else {
      return "-";
    }

    const bulan = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];

    return "${d.day} ${bulan[d.month - 1]} ${d.year}";
  }
}

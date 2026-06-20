import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/profil_page.dart';
import 'pages/edit_profil_page.dart';
import 'pages/beasiswa_page.dart';
import 'pages/detail_beasiswa_page.dart';
import 'pages/upload_berkas_page.dart';
import 'pages/pengajuan_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // halaman awal
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/profil': (context) => ProfilPage(),
        '/edit_profil': (context) => EditProfilPage(),
        '/beasiswa': (context) => BeasiswaPage(),
        '/detailbeasiswa': (context) => DetailBeasiswaPage(data: {}),
        '/upload': (context) => UploadBerkasPage(data: {}),
        '/pengajuan': (context) => PengajuanPage(),
      },
    );
  }
}

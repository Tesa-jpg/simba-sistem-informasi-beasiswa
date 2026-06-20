import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'dart:io';

import '../theme/app_colors.dart';
import '../theme/app_textstyle.dart';
import '../utils/date_helper.dart';

class UploadBerkasPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const UploadBerkasPage({super.key, required this.data});

  @override
  State<UploadBerkasPage> createState() => _UploadBerkasPageState();
}

class _UploadBerkasPageState extends State<UploadBerkasPage> {
  Map<String, String> selectedFiles = {};
  Map<String, String> fileNames = {};
  Map<String, dynamic>? mahasiswa;
  bool loadingMahasiswa = true;

  Future<void> kirimPengajuan() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('pengajuan').add({
      'uid': uid,
      'nama': mahasiswa?['nama'],
      'npm': mahasiswa?['npm'],
      'fakultas': mahasiswa?['fakultas'],
      'prodi': mahasiswa?['prodi'],
      'beasiswa_id': widget.data['id'],
      'nama_beasiswa': widget.data['nama'],
      'berkas': selectedFiles,
      'status': 'Menunggu Verifikasi',
      'tanggal_pengajuan': Timestamp.now(),
    });
  }

  @override
  void initState() {
    super.initState();
    getMahasiswa();
  }

  Future<void> getMahasiswa() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    mahasiswa = doc.data();

    setState(() {
      loadingMahasiswa = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List persyaratan = widget.data['Persyaratan'] ?? [];

    if (loadingMahasiswa) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Column(
        children: [
          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: AppColors.gradient),
            child: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: AppColors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  Text("Pendaftaran Beasiswa", style: AppTextStyle.header),
                ],
              ),
            ),
          ),

          /// BODY
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// INFO BEASISWA
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.grey,
                          backgroundImage:
                              widget.data['foto'] != null &&
                                  widget.data['foto'].toString().isNotEmpty
                              ? NetworkImage(widget.data['foto'])
                              : null,
                          child:
                              widget.data['foto'] == null ||
                                  widget.data['foto'].toString().isEmpty
                              ? Icon(Icons.school, color: AppColors.primary)
                              : null,
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.data['nama'] ?? "-",
                                style: AppTextStyle.tittlecard,
                              ),

                              const SizedBox(height: 5),

                              Text(
                                "Status: ${widget.data['status'] ?? '-'}",
                                style: AppTextStyle.small.copyWith(
                                  color: AppColors.getStatusColor(
                                    widget.data['status'] ?? '',
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                widget.data['deadline'] is Timestamp
                                    ? "Deadline: ${DateHelper.formatTanggal((widget.data['deadline'] as Timestamp).toDate().toString())}"
                                    : "Deadline: ${widget.data['deadline'] ?? '-'}",
                                style: AppTextStyle.small,
                              ),

                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Data Mahasiswa", style: AppTextStyle.tittlecard),

                        const SizedBox(height: 10),

                        Text("Nama : ${mahasiswa?['nama'] ?? '-'}"),
                        Text("NPM : ${mahasiswa?['npm'] ?? '-'}"),
                        Text("Fakultas : ${mahasiswa?['fakultas'] ?? '-'}"),
                        Text("Program Studi : ${mahasiswa?['prodi'] ?? '-'}"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  Center(
                    child: Text(
                      "Berkas Persyaratan",
                      style: AppTextStyle.tittlecard,
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// LIST PERSYARATAN
                  ...persyaratan.map((item) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.toString(), style: AppTextStyle.small),

                        const SizedBox(height: 8),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shadow,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () async {
                              try {
                                FilePickerResult? result = await FilePicker
                                    .platform
                                    .pickFiles(
                                      type: FileType.any,
                                      withData: true,
                                    );

                                if (result == null) return;

                                final fileName = result.files.single.name;

                                final ref = FirebaseStorage.instance
                                    .ref()
                                    .child("berkas")
                                    .child(
                                      "${FirebaseAuth.instance.currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}_$fileName",
                                    );

                                if (kIsWeb) {
                                  final bytes = result.files.single.bytes;

                                  if (bytes == null) {
                                    throw Exception("File tidak terbaca");
                                  }

                                  print("Pilih file berhasil");

                                  print("Mulai upload");

                                  await ref.putData(bytes);

                                  print("Upload selesai");
                                } else {
                                  final path = result.files.single.path;

                                  if (path == null) {
                                    throw Exception("Path file kosong");
                                  }

                                  await ref.putFile(File(path));
                                }

                                final downloadUrl = await ref.getDownloadURL();
                                print(downloadUrl);

                                setState(() {
                                  selectedFiles[item.toString()] = downloadUrl;
                                  fileNames[item.toString()] = fileName;
                                });

                                print("selectedFiles = $selectedFiles");
                                print("fileNames = $fileNames");

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "$fileName berhasil diupload",
                                    ),
                                  ),
                                );
                              } catch (e) {
                                print("ERROR UPLOAD = $e");

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Upload gagal: $e")),
                                );
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.attach_file,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    fileNames[item.toString()] ??
                                        "Klik untuk memilih file",
                                    style: AppTextStyle.small,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.upload_file,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),
                      ],
                    );
                  }).toList(),

                  const SizedBox(height: 20),

                  /// BUTTON KIRIM
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        print("selectedFiles = $selectedFiles");
                        print("jumlah = ${selectedFiles.length}");
                        if (selectedFiles.length < persyaratan.length) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Semua berkas wajib diupload'),
                            ),
                          );
                          return;
                        }
                        try {
                          print("BERKAS = $selectedFiles");
                          print("JUMLAH = ${selectedFiles.length}");

                          await kirimPengajuan();

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 70,
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      "Pengajuan Berhasil",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Berkas beasiswa berhasil dikirim",
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );

                          await Future.delayed(const Duration(seconds: 2));

                          if (context.mounted) {
                            Navigator.of(context, rootNavigator: true).pop();
                          }

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Error: $e')));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Kirim",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Divider(),

                  const SizedBox(height: 10),

                  Center(
                    child: Column(
                      children: [
                        Text("© 2026 SIMBA", style: AppTextStyle.small),
                        Text(
                          "Fakultas Komunikasi & Informasi",
                          style: AppTextStyle.small,
                        ),
                        Text("Versi 1.0", style: AppTextStyle.small),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

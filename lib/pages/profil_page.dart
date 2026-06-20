import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:html' as html;

import '../theme/app_colors.dart';
import '../theme/app_textstyle.dart';
import '../widgets/app_drawer.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  Future<void> pickAndUploadImage(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      /// 🔥 LOADING (BIAR ADA REAKSI)
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Sedang upload...")));
      }

      if (kIsWeb) {
        /// 🌐 WEB
        final uploadInput = html.FileUploadInputElement();
        uploadInput.accept = 'image/*';
        uploadInput.click();

        uploadInput.onChange.first.then((event) async {
          final file = uploadInput.files!.first;

          final reader = html.FileReader();
          reader.readAsArrayBuffer(file);

          reader.onLoadEnd.first.then((event) async {
            Uint8List data = reader.result as Uint8List;

            final ref = FirebaseStorage.instance
                .ref()
                .child('foto_profil')
                .child('${user!.uid}.jpg');

            await ref.putData(data);

            String downloadUrl = await ref.getDownloadURL();

            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({'foto': downloadUrl});

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Foto berhasil diperbarui")),
              );
            }
          });
        });
      } else {
        /// 📱 MOBILE
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile == null) return;

        File file = File(pickedFile.path);

        final ref = FirebaseStorage.instance
            .ref()
            .child('foto_profil')
            .child('${user!.uid}.jpg');

        await ref.putFile(file);

        String downloadUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'foto': downloadUrl});

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Foto berhasil diperbarui")),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  Future<void> showLogoutDialog(BuildContext context) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("Konfirmasi"),
          content: const Text("Yakin ingin logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.black,
                backgroundColor: AppColors.grey,
              ),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.white,
                backgroundColor: AppColors.primary,
              ),
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await FirebaseAuth.instance.signOut();

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Berhasil logout")));

        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      drawer: AppDrawer(),
      body: Column(
        children: [
          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: AppColors.gradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                  ),
                  Center(child: Text("PROFIL", style: AppTextStyle.header)),
                ],
              ),
            ),
          ),

          /// CONTENT
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data =
                    snapshot.data!.data() as Map<String, dynamic>? ?? {};

                String nama = data['nama'] ?? '-';
                String npm = data['npm'] ?? '-';
                String email = data['email'] ?? '-';
                String fakultas = data['fakultas'] ?? '-';
                String prodi = data['prodi'] ?? '-';
                String noHp = data['no_hp'] ?? '-';
                String foto = data['foto'] ?? '';

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: foto.isNotEmpty
                            ? NetworkImage(foto)
                            : const AssetImage(
                                    'assets/images/profile_placeholder.png',
                                  )
                                  as ImageProvider,
                      ),
                      const SizedBox(height: 10),
                      Text(nama, style: AppTextStyle.header),
                      Text(npm, style: AppTextStyle.small),

                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.grey,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            dataRow("Nama", nama),
                            dataRow("NPM", npm),
                            dataRow("Email", email),
                            dataRow("Fakultas", fakultas),
                            dataRow("Program Studi", prodi),
                            dataRow("No. HP", noHp),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.all(14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => pickAndUploadImage(context),
                          child: Text(
                            "Ganti Foto",
                            style: AppTextStyle.small.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.grey,
                            padding: const EdgeInsets.all(14),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/edit_profil');
                          },
                          child: Text(
                            "Edit Data Diri",
                            style: AppTextStyle.small.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red,
                            padding: const EdgeInsets.all(14),
                          ),
                          onPressed: () => showLogoutDialog(context),
                          child: Text(
                            "Logout",
                            style: AppTextStyle.small.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget dataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: AppTextStyle.small)),
          Text(" : ", style: AppTextStyle.small),
          Expanded(child: Text(value, style: AppTextStyle.small)),
        ],
      ),
    );
  }
}

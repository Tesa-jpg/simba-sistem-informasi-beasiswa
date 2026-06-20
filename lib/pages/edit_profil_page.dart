import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../theme/app_colors.dart';
import '../theme/app_textstyle.dart';

class EditProfilPage extends StatefulWidget {
  const EditProfilPage({super.key});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  final namaController = TextEditingController();
  final npmController = TextEditingController();
  final emailController = TextEditingController();
  final noHpController = TextEditingController();

  String? fakultas;
  String? prodi;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    var data = doc.data();

    if (data != null) {
      namaController.text = data['nama'] ?? '';
      npmController.text = data['npm'] ?? '';
      emailController.text = data['email'] ?? '';
      noHpController.text = data['no_hp'] ?? '';
      fakultas = data['fakultas'];
      prodi = data['prodi'];
      setState(() {});
    }
  }

  void updateData() async {
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'nama': namaController.text,
      'npm': npmController.text,
      'email': emailController.text,
      'no_hp': noHpController.text,
      'fakultas': fakultas,
      'prodi': prodi,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Data berhasil disimpan")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(gradient: AppColors.gradient),
            child: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text("Edit Data Diri", style: AppTextStyle.header),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),

          /// BODY
          Expanded(
            child: Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      buildField("Nama Lengkap", namaController),
                      buildField("NPM", npmController),
                      buildField("Email", emailController),
                      buildField("Fakultas", null, value: fakultas),
                      buildField("Program Studi", null, value: prodi),
                      buildField("No. HP", noHpController),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                        ),
                        onPressed: updateData,
                        child: Text(
                          "Simpan",
                          style: AppTextStyle.small.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const Divider(),

          /// FOOTER
          Padding(
            padding: const EdgeInsets.all(12),
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
    );
  }

  Widget buildField(
    String label,
    TextEditingController? controller, {
    String? value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.label),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          style: AppTextStyle.small,
          decoration: InputDecoration(
            hintText: value ?? "Masukkan $label",
            hintStyle: AppTextStyle.small,
            filled: true,
            fillColor: AppColors.grey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

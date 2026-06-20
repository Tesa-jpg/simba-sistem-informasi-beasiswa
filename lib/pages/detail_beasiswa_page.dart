import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../theme/app_textstyle.dart';
import '../utils/date_helper.dart';

import 'upload_berkas_page.dart';

class DetailBeasiswaPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailBeasiswaPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    String nama = data['nama'] ?? "-";
    String status = data['status'] ?? "-";
    String deadline = DateHelper.formatTanggal(data['deadline']);
    String deskripsi = data['deskripsi'] ?? "-";
    String foto = data['foto'] ?? "";

    return Scaffold(
      body: Column(
        children: [
          // HEADER
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
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: AppColors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Text("Detail Beasiswa", style: AppTextStyle.header),
                ],
              ),
            ),
          ),

          // CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// FOTO BULAT TENGAH
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: foto.isNotEmpty
                              ? NetworkImage(foto)
                              : null,
                          backgroundColor: AppColors.white,
                          child: foto.isEmpty
                              ? Icon(
                                  Icons.image,
                                  color: AppColors.primary,
                                  size: 30,
                                )
                              : null,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// NAMA (CENTER)
                    Center(child: Text(nama, style: AppTextStyle.bold)),

                    const SizedBox(height: 20),

                    /// DESKRIPSI
                    Text("Deskripsi :", style: AppTextStyle.tittlecard),
                    const SizedBox(height: 5),

                    Text(
                      "Status: $status",
                      style: AppTextStyle.small.copyWith(
                        color: AppColors.getStatusColor(status),
                      ),
                    ),

                    const SizedBox(height: 5),
                    Text(deskripsi, style: AppTextStyle.small),

                    const SizedBox(height: 15),

                    /// PERSYARATAN
                    Text("Persyaratan :", style: AppTextStyle.tittlecard),
                    const SizedBox(height: 5),

                    Text("1. ....................", style: AppTextStyle.small),
                    Text("2. ....................", style: AppTextStyle.small),
                    Text("3. ....................", style: AppTextStyle.small),

                    const SizedBox(height: 15),

                    /// DEADLINE
                    Text("Deadline :", style: AppTextStyle.tittlecard),
                    const SizedBox(height: 5),

                    Text(deadline, style: AppTextStyle.small),
                    const SizedBox(height: 15),

                    /// CATATAN
                    Text("Catatan :", style: AppTextStyle.tittlecard),
                    const SizedBox(height: 5),

                    RichText(
                      text: TextSpan(
                        style: AppTextStyle.small.copyWith(
                          color: AppColors.black,
                        ),
                        children: const [
                          TextSpan(text: "Setelah mendaftar "),
                          TextSpan(
                            text: "Wajib",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: " menekan tombol "),
                          TextSpan(
                            text: "Saya Sudah Mendaftar.",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // BUTTON
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              String tipe = data['tipe'] ?? '';

                              if (tipe == "eksternal") {
                                String link = data['link'] ?? '';

                                if (link.isNotEmpty) {
                                  final Uri url = Uri.parse(link);

                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(
                                      url,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  }
                                }
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        UploadBerkasPage(data: data),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "Daftar",
                              style: AppTextStyle.small.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.grey,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              "Saya Sudah Mendaftar",
                              style: AppTextStyle.small.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Divider(),

          /// FOOTER
          Padding(
            padding: const EdgeInsets.all(10),
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
}

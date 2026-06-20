import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_colors.dart';
import '../theme/app_textstyle.dart';
import '../utils/date_helper.dart';
import '../widgets/app_drawer.dart';

import 'detail_beasiswa_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: Column(
        children: [
          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: AppColors.gradient),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.menu, color: AppColors.black),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  Text("BERANDA", style: AppTextStyle.header),
                  Icon(Icons.notifications, color: AppColors.black),
                ],
              ),
            ),
          ),

          /// BODY CONTENT
          Expanded(
            child: Container(
              color: AppColors.white,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selamat Datang di SIMBA!",
                      style: AppTextStyle.subtitle,
                    ),
                    const Divider(),

                    /// 🔔 NOTIF
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Notifikasi", style: AppTextStyle.tittlecard),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Lihat Semua",
                            style: AppTextStyle.small.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('notifikasi')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }

                        var data = snapshot.data!.docs;

                        if (data.isEmpty) {
                          return emptyState("Belum ada notifikasi");
                        }

                        return Column(
                          children: data.map((doc) {
                            return notifCard(doc['judul'], doc['isi']);
                          }).toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    /// 🎓 BEASISWA
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Beasiswa Aktif", style: AppTextStyle.tittlecard),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/beasiswa');
                          },
                          child: Text(
                            "Lihat Semua",
                            style: AppTextStyle.small.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('beasiswa')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }

                        var data = snapshot.data!.docs;

                        if (data.isEmpty) {
                          return emptyState("Belum ada beasiswa");
                        }

                        return Column(
                          children: data.map((doc) {
                            return beasiswaCard(
                              context,
                              doc.data() as Map<String, dynamic>,
                              doc['nama'],
                              doc['status'],
                              DateHelper.formatTanggal(doc['deadline']),
                              doc['foto'] ?? "",
                            );
                          }).toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // STATUS
                    Text("Status Saya", style: AppTextStyle.tittlecard),
                    const SizedBox(height: 10),

                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('status')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }

                        var data = snapshot.data!.docs;

                        if (data.isEmpty) {
                          return emptyState("Belum ada status");
                        }

                        return Column(
                          children: data.map((doc) {
                            return statusCard(doc['nama'], doc['status']);
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Divider(thickness: 1),

          /// FOOTER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: AppColors.white,
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

  /// NOTIF CARD
  Widget notifCard(String judul, String isi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(judul, style: AppTextStyle.bold),
          const SizedBox(height: 5),
          Text(isi, style: AppTextStyle.small),
        ],
      ),
    );
  }

  // BEASISWA CARD
  Widget beasiswaCard(
    BuildContext context,
    Map<String, dynamic> data,
    String nama,
    String status,
    String deadline,
    String fotoUrl,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
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
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2), // border thickness
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.grey,
                  backgroundImage: fotoUrl.isNotEmpty
                      ? NetworkImage(fotoUrl)
                      : null,
                  child: fotoUrl.isEmpty
                      ? Icon(Icons.image, color: AppColors.primary)
                      : null,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nama, style: AppTextStyle.tittlecard),

                    Text(
                      "Status: $status",
                      style: AppTextStyle.small.copyWith(
                        color: AppColors.getStatusColor(status),
                      ),
                    ),

                    Text("Deadline: $deadline", style: AppTextStyle.small),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // BUTTON FULL WIDTH
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailBeasiswaPage(data: data),
                  ),
                );
              },
              child: Text(
                "Lihat Detail",
                style: AppTextStyle.small.copyWith(color: AppColors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// STATUS CARD
  Widget statusCard(String nama, String status) {
    Color warna = AppColors.getStatusColor(status);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey),
      ),
      child: Column(
        children: [
          Text(nama, style: AppTextStyle.bold),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: warna,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                status,
                style: AppTextStyle.small.copyWith(color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// EMPTY
  Widget emptyState(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: AppTextStyle.small.copyWith(color: AppColors.black),
        ),
      ),
    );
  }
}

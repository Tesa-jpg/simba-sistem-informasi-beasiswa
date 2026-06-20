import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_colors.dart';
import '../theme/app_textstyle.dart';
import '../utils/date_helper.dart';
import '../widgets/app_drawer.dart';

import 'detail_beasiswa_page.dart';
import 'upload_berkas_page.dart';

class BeasiswaPage extends StatefulWidget {
  const BeasiswaPage({super.key});

  @override
  State<BeasiswaPage> createState() => _BeasiswaPageState();
}

class _BeasiswaPageState extends State<BeasiswaPage> {
  String selectedFilter = "Semua";
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
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
                    child: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                  ),
                  Text("Beasiswa", style: AppTextStyle.header),
                ],
              ),
            ),
          ),

          /// 🔍 SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() => searchQuery = value.toLowerCase());
              },
              decoration: InputDecoration(
                hintText: "Cari Beasiswa",
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // FILTER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                filterButton("Semua"),
                const SizedBox(width: 10),
                filterButton("Dibuka"),
                const SizedBox(width: 10),
                filterButton("Ditutup"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('beasiswa')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;
                final filteredDocs = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final nama = (data['nama'] ?? "").toLowerCase();
                  final status = (data['status'] ?? "").toLowerCase();
                  final matchSearch = nama.contains(searchQuery);
                  final matchFilter = selectedFilter == "Semua"
                      ? true
                      : status == selectedFilter.toLowerCase();

                  return matchSearch && matchFilter;
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final data =
                        filteredDocs[index].data() as Map<String, dynamic>;

                    return buildCard(data);
                  },
                );
              },
            ),
          ),

          /// FOOTER
          const Divider(),
          Text("© 2026 SIMBA", style: AppTextStyle.small),
          Text("Fakultas Komunikasi & Informasi", style: AppTextStyle.small),
          Text("Versi 1.0", style: AppTextStyle.small),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  /// 🔘 FILTER BUTTON
  Widget filterButton(String text) {
    bool isActive = selectedFilter == text;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedFilter = text);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.grey,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: AppTextStyle.small.copyWith(
              color: isActive ? AppColors.white : AppColors.black,
            ),
          ),
        ),
      ),
    );
  }

  // CARD
  Widget buildCard(Map<String, dynamic> data) {
    String nama = data['nama'] ?? "-";
    String status = data['status'] ?? "-";
    String deadline = DateHelper.formatTanggal(data['deadline']);
    String foto = data['foto'] ?? "";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.grey,
                  backgroundImage: foto.isNotEmpty ? NetworkImage(foto) : null,
                  child: foto.isEmpty
                      ? Icon(Icons.image, color: AppColors.primary)
                      : null,
                ),
              ),

              const SizedBox(width: 10),

              /// TEXT
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

          const SizedBox(height: 15),

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
}

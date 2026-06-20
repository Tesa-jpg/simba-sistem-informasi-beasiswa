import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_textstyle.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: AppColors.gradient,
            ),
            child: Row(
              children: [
                Image.asset('assets/images/logoSimba.png', width: 50),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "SIMBA\nSistem Informasi & Monitoring Beasiswa",
                    style: AppTextStyle.small.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          ListTile(
            title: Text("Beranda", style: AppTextStyle.subtitle),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          const Divider(),

          ListTile(
            title: Text("Profil", style: AppTextStyle.subtitle),
            onTap: () {
              Navigator.pushNamed(context, '/profil');
            },
          ),
          const Divider(),

          ListTile(
            title: Text("Beasiswa", style: AppTextStyle.subtitle),
            onTap: () {
              Navigator.pushNamed(context, '/beasiswa');
            },
          ),
          const Divider(),

          ListTile(
            title: Text("Pengajuan", style: AppTextStyle.subtitle),
            onTap: () {
              Navigator.pushNamed(context, '/pengajuan');
            },
          ),
          const Divider(),

          ListTile(
            title: Text("Logout", style: AppTextStyle.subtitle),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
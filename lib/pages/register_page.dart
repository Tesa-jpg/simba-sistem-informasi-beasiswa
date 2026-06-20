import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import 'package:simba_app/theme/app_colors.dart';
import 'package:simba_app/theme/app_textstyle.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final namaController = TextEditingController();
  final npmController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController authController = AuthController();
  final namaFocus = FocusNode();
  final npmFocus = FocusNode();
  final usernameFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  bool isHidden = true;

  String? selectedFakultas;
  String? selectedProdi;

  final List<String> fakultasList = ["Fakultas Komunikasi dan Informasi"];

  final Map<String, List<String>> prodiMap = {
    "Fakultas Komunikasi dan Informasi": [
      "Ilmu Komunikasi",
      "Teknologi Informasi",
      "Rekayasa Perangkat Lunak",
      "Rekayasa Sistem Komputer",
    ],
  };

  @override
  void dispose() {
    namaFocus.dispose();
    npmFocus.dispose();
    usernameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND
          Container(
            decoration: const BoxDecoration(gradient: AppColors.gradient),
          ),

          // CONTENT
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset('assets/images/logoSimba.png', height: 100),
                  const SizedBox(height: 10),

                  Text("SIMBA", style: AppTextStyle.title),
                  Text(
                    "Sistem Informasi & Monitoring Beasiswa",
                    style: AppTextStyle.label,
                  ),

                  const SizedBox(height: 20),

                  // CARD
                  Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary, width: 2),
                      color: Colors.white.withOpacity(0.05),
                    ),
                    child: Column(
                      children: [
                        Text("REGISTRASI", style: AppTextStyle.header),
                        const SizedBox(height: 20),

                        CustomTextField(
                          controller: namaController,
                          label: "Nama Lengkap",
                          focusNode: namaFocus,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) {
                            FocusScope.of(context).requestFocus(npmFocus);
                          },
                        ),
                        const SizedBox(height: 10),

                        CustomTextField(
                          controller: npmController,
                          label: "NPM",
                          focusNode: npmFocus,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) {
                            FocusScope.of(context).requestFocus(usernameFocus);
                          },
                        ),
                        const SizedBox(height: 10),

                        /// 🔽 FAKULTAS
                        DropdownButtonFormField<String>(
                          value: selectedFakultas,
                          dropdownColor: Colors.white,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                          ),
                          hint: Text(
                            "Pilih Fakultas",
                            style: AppTextStyle.small,
                          ),
                          style: AppTextStyle.small.copyWith(
                            color: AppColors.black,
                          ),
                          items: fakultasList.map((f) {
                            return DropdownMenuItem(
                              value: f,
                              child: Text(f, style: AppTextStyle.small),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedFakultas = value;
                              selectedProdi = null;
                            });
                          },
                        ),

                        const SizedBox(height: 10),

                        /// 🔽 PRODI
                        DropdownButtonFormField<String>(
                          value: selectedProdi,
                          dropdownColor: Colors.white,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                          ),
                          hint: Text(
                            "Pilih Program Studi",
                            style: AppTextStyle.small,
                          ),
                          style: AppTextStyle.small.copyWith(
                            color: AppColors.black,
                          ),
                          items: selectedFakultas == null
                              ? []
                              : prodiMap[selectedFakultas]!
                                    .map(
                                      (p) => DropdownMenuItem(
                                        value: p,
                                        child: Text(
                                          p,
                                          style: AppTextStyle.small,
                                        ),
                                      ),
                                    )
                                    .toList(),
                          onChanged: (value) {
                            setState(() => selectedProdi = value);
                            FocusScope.of(context).requestFocus(usernameFocus);
                          },
                        ),

                        const SizedBox(height: 10),

                        CustomTextField(
                          controller: usernameController,
                          label: "Username",
                          focusNode: usernameFocus,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) {
                            FocusScope.of(context).requestFocus(emailFocus);
                          },
                        ),
                        const SizedBox(height: 10),

                        CustomTextField(
                          controller: emailController,
                          label: "Email",
                          focusNode: emailFocus,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) {
                            FocusScope.of(context).requestFocus(passwordFocus);
                          },
                        ),
                        const SizedBox(height: 10),

                        CustomTextField(
                          controller: passwordController,
                          label: "Password",
                          isPassword: true,
                          isHidden: isHidden,
                          togglePassword: () {
                            setState(() => isHidden = !isHidden);
                          },

                          focusNode: passwordFocus,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) {
                            authController.register(
                              context,
                              emailController.text.trim(),
                              passwordController.text.trim(),
                              namaController.text,
                              npmController.text,
                              usernameController.text,
                              selectedFakultas ?? "",
                              selectedProdi ?? "",
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        // BUTTON
                        CustomButton(
                          text: "Daftar",
                          onPressed: () {
                            authController.register(
                              context,
                              emailController.text.trim(),
                              passwordController.text.trim(),
                              namaController.text,
                              npmController.text,
                              usernameController.text,
                              selectedFakultas ?? "",
                              selectedProdi ?? "",
                            );
                          },
                        ),

                        const SizedBox(height: 10),

                        // LOGIN
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Sudah punya akun? Login",
                            style: AppTextStyle.small.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        ),
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

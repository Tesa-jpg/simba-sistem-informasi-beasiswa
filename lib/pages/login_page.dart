import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import 'package:simba_app/theme/app_colors.dart';
import 'package:simba_app/theme/app_textstyle.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController authController = AuthController();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
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
                    style: AppTextStyle.subtitle,
                  ),

                  const SizedBox(height: 20),

                  // CARD LOGIN
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
                        Text("LOGIN", style: AppTextStyle.bold),
                        const SizedBox(height: 20),

                        CustomTextField(
                          controller: emailController,
                          label: "Email",
                          focusNode: emailFocus,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) {
                            FocusScope.of(context).requestFocus(passwordFocus);
                          },
                        ),

                        const SizedBox(height: 15),

                        CustomTextField(
                          controller: passwordController,
                          label: "Password",
                          focusNode: passwordFocus,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) {
                            authController.login(
                              context,
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
                          },
                          isPassword: true,
                          isHidden: isHidden,
                          togglePassword: () {
                            setState(() => isHidden = !isHidden);
                          },
                        ),

                        const SizedBox(height: 10),

                        // LUPA SANDI
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "Lupa sandi?",
                              style: AppTextStyle.small.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // BUTTON LOGIN
                        CustomButton(
                          text: "Masuk",
                          onPressed: () {
                            authController.login(
                              context,
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
                          },
                        ),

                        const SizedBox(height: 10),

                        /// 🔥 DAFTAR
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Belum punya akun? Daftar",
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

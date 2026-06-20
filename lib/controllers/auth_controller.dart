import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();

  /// 🔥 POPUP MESSAGE
  void showMessage(
    BuildContext context,
    String message, {
    bool isSuccess = false,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          isSuccess ? "Sukses" : "Error",
          style: TextStyle(color: isSuccess ? Colors.green : Colors.red),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  /// 🔥 LOGIN
  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    if (email.isEmpty || password.isEmpty) {
      showMessage(context, "Email & Password wajib diisi");
      return;
    }

    String? result = await _authService.login(email, password);

    if (result == "success") {
      showMessage(context, "Login berhasil!", isSuccess: true);

      /// kasih delay biar dialog sempat kebaca
      await Future.delayed(const Duration(milliseconds: 500));

      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showMessage(context, result ?? "Terjadi kesalahan");
    }
  }

  /// 🔥 REGISTER
  Future<void> register(
    BuildContext context,
    String email,
    String password,
    String nama,
    String npm,
    String username,
    String fakultas,
    String prodi,
  ) async {
    if (nama.isEmpty ||
        npm.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      showMessage(context, "Semua data wajib diisi");
      return;
    }

    if (password.length < 6) {
      showMessage(context, "Password minimal 6 karakter");
      return;
    }

    String? result = await _authService.register(
      email,
      password,
      nama,
      npm,
      username,
      fakultas,
      prodi,
    );

    if (result == "success") {
      showMessage(context, "Registrasi berhasil!", isSuccess: true);

      await Future.delayed(const Duration(milliseconds: 500));

      Navigator.pushReplacementNamed(context, '/login');
    } else {
      showMessage(context, result ?? "Terjadi kesalahan");
    }
  }
}

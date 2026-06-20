import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //LOGIN
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return "Format email tidak valid";
      } else if (e.code == 'invalid-credential') {
        return "Email atau password salah";
      } else {
        return "Terjadi kesalahan login";
      }
    } catch (e) {
      return "Terjadi error sistem";
    }
  }

  //REGISTER
  Future<String?> register(
    String email,
    String password,
    String nama,
    String npm,
    String username,
    String fakultas,
    String prodi,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'nama': nama,
        'npm': npm,
        'username': username,
        'email': email,
        'fakultas': fakultas,
        'prodi': prodi,

        'no_hp': '',
        'foto': '',

        'created_at': FieldValue.serverTimestamp(),
      });
      print("MASUK AUTH");
      print("UID: $uid");
      print("SIMPAN FIRESTORE...");
      print("DATA BERHASIL MASUK FIRESTORE");

      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "Email sudah terdaftar";
      } else if (e.code == 'weak-password') {
        return "Password terlalu lemah";
      } else if (e.code == 'invalid-email') {
        return "Format email tidak valid";
      } else {
        return e.message;
      }
    } catch (e) {
      return "Terjadi error sistem";
    }
  }
}

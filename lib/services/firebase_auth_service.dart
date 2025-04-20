import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel/ui/widgets/widgets.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  static Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      showToast("Invalid Crendentials");
      return false;
    }
  }
  
  static Future<bool> signUp(String email, String password) async {
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      showToast(e.toString());
      return false;
    }
  }

  static Future<bool> resetPassword(String email) async {
    try{
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    }catch (e) {
      showToast(e.toString());
      return false;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  static Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}

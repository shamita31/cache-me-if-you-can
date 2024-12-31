import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pawcrastinot/helper/helper_function.dart';
import 'package:pawcrastinot/service/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//login
  Future loginWithEmailAndPassword(
      String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message ;
    } 
  }


//register
  Future registerUserWithEmailAndPassword(
      String fullname, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user!;

      if (user != null) {
        await DatabaseService(uid: user.uid)
            .saveUserData(fullname, email, password);
        return true;
      } else {
        return "reg failed";
      }
    } on FirebaseAuthException catch (e) {
      return e.message ?? "unknown";
    } catch (e) {
      return "gen err";
    }
  }

  //signout
  Future signOut() async {
    try {
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveEmailSF("");
      await HelperFunction.saveUserNameSF("");
      await HelperFunction.savePassweord("");
      await firebaseAuth.signOut();
    } catch (e) {
      return "signout err";
    }
  }
}

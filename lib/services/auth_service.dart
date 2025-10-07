import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream para observar mudanças no estado de autenticação
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuário atual
  static User? get currentUser => _auth.currentUser;

  // Login com Google
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // O usuário cancelou o login
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Erro ao fazer login com Google: $e');
      rethrow;
    }
  }

  // Login com Facebook
  static Future<UserCredential?> signInWithFacebook() async {
    try {
      // Trigger the Facebook authentication flow
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (loginResult.status == LoginStatus.success) {
        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential = 
            FacebookAuthProvider.credential(loginResult.accessToken!.token);

        // Sign in to Firebase with the Facebook credential
        return await _auth.signInWithCredential(facebookAuthCredential);
      } else if (loginResult.status == LoginStatus.cancelled) {
        // O usuário cancelou o login
        return null;
      } else {
        throw Exception('Erro ao fazer login com Facebook: ${loginResult.message}');
      }
    } catch (e) {
      print('Erro ao fazer login com Facebook: $e');
      rethrow;
    }
  }

  // Logout
  static Future<void> signOut() async {
    try {
      // Logout do Google
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      
      // Logout do Facebook
      await FacebookAuth.instance.logOut();
      
      // Logout do Firebase
      await _auth.signOut();
    } catch (e) {
      print('Erro ao fazer logout: $e');
      rethrow;
    }
  }

  // Obter dados do usuário
  static Map<String, dynamic>? getUserData() {
    final user = currentUser;
    if (user == null) return null;

    return {
      'uid': user.uid,
      'displayName': user.displayName,
      'email': user.email,
      'photoURL': user.photoURL,
      'emailVerified': user.emailVerified,
      'isAnonymous': user.isAnonymous,
      'providerData': user.providerData.map((info) => {
        'providerId': info.providerId,
        'uid': info.uid,
        'displayName': info.displayName,
        'email': info.email,
        'photoURL': info.photoURL,
      }).toList(),
    };
  }

  // Verificar se o usuário está logado
  static bool isUserLoggedIn() {
    return currentUser != null;
  }

  // Obter provedor de login (Google, Facebook, etc.)
  static String? getLoginProvider() {
    final user = currentUser;
    if (user == null || user.providerData.isEmpty) return null;
    
    final providerId = user.providerData.first.providerId;
    if (providerId.contains('google')) return 'Google';
    if (providerId.contains('facebook')) return 'Facebook';
    return providerId;
  }
}

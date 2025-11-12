import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../utils/app_logger.dart';
import 'revenuecat_service.dart';

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
      final userCredential = await _auth.signInWithCredential(credential);
      
      // CRÍTICO: Identificar usuário no RevenueCat para vincular compras
      await RevenueCatService.instance.identifyUser();
      
      return userCredential;
    } catch (e, stack) {
      AppLogger.error('Erro ao fazer login com Google', error: e, stackTrace: stack);
      rethrow;
    }
  }  // Logout
  static Future<void> signOut() async {
    try {
      // CRÍTICO: Resetar identificação do RevenueCat antes do logout
      await RevenueCatService.instance.resetUser();
      
      // Logout do Google
      await _googleSignIn.signOut();
      
      // Logout do Firebase
      await _auth.signOut();
    } catch (e, stack) {
      AppLogger.error('Erro ao fazer logout', error: e, stackTrace: stack);
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

  // Obter provedor de login (Google)
  static String? getLoginProvider() {
    final user = currentUser;
    if (user == null || user.providerData.isEmpty) return null;
    
    final providerId = user.providerData.first.providerId;
    if (providerId.contains('google')) return 'Google';
    return providerId;
  }
}

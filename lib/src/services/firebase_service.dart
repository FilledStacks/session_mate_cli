import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:session_mate_cli/src/helpers/token_store.dart';
import 'package:session_mate_cli/src/locator.dart';

import 'path_service.dart';

const _webApiKey = String.fromEnvironment(
  'WEB_API_KEY',
  defaultValue: 'USE-FIREBASE-EMULATOR',
);

/// Provides functionality to interact with Firebase
class FirebaseService {
  final _pathService = locator<PathService>();

  late HiveStore _store;
  late FirebaseAuth _auth;

  Future<void> init() async {
    _store = await HiveStore.create(
      path: '${_pathService.configHome.path}/sessionmate',
    );

    _auth = FirebaseAuth.initialize(
      _webApiKey,
      _store,
      useEmulator: _webApiKey == 'USE-FIREBASE-EMULATOR',
    );
  }

  bool get hasToken => _store.hasToken;

  String? get idToken => _store.idToken;

  String? get refreshToken => _store.refreshToken;

  String? get userId => _store.userId;

  DateTime? get expiry => _store.expiry;

  bool get isSignedIn => _auth.isSignedIn;

  Future<User> signIn({required String email, required String password}) async {
    return await _auth.signIn(email, password);
  }

  void signOut() => _auth.signOut();
}

import 'package:firedart/auth/token_store.dart';
import 'package:hive/hive.dart';

/// Stores tokens using a Hive store.
/// Depends on the Hive plugin: https://pub.dev/packages/hive
class HiveStore extends TokenStore {
  static const tokenKey = "auth_token";
  static const authStoreKey = "auth_store";

  static Future<HiveStore> create({required String path}) async {
    Hive.init(path);
    Hive.registerAdapter(TokenAdapter());

    final box = await Hive.openBox(
      authStoreKey,
      compactionStrategy: (entries, deletedEntries) => deletedEntries > 50,
    );

    return HiveStore._internal(box);
  }

  final Box _box;

  HiveStore._internal(this._box);

  @override
  Token? read() => _box.get(tokenKey);

  @override
  void write(Token? token) => _box.put(tokenKey, token);

  @override
  void delete() => _box.delete(tokenKey);
}

class TokenAdapter extends TypeAdapter<Token> {
  @override
  final typeId = 42;

  @override
  void write(BinaryWriter writer, Token obj) => writer.writeMap(obj.toMap());

  @override
  Token read(BinaryReader reader) =>
      Token.fromMap(reader.readMap().map<String, dynamic>(
            (key, value) => MapEntry<String, dynamic>(key, value),
          ));
}

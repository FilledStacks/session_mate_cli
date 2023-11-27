import 'package:hive/hive.dart';

/// Stores telemetry configuration using a Hive store.
/// Depends on the Hive plugin: https://pub.dev/packages/hive
class TelemetryStore {
  static const telemetryKey = "telemetry";
  static const storeKey = "telemetry_store";

  static Future<TelemetryStore> create({required String path}) async {
    Hive.init(path);
    Hive.registerAdapter(TelemetryAdapter());

    final box = await Hive.openBox(
      storeKey,
      compactionStrategy: (entries, deletedEntries) => deletedEntries > 50,
    );

    return TelemetryStore._internal(box);
  }

  final Box _box;

  TelemetryStore._internal(this._box);

  Telemetry? read() => _box.get(telemetryKey, defaultValue: Telemetry());
  // Telemetry? read() {
  //   final telemetry = _box.get(telemetryKey);
  //   for (var v in _box.values) {
  //     print('READ :: v:${v?.toMap()}');
  //   }
  //   return telemetry;
  // }

  Future<void> write(Telemetry? telemetry) async =>
      _box.put(telemetryKey, telemetry);
  // Future<void> write(Telemetry? telemetry) async {
  //   print('WRITE :: telemetry:${telemetry?.toMap()}');
  //   await _box.put(telemetryKey, telemetry);
  //   for (var v in _box.values) {
  //     print('WRITE :: v:${v?.toMap()}');
  //   }
  // }

  void delete() => _box.delete(telemetryKey);
}

class TelemetryAdapter extends TypeAdapter<Telemetry> {
  @override
  final typeId = 50;

  @override
  void write(BinaryWriter writer, Telemetry obj) {
    return writer.writeMap(obj.toMap());
  }

  @override
  Telemetry read(BinaryReader reader) {
    return Telemetry.fromMap(reader.readMap().map<String, dynamic>(
          (key, value) => MapEntry<String, dynamic>(key, value),
        ));
  }
}

class Telemetry {
  final bool isEnabled;
  final bool isFirstRun;

  Telemetry({this.isEnabled = false, this.isFirstRun = true});

  Telemetry.fromMap(Map<String, dynamic> map)
      : this(
          isEnabled: map['isEnabled'],
          isFirstRun: map['isFirstRun'],
        );

  Map<String, dynamic> toMap() => {
        'isEnabled': isEnabled,
        'isFirstRun': isFirstRun,
      };
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/app.dart';
import 'src/utils/constant.dart';

/// Hive Type History (ID)
///
Future<void> initHive() async {
  /// Initialize Adapter

  /// Initialize Box
  await Hive.openBox<bool>(sessionOnboardingHiveKey);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initHive();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
// Map<String, dynamic> toJson() => _$UserModelToJson(this);

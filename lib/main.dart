import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/utils/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Log.i('🚀 [App] SS-Shot 앱 시작');

  await dotenv.load(fileName: '.env');
  Log.i('🚀 [Init] 환경 변수 로드 완료');

  runApp(
    const ProviderScope(
      child: SShotApp(),
    ),
  );

  Log.i('🚀 [Init] Riverpod 초기화 완료');
}

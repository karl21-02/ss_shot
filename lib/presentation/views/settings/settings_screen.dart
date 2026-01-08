import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/utils/logger.dart';
import '../../view_models/home_view_model.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Log.d('⚙️ [Settings] 화면 진입');

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settingsTitle),
      ),
      body: ListView(
        children: [
          // Mock Mode Toggle
          SwitchListTile(
            title: const Text(AppStrings.settingsMockMode),
            subtitle: const Text(AppStrings.settingsMockModeDesc),
            value: kUseMockData,
            onChanged: (value) {
              // In a real app, this would update a setting
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('앱 재시작 필요 (현재는 상수로 설정됨)'),
                ),
              );
            },
            secondary: const Icon(Icons.science_outlined),
          ),

          const Divider(),

          // App Info Section
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text(AppStrings.settingsAbout),
            subtitle: const Text(AppStrings.appDescription),
            onTap: () {
              _showAboutDialog(context);
            },
          ),

          ListTile(
            leading: const Icon(Icons.code),
            title: const Text(AppStrings.settingsVersion),
            subtitle: const Text('1.0.0'),
          ),

          const Divider(),

          // Storage Info
          ListTile(
            leading: const Icon(Icons.storage_outlined),
            title: const Text('저장 공간'),
            subtitle: const Text('OCR 데이터 캐시'),
            trailing: TextButton(
              onPressed: () {
                _showClearCacheDialog(context);
              },
              child: const Text('초기화'),
            ),
          ),

          const Divider(),

          // Developer Options
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '개발자 옵션',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.bug_report_outlined),
            title: const Text('디버그 로그'),
            subtitle: const Text('콘솔에 상세 로그 출력'),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),

          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('갤러리 다시 스캔'),
            subtitle: const Text('모든 스크린샷 재분석'),
            onTap: () {
              ref.read(homeViewModelProvider.notifier).refresh();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('갤러리 스캔 시작')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppStrings.appName,
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2026 SS-Shot',
      children: [
        const SizedBox(height: 16),
        const Text(
          'SS-Shot은 스크린샷을 검색 가능한 데이터로 변환하는 '
          '지능형 유틸리티 앱입니다.\n\n'
          'Privacy-First: 이미지 원본은 절대 서버로 전송하지 않습니다.',
        ),
      ],
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('캐시 초기화'),
        content: const Text('OCR 데이터 캐시를 삭제하시겠습니까?\n다음 실행 시 재분석됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('캐시가 초기화되었습니다')),
              );
            },
            child: const Text('초기화'),
          ),
        ],
      ),
    );
  }
}

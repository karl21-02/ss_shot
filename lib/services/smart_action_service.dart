import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../core/utils/logger.dart';

/// 스마트 액션 타입
enum SmartActionType {
  url,
  accountNumber,
  date,
  phoneNumber,
  email,
}

/// 감지된 스마트 액션 정보
class DetectedAction {
  final SmartActionType type;
  final String value;
  final String displayText;

  const DetectedAction({
    required this.type,
    required this.value,
    required this.displayText,
  });
}

/// 텍스트에서 스마트 액션을 감지하고 실행하는 서비스
class SmartActionService {
  // 정규식 패턴들
  static final _urlRegex = RegExp(
    r'https?://[^\s<>\[\]{}|\\^`"]+',
    caseSensitive: false,
  );

  static final _accountRegex = RegExp(
    r'\d{3,4}[-\s]?\d{2,4}[-\s]?\d{4,6}',
  );

  static final _dateRegex = RegExp(
    r'(\d{4}[-./]\d{1,2}[-./]\d{1,2})|(\d{1,2}[-./]\d{1,2}[-./]\d{2,4})|(\d{1,2}월\s?\d{1,2}일)',
  );

  static final _phoneRegex = RegExp(
    r'(010|011|016|017|018|019)[-\s]?\d{3,4}[-\s]?\d{4}',
  );

  static final _emailRegex = RegExp(
    r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
  );

  /// 텍스트에서 모든 스마트 액션을 감지
  List<DetectedAction> detectActions(String text) {
    final actions = <DetectedAction>[];

    // URL 감지
    for (final match in _urlRegex.allMatches(text)) {
      final url = match.group(0)!;
      actions.add(DetectedAction(
        type: SmartActionType.url,
        value: url,
        displayText: _truncateUrl(url),
      ));
    }

    // 계좌번호 감지
    for (final match in _accountRegex.allMatches(text)) {
      final account = match.group(0)!;
      // URL 내부의 숫자가 아닌 경우만
      if (!_isInsideUrl(text, match.start)) {
        actions.add(DetectedAction(
          type: SmartActionType.accountNumber,
          value: account.replaceAll(RegExp(r'[-\s]'), ''),
          displayText: account,
        ));
      }
    }

    // 날짜 감지
    for (final match in _dateRegex.allMatches(text)) {
      final date = match.group(0)!;
      actions.add(DetectedAction(
        type: SmartActionType.date,
        value: date,
        displayText: date,
      ));
    }

    // 전화번호 감지
    for (final match in _phoneRegex.allMatches(text)) {
      final phone = match.group(0)!;
      actions.add(DetectedAction(
        type: SmartActionType.phoneNumber,
        value: phone.replaceAll(RegExp(r'[-\s]'), ''),
        displayText: phone,
      ));
    }

    // 이메일 감지
    for (final match in _emailRegex.allMatches(text)) {
      final email = match.group(0)!;
      actions.add(DetectedAction(
        type: SmartActionType.email,
        value: email,
        displayText: email,
      ));
    }

    Log.d('🔍 [SmartAction] 감지된 액션: ${actions.length}개');
    return actions;
  }

  bool _isInsideUrl(String text, int position) {
    for (final match in _urlRegex.allMatches(text)) {
      if (position >= match.start && position <= match.end) {
        return true;
      }
    }
    return false;
  }

  String _truncateUrl(String url) {
    if (url.length <= 40) return url;
    return '${url.substring(0, 37)}...';
  }

  /// URL 열기
  Future<bool> openUrl(String url) async {
    Log.i('🌐 [SmartAction] URL 열기 | $url');
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
    } catch (e, s) {
      Log.e('❌ [SmartAction] URL 열기 실패', e, s);
    }
    return false;
  }

  /// 클립보드에 복사
  Future<void> copyToClipboard(String text) async {
    Log.i('📋 [SmartAction] 클립보드 복사 | $text');
    await Clipboard.setData(ClipboardData(text: text));
  }

  /// 전화 걸기
  Future<bool> makeCall(String phoneNumber) async {
    Log.i('📞 [SmartAction] 전화 걸기 | $phoneNumber');
    try {
      final uri = Uri.parse('tel:$phoneNumber');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return true;
      }
    } catch (e, s) {
      Log.e('❌ [SmartAction] 전화 걸기 실패', e, s);
    }
    return false;
  }

  /// 이메일 보내기
  Future<bool> sendEmail(String email) async {
    Log.i('✉️ [SmartAction] 이메일 보내기 | $email');
    try {
      final uri = Uri.parse('mailto:$email');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return true;
      }
    } catch (e, s) {
      Log.e('❌ [SmartAction] 이메일 보내기 실패', e, s);
    }
    return false;
  }

  /// 텍스트 공유
  Future<void> shareText(String text) async {
    Log.i('📤 [SmartAction] 텍스트 공유');
    await Share.share(text);
  }

  /// 이미지 공유
  Future<void> shareImage(String imagePath) async {
    Log.i('📤 [SmartAction] 이미지 공유 | $imagePath');
    await Share.shareXFiles([XFile(imagePath)]);
  }
}

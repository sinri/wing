import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// Since 0.0.3
enum WingLogLevel {
  debug,
  info,
  notice,
  warning,
  error;
}

/// Since 0.0.4
class WingLogger {
  final String topic;

  WingLogger({required this.topic});

  void _log(WingLogLevel level, String message, {int? wrapSize}) {
    var now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    String s = "$formattedDate [$level] {$topic} $message";

    if (level == WingLogLevel.debug) {
      debugPrint(s, wrapWidth: wrapSize);
    } else {
      print(s);
    }
  }

  void debug(String message) {
    _log(WingLogLevel.debug, message);
  }

  void info(String message) {
    _log(WingLogLevel.info, message);
  }

  void notice(String message) {
    _log(WingLogLevel.notice, message);
  }

  void warning(String message) {
    _log(WingLogLevel.warning, message);
  }

  void error(String message) {
    _log(WingLogLevel.error, message);
  }
}

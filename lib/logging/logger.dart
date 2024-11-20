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

/// Since 0.0.3
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

  void debug(WingLogLevel level, String message) {
    _log(WingLogLevel.debug, message);
  }

  void info(WingLogLevel level, String message) {
    _log(WingLogLevel.info, message);
  }

  void notice(WingLogLevel level, String message) {
    _log(WingLogLevel.notice, message);
  }

  void warning(WingLogLevel level, String message) {
    _log(WingLogLevel.warning, message);
  }

  void error(WingLogLevel level, String message) {
    _log(WingLogLevel.error, message);
  }
}

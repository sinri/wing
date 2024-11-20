library SinriWing;

import 'package:sinri_wing/logging/logger.dart';

import 'nyacode/nyacode_helper.dart';

export 'json/json_helper.dart';
export 'network/http_helper.dart';

class Wing {
  /// Since 0.0.3
  static WingLogger createLogger({required String topic}) {
    return WingLogger(topic: topic);
  }

  /// Since 0.0.3
  static NyaCodeHelper getNyaCodeHelper() {
    return NyaCodeHelper();
  }
}

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sinri_wing/nyacode/nyacode_helper.dart';

void main() {
  test('refine', () {
    NyaCodeHelper nyaCode = NyaCodeHelper();

    String s = "Hello, World!啊速度符i哈两岁多发货哦就💰8230rhdsfADSFadsfkhydkf";
    var uint8list = utf8.encode(s);

    var codes = nyaCode.fromBinarySync(uint8list);
    // print("codes: $codes");

    String encoded = nyaCode.encodeToNyaCode(codes);
    // print("Encoded: $encoded");

    String decoded = nyaCode.decodeFromNyaCode(encoded);
    // print("Decoded: $decoded");

    var binary = nyaCode.toBinarySync(decoded);
    var result = utf8.decode(binary);
    // print("fin: $result");

    assert(s == result);
  });
}

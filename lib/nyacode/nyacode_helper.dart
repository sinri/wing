import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

class NyaCodeHelper {
  final String dict =
      "-ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz.";

  /// Since 0.0.7 Async
  Future<String> fromBinary(Uint8List bytes) async {
    return await Isolate.run(() async {
      var s = fromBinarySync(bytes);
      return s;
    });
  }

  String fromBinarySync(Uint8List bytes) {
    // var bytes = await File("path").readAsBytes();
    //String s = "";
    StringBuffer sb = StringBuffer();
    for (var b in bytes) {
      // b belongs to [0,255]
      var p1 = (b & 240) >> 4; // 0b11110000
      var p2 = b & 15; // 0b00001111
      //s += dict[p1] + dict[p2];
      sb.write(dict[p1]);
      sb.write(dict[p2]);
    }
    return sb.toString();
  }

  /// Since 0.0.7 Async
  Future<Uint8List> toBinary(String s) async {
    return await Isolate.run(() async {
      var b = toBinarySync(s);
      return b;
    });
  }

  Uint8List toBinarySync(String s) {
    List<int> elements = [];
    int? buffer;
    var codeUnits = s.codeUnits;
    for (var codeUnit in codeUnits) {
      var c = String.fromCharCode(codeUnit);
      var indexOf = dict.indexOf(c);
      if (buffer == null) {
        buffer = indexOf << 4;
      } else {
        buffer = buffer + indexOf;
        elements.add(buffer);
        buffer = null;
      }
    }
    return Uint8List.fromList(elements);
  }

  /// Since 0.0.7 Async
  Future<String> encodeToNyaCode(String input) async {
    return await Isolate.run(() async {
      var s = encodeToNyaCodeSync(input);
      return s;
    });
  }

  String encodeToNyaCodeSync(String input) {
    String asciiInput = Uri.encodeComponent(input);
    String result = '';
    for (int i = 0; i < asciiInput.length; i++) {
      int x = asciiInput.codeUnitAt(i);
      String c1 = dict[(x & 192) >> 6]; // 192=0b11000000
      String c2 = dict[x & 63]; // 63=0b00111111
      result += c1 + c2;
    }
    return result;
  }

  /// Since 0.0.7 Async
  Future<String> decodeFromNyaCode(String output) async {
    return await Isolate.run(() async {
      var s = decodeFromNyaCodeSync(output);
      return s;
    });
  }

  String decodeFromNyaCodeSync(String output) {
    String result = '';
    for (int i = 0; i < output.length - 1; i += 2) {
      int h = dict.indexOf(output[i]);
      int l = dict.indexOf(output[i + 1]);
      int x = (h << 6) | l;
      result += String.fromCharCode(x);
    }
    return Uri.decodeComponent(result);
  }
}

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eventsource/eventsource.dart';
import 'package:sinri_wing/logging/logger.dart';
import 'package:sinri_wing/wing.dart';

class HttpHelper {
  final String _scheme;
  final String _host;
  final String _pathRoot;

  late WingLogger _logger;

  HttpHelper(this._scheme, this._host, this._pathRoot) {
    _logger = Wing.createLogger(topic: "HttpHelper");
  }

  final Map<String, String> _queryMap = {};
  final Map<String, String> _headerMap = {};

  HttpHelper setHeader(String name, String value) {
    _headerMap[name] = value;
    return this;
  }

  HttpHelper setQuery(String name, String value) {
    _queryMap[name] = value;
    return this;
  }

  Future<Map<String, dynamic>> post(
      String api, Map<String, dynamic> map) async {
    return _postWithClient(api, map);
  }

  Future<Map<String, dynamic>> _postWithClient(
      String api, Map<String, dynamic> map) async {
    HttpClient httpClient = HttpClient();
    var uri = Uri(
      scheme: _scheme,
      host: _host,
      path: _pathRoot + api,
      queryParameters: _queryMap,
    );
    var request = await httpClient.postUrl(uri);
    request.headers.add("content-type", "application/json");
    //使用iPhone的UA
    request.headers.add(
      "user-agent",
      "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1",
    );

    if (_headerMap.isNotEmpty) {
      _headerMap.forEach((key, value) {
        request.headers.add(key, value);
      });
    }

    var postBody = json.encode(map);
    request.add(utf8.encode(postBody));
    _logger.debug('start request api: $uri, post body: $postBody');
    HttpClientResponse response = await request.close();
    _logger.debug('response code is ${response.statusCode}');
    if (response.statusCode != 200) {
      //GibeahHelper.info("api response: status code is ${response.statusCode}");
      throw HttpException("HTTP CODE IS NOT 200", uri: uri);
    }
    var transform = response.transform(utf8.decoder);
    final String raw = await transform.join();
    httpClient.close();
    // log('response raw content is ↓ ');
    // log('${raw.runtimeType}, ${raw.length}, ${raw.characters}');
    // log(raw);

    Map<String, dynamic> respMap = json.decode(raw);
    respMap.forEach((key, value) {
      _logger.debug('resp map[$key] = $value');
    });
    return Future.value(respMap);
  }

  Future sse(
    String api,
    Map<String, dynamic> map,
      eventHandler, {
        Function? onError,
        void Function()? onDone,
      }) async {
    var uri = Uri(
      scheme: _scheme,
      host: _host,
      path: _pathRoot + api,
      queryParameters: _queryMap,
    );
    var postBody = json.encode(map);
    var es = await EventSource.connect(
      uri,
      headers: {"content-type": "application/json"},
      method: "POST",
      body: postBody,
    );
    es.listen((event) {
      eventHandler(event);
    }, onError: (e) {
      log(e.toString());
      if (onError != null) {
        onError(e);
      }
    });
  }

}
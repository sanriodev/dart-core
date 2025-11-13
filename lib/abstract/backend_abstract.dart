import 'dart:async';
import 'package:dart_core/interceptor/auth_interceptor.dart';
import 'package:dart_core/models/settings/settings_model.dart';
import 'package:dart_core/settings/settings.dart';
import 'package:flutter/widgets.dart';
import 'package:http_interceptor/http_interceptor.dart';

abstract class ABackend {
  late InterceptedClient _client;
  late Future<SettingsModel> settings;

  @mustCallSuper
  @protected
  void init() {
    _client = InterceptedClient.build(
      interceptors: [AuthorizationInterceptor()],
      retryPolicy: ExpiredTokenRetryPolicy(),
    );
    settings = Settings().loadSettings();
  }

  Future<Response> post(
    Object? body,
    String path, {
    Map<String, String>? headers = const <String, String>{
      'content-type': 'application/json; charset=utf-8',
    },
  }) async {
    final Uri uri = Uri.parse((await settings).url + path);
    try {
      final Response response = await _client.post(
        uri,
        body: body,
        headers: headers,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @protected
  Future<Response> put(
    Object? body,
    String path, {
    Map<String, String>? headers = const <String, String>{
      'content-type': 'application/json; charset=utf-8',
    },
  }) async {
    final Uri uri = Uri.parse((await settings).url + path);

    try {
      final Response response = await _client.put(
        uri,
        body: body,
        headers: headers,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @protected
  Future<Response> delete(
    String path, {
    Map<String, String>? headers = const <String, String>{
      'content-type': 'application/json; charset=utf-8',
    },
  }) async {
    final Uri uri = Uri.parse((await settings).url + path);

    try {
      final Response response = await _client.delete(uri, headers: headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @protected
  Future<Response> patch(
    Object body,
    String path, {
    Map<String, String>? headers = const <String, String>{
      'content-type': 'application/json; charset=utf-8',
    },
  }) async {
    final Uri uri = Uri.parse((await settings).url + path);

    try {
      final Response response = await _client.patch(
        uri,
        body: body,
        headers: headers,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @protected
  Future<Response> get(
    String path, {
    Map<String, String>? headers = const <String, String>{
      'content-type': 'application/json; charset=utf-8',
    },
  }) async {
    final Uri uri = Uri.parse((await settings).url + path);
    try {
      final Response response = await _client.get(uri, headers: headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

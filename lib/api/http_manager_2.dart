import 'dart:developer';
import 'package:careme24/service/env_service.dart';
import 'package:dio/dio.dart';

class HttpManager2 {
  late Dio _dioClient;

  HttpManager2._privateConstructor() {
    _dioClient = Dio(
      BaseOptions(
        baseUrl: EnvService().openMeteoUrl,
        connectTimeout: const Duration(seconds: 10),
        headers: {},
      ),
    );
  }

  static final HttpManager2 _instance = HttpManager2._privateConstructor();

  static HttpManager2 get instance => _instance;

  Future<dynamic> get(
    String url, {
    required String baseUrl,
    dynamic params,
  }) async {
    try {
      _dioClient.options.baseUrl = baseUrl;

      final response = await _dioClient.get(url, queryParameters: params);
      return response.data;
    } on DioException catch (error) {
      log('GET Error: $error');
      rethrow;
    }
  }

  Future<dynamic> post(
    String url, {
    required String baseUrl,
    dynamic data,
    dynamic params,
  }) async {
    try {
      _dioClient.options.baseUrl = baseUrl;

      final response =
          await _dioClient.post(url, data: data, queryParameters: params);
      return response.data;
    } on DioException catch (error) {
      log('POST Error: $error');
      rethrow;
    }
  }

  Future<dynamic> delete(
    String url, {
    required String baseUrl,
    dynamic data,
    dynamic params,
  }) async {
    try {
      _dioClient.options.baseUrl = baseUrl;

      final response =
          await _dioClient.delete(url, data: data, queryParameters: params);

      return response.data;
    } on DioException catch (error) {
      log('DELETE Error: $error');
      rethrow;
    }
  }

  Future<dynamic> patch(
    String url, {
    required String baseUrl,
    dynamic data,
    dynamic params,
  }) async {
    try {
      _dioClient.options.baseUrl = baseUrl;

      final response =
          await _dioClient.patch(url, data: data, queryParameters: params);
      return response.data;
    } on DioException catch (error) {
      log('PATCH Error: $error');
      rethrow;
    }
  }

  Future<dynamic> put(
    String url, {
    required String baseUrl,
    dynamic data,
    dynamic params,
  }) async {
    try {
      _dioClient.options.baseUrl = baseUrl;

      final response =
          await _dioClient.put(url, data: data, queryParameters: params);
      return response.data;
    } on DioException catch (error) {
      log('Put Error: $error');
      rethrow;
    }
  }
}

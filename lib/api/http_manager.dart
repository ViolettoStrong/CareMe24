import 'dart:developer';
import 'package:careme24/api/api.dart';
import 'package:careme24/service/env_service.dart';
import 'package:careme24/service/token_storage.dart';
import 'package:dio/dio.dart';

class HttpManager {
  late Dio _dio;
  // late String _defaultBaseUrl;

  HttpManager._privateConstructor() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvService().apiUrl,
        connectTimeout: const Duration(seconds: 10),
        headers: {},
      ),
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        if (error.response?.statusCode == 401) {
          try {
            final refreshedToken = await _refreshToken();

            if (refreshedToken != null) {
              TokenManager.saveToken(refreshedToken);
              setToken(refreshedToken);

              final options = error.requestOptions;
              options.headers['Authorization'] = 'Bearer $refreshedToken';
              return handler.resolve(await _dio.fetch(options));
            } else {
              return handler.next(error); // Pass the error along
            }
          } catch (refreshError) {
            return handler.next(error);
          }
        }
        return handler.next(error);
      },
    ));
  }

  Future<String?> _refreshToken() async {
    try {
      final response = await post(Api.refreshEndpoint);

      if (response != null) {
        return response['access_token'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static final HttpManager _instance = HttpManager._privateConstructor();

  static HttpManager get instance => _instance;

  String? _token;

  void setToken(String token) {
    _token = token;
    _dio.options.headers['Authorization'] = 'Bearer $_token';
  }

  // void setBaseUrl(String url) {
  //   _dio.options.baseUrl = url;
  // }

  void resetToken() {
    _token = null;
    _dio.options.headers.remove('Authorization');
    log('Token has been reset');
  }

  // void resetBaseUrl() {
  //   _dio.options.baseUrl = _defaultBaseUrl;
  // }

  Future<dynamic> get(
    String url, {
    // String? customBaseUrl,
    dynamic params,
  }) async {
    try {
      final response = await _dio.get(url, queryParameters: params);
      return response.data;
    } on DioException catch (error) {
      log('GET Error: $error');
      rethrow;
    }
  }

  Future<dynamic> post(
    String url, {
    // String? customBaseUrl,
    dynamic data,
    dynamic params,
  }) async {
    try {
      final response =
          await _dio.post(url, data: data, queryParameters: params);
      return response.data;
    } on DioException catch (error) {
      log('POST Error: $error');
      rethrow;
    }
  }

  /// POST with application/x-www-form-urlencoded body (e.g. for Swagger form params).
  Future<dynamic> postForm(
    String url, {
    required Map<String, dynamic> data,
    dynamic params,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        queryParameters: params,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      return response.data;
    } on DioException catch (error) {
      log('POST Form Error: $error');
      rethrow;
    }
  }

  Future<(dynamic, int)> postWithResponseCode(
    String url, {
    // String? customBaseUrl,
    dynamic data,
    dynamic params,
  }) async {
    try {
      final response =
          await _dio.post(url, data: data, queryParameters: params);
      return (response.data, response.statusCode ?? 0);
    } on DioException catch (error) {
      log('POST Error: $error');
      rethrow;
    }
  }

  Future<dynamic> delete(
    String url, {
    // String? customBaseUrl,
    dynamic data,
    dynamic params,
  }) async {
    try {
      final response =
          await _dio.delete(url, data: data, queryParameters: params);

      return response.data;
    } on DioException catch (error) {
      log('DELETE Error: $error');
      rethrow;
    }
  }

  /// DELETE with application/x-www-form-urlencoded body.
  Future<dynamic> deleteForm(
    String url, {
    required Map<String, dynamic> data,
    dynamic params,
  }) async {
    try {
      final response = await _dio.delete(
        url,
        data: data,
        queryParameters: params,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      return response.data;
    } on DioException catch (error) {
      log('DELETE Form Error: $error');
      rethrow;
    }
  }

  Future<dynamic> patch(
    String url, {
    // String? customBaseUrl,
    dynamic data,
    dynamic params,
  }) async {
    try {
      final response =
          await _dio.patch(url, data: data, queryParameters: params);
      return response.data;
    } on DioException catch (error) {
      log('PATCH Error: $error');
      rethrow;
    }
  }

  Future<dynamic> put(
    String url, {
    // String? customBaseUrl,
    dynamic data,
    dynamic params,
  }) async {
    try {
      final response = await _dio.put(url, data: data, queryParameters: params);
      return response.data;
    } on DioException catch (error) {
      log('Put Error: $error');
      rethrow;
    }
  }
}

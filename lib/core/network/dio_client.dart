import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Ticket: core — shared Dio client with auth interceptor (section 2)
/// Mocked: baseUrl points to a placeholder; swap when the real API is provided.
class DioClient {
  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.uniapp.local/v1',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          // TODO(Gp3-3): plug centralized 401 -> auto-logout + token refresh
          // once the real auth endpoint contract is known.
          handler.next(error);
        },
      ),
    );
  }

  static final DioClient instance = DioClient._internal();
  late final Dio _dio;
  final _storage = const FlutterSecureStorage();

  Dio get dio => _dio;
}

// lib/plugins/dio/api_service.dart

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:smarttravel/plugins/dio/failure.dart';
import 'package:smarttravel/plugins/dio/error_handler.dart';

typedef EitherModel<T> = Either<Failure, T>;

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://charlzdemosystem.site/api/',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ))..interceptors.add(_getInterceptor());

  // Public GET
  static Future<EitherModel<Response>> get(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return right(response);
    } on DioException catch (e) {
      return left(ErrorHandler.handleDio(e));
    }
  }

  // Public POST
  static Future<EitherModel<Response>> post(String endpoint, dynamic data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return right(response);
    } on DioException catch (e) {
      return left(ErrorHandler.handleDio(e));
    }
  }

  static Interceptor _getInterceptor() {
    return InterceptorsWrapper(
      onError: (DioException e, ErrorInterceptorHandler handler) {
        // Could log or display something globally
        return handler.next(e);
      },
    );
  }
}

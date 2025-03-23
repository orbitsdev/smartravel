// lib/plugins/dio/error_handler.dart

import 'package:dio/dio.dart';
import 'package:smarttravel/plugins/dio/failure.dart';
import 'package:flutter/material.dart';

class ErrorHandler {
  static Failure handleDio(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Failure(message: "Request timed out. Please try again later.", exception: exception);
      case DioExceptionType.badResponse:
        return _handleStatusCode(exception);
      case DioExceptionType.cancel:
        return Failure(message: "Request was cancelled.", exception: exception);
      case DioExceptionType.connectionError:
        return Failure(message: "No internet connection.", exception: exception);
      case DioExceptionType.unknown:
      default:
        return Failure(message: exception.message ?? "Something went wrong.", exception: exception);
    }
  }

  static Failure _handleStatusCode(DioException exception) {
    final data = exception.response?.data;
    final message = data is Map && data.containsKey('message') ? data['message'] : "Unexpected error";

    return Failure(
      message: message,
      statusCode: exception.response?.statusCode,
      exception: exception,
    );
  }
}

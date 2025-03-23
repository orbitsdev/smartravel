// lib/plugins/dio/failure.dart

import 'package:dio/dio.dart';

class Failure {
  final DioException? exception;
  final String? message;
  final int? statusCode;

  Failure({
    this.exception,
    this.message,
    this.statusCode,
  });

  void log() {
    print("ERROR: $message | Status Code: $statusCode");
  }
}

// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:aircharge/app/core/constants/enums.dart';
import 'package:aircharge/app/core/constants/strings.dart';
import 'package:aircharge/app/core/constants/urls.dart';
import 'package:aircharge/app/core/utils/device_info_util.dart';
import 'package:aircharge/app/data/models/error_model.dart';
import 'package:dio/dio.dart';

abstract class _BaseApiController {
  late Dio _dio;

  void init({required ApiVersion version}) {
    // final versionString = version.name;

    BaseOptions dioOptions = BaseOptions(
      // connectTimeout: const Duration(microseconds: 45000),
      // receiveTimeout: const Duration(microseconds: 45000),
      baseUrl: URLs.base,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      headers: {
        HttpHeaders.acceptHeader: Headers.jsonContentType,
      },
    );

    _dio = Dio(dioOptions);
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      LogInterceptor(
        error: true,
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
      ),
    );
  }

  ErrorResponse _handleError(DioError error) {
    ErrorResponse errorResponse = ErrorResponse();

    if (error.type == DioErrorType.unknown &&
        error.error != null &&
        error.error is SocketException) {
      errorResponse =
          ErrorResponse(error: Error(detail: 'No Internet Connection'));
    }

    switch (error.type) {
      case DioErrorType.cancel:
        errorResponse = ErrorResponse(
          error: Error(detail: ErrorMessages.somethingWentWrong),
        );
        break;
      case DioErrorType.connectionTimeout:
        errorResponse =
            ErrorResponse(error: Error(detail: ErrorMessages.serverTimeout));
        break;
      case DioErrorType.receiveTimeout:
        errorResponse =
            ErrorResponse(error: Error(detail: ErrorMessages.serverTimeout));
        break;
      case DioErrorType.sendTimeout:
        errorResponse =
            ErrorResponse(error: Error(detail: ErrorMessages.serverTimeout));
        break;
      case DioErrorType.unknown:
        errorResponse =
            ErrorResponse(error: Error(detail: ErrorMessages.noInternet));
        break;
      case DioExceptionType.badCertificate:
        errorResponse = ErrorResponse(
            error: Error(detail: ErrorMessages.somethingWentWrong));
        break;
      case DioExceptionType.connectionError:
        errorResponse =
            ErrorResponse(error: Error(detail: ErrorMessages.serverTimeout));
        break;
      case DioExceptionType.badResponse:
        errorResponse = ErrorResponse(
            error: Error(detail: ErrorMessages.somethingWentWrong));
        break;
    }

    return errorResponse;
  }

  // GET
  Future<Map<String, dynamic>> get({
    required String path,
    Map<String, dynamic>? query,
    String? deviceId,
  }) async {
    try {
      final options = Options(
        headers: {
          'deviceid': DeviceInfoUtil.deviceId,
        },
      );
      final response = await _dio.get(
        path,
        queryParameters: query,
        options: options,
      );

      return response.data;
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  // POST
  Future<Map<String, dynamic>> post({
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: query,
      );
      return response.data;
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }
}

class ApiControllerV1 extends _BaseApiController {
  ApiControllerV1() {
    super.init(version: ApiVersion.v1);
  }
}

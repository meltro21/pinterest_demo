import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pinterest/interceptor/dio_connectivity_request_retrier.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final DioConnectivityRequestRetrier requestRetrier;

  RetryOnConnectionChangeInterceptor({
    required this.requestRetrier,
  });

  @override
  Future<dynamic> onError(DioError err, ErrorInterceptorHandler handler) async {
    print('start onError');
    var val = _shouldRetry(err);
    print(val);
    if (_shouldRetry(err)) {
      try {
        print('inside');
        var res = await requestRetrier.scheduleRequestRetry(err.requestOptions);
        return handler.resolve(res);
      } catch (e) {
        return e;
      }
    }
    print('end onError');
    return err;
  }

  bool _shouldRetry(DioError err) {
    return err.type == DioErrorType.other &&
        err.error != null &&
        err.error is SocketException;
  }
}

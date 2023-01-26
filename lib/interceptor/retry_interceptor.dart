import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pinterest/interceptor/dio_connectivity_request_retrier.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final DioConnectivityRequestRetrier requestRetrier;

  RetryOnConnectionChangeInterceptor({
    required this.requestRetrier,
  });

  @override
  Future<dynamic> onError(DioError err, ErrorInterceptorHandler handler) async {
    //check if error is due to connection
    if (_shouldRetry(err)) {
      try {
        //schedule a retry when conneciton is available
        var res = await requestRetrier.scheduleRequestRetry(err.requestOptions);
        //send the response
        return handler.resolve(res);
      } catch (e) {
        return e;
      }
    }
    return err;
  }

  bool _shouldRetry(DioError err) {
    //check if error is due to connection
    return err.type == DioErrorType.other &&
        err.error != null &&
        err.error is SocketException;
  }
}

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:shared_preferences/shared_preferences.dart';

class DioMiddleware extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('token');

    if (token != null) {
      options.headers.addAll({
        "Authorization": "Bearer $token",
      });
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      getx.Get.toNamed("/login");

      handler.next(err);

      return;
    }

    handler.next(err);
  }
}

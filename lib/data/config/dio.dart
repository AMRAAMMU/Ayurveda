import 'package:ayurveda/data/middlewares/dio_middleware.dart';
import 'package:dio/dio.dart';

class DioInstance {
  DioInstance() {
    addInterceptor(DioMiddleware());
  }

  final Dio dio = Dio();

  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
  }
}
import 'package:dio/dio.dart';
import 'package:meetly/core/api/api_config.dart';
import 'package:meetly/core/api/token/token_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient{
  Dio getDio({bool tokenInterceptor = false}){
    Dio dio = Dio();
    dio.options.baseUrl = '${ApiConfig.BASE_URL}api/';
    if(tokenInterceptor){
      dio.interceptors.add(TokenInterceptor(dio: dio));
    }
    dio.interceptors.add(PrettyDioLogger(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      compact: false
    ));
    return dio;
  }
}
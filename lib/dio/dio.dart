
import 'package:colorfactor/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  // 1) 요청 보낼 때
  //요청이 보내질때마다
  //만약에 요청의 Header에 accessToken: true라는 값이 있다면
  // 실제 토큰을 가져와서 (storage에서) authorization:bearer $token으로
  // 변경한다
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    ///어디에다가 요청을 했는지 어떤 메쏘드를 어디에다가
    print('[REQ][${options.method}]${options.uri}');

    ///ACCESS TOKEN
    if (options.headers['accessToken'] == 'true') {
      //헤더는 삭제를 해주고
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      //실제 토큰으로 대체해준다
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    ///REFRESH TOKEN
    if (options.headers['refreshToken'] == 'true') {
      //헤더는 삭제를 해주고
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      //실제 토큰으로 대체해준다
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    return super.onRequest(options, handler);
  }

  // 2) 응답 받을 때
// 리스폰스는 정상적으로 응답이 왔을 때만 작용하기 때문에 따로 무언가를 해줄 이유는 없다.
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[RES][${response.requestOptions.method}]${response.requestOptions.uri}');
    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을 때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 토큰에 문제가 있을 때 401에러 (status code)
    // 토큰을 재발급 받는 시도를 하고 토큰이 재발급 되면
    // 다시 새로운 토큰을 요청한다.
    print('[ERR][${err.requestOptions.method}]${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    //refresh Token이 없으면
    //당연히 에러를 던진다
    if (refreshToken == null) {
      //핸들러.reject가 에러를 던진다 (err)
      handler.reject(err);
      return;
    }
    //에러가 난게 401이야? 토큰이 잘못된거가 401
    final isStatus404 = err.response?.statusCode == 401;
    //에러가 난 요청이 auth/token 원래 토큰을 받으려고 했던거면 리프레스해
    final isPathRefresh = err.requestOptions.path == '/auth/token';

// 401에러가 나고 토큰을 새로 받는 요청이 아니었따면
    if (isStatus404 && !isPathRefresh) {
      final dio = Dio();

      try {
        //새로 토큰을 발급 받고
        final resp = await dio.post('http://$ip/auth/token',
            options: Options(headers: {
              'authorization': 'Bearer $refreshToken',
            }));

        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;
        //에러있다면 토큰 변경
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
        //요청 재전송
        final response = await dio.fetch(options);

        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.reject(e);
      }
    }
  return handler.reject(err);
  }
}

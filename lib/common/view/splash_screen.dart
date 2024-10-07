import 'package:colorfactor/common/const/colors.dart';
import 'package:colorfactor/common/layout/default_layout.dart';
import 'package:colorfactor/common/view/root_tab.dart';
import 'package:colorfactor/user/view/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../const/data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // deleteToken();
    checkToken();
  }

  void deleteToken() async {
    await storage.deleteAll();
  }

  void checkToken() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final dio = Dio();


    ///토큰을 검증할거야
    try {
      final resp = await dio.post('http://$ip/auth/token',
        options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            }
        ),
        ///토큰이 있다면 루트페이지로 이동을 시키고
      );
      
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => RootTab(),
        ),
            (route) => false,
      );
    } catch (e) {
      ///토큰 검증 과정에서 AccessToken이 만료 또는 어떤 오류가 생겼다면 로그인화면으로 돌려보네
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
            (route) => false,
      );
    }
  }
    @override
    Widget build(BuildContext context) {
      return DefaultLayout(
          backgroundColor: PRIMARY_COLOR,
          child: SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'asset/img/Tennis Court.png',
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 2,
                ),
                const SizedBox(
                  height: 16,
                ),
                CircularProgressIndicator(
                  color: Colors.black,
                )
              ],
            ),
          ));
    }
  }

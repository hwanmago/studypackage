import 'dart:convert';
import 'package:colorfactor/common/component/custom_text_form_field.dart';
import 'package:colorfactor/common/const/colors.dart';
import 'package:colorfactor/common/const/data.dart';
import 'package:colorfactor/common/layout/default_layout.dart';
import 'package:colorfactor/common/view/root_tab.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password ='';

  @override
  Widget build(BuildContext context) {
    ///플러터 안전 스토리지
    final storage = FlutterSecureStorage();
    ///API사용 플러그인
    final dio = Dio();
    //로컬 호스트 local host//


    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 24,
                ),
                _Title(),
                SizedBox(
                  height: 16,
                ),
                _Subtitle(),
                Image.asset(
                  'asset/3d/gps.gif',
                  width: MediaQuery.of(context).size.width / 5 * 4,
                ),
                CustomTextFormField(
                  hinText: '이메일을 입력해주세요.',
                  onChanged: (String value) {
                    username = value;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                CustomTextFormField(
                  hinText: '비밀번호를 입력해주세요.',
                  onChanged: (String value) {
                    password = value;

                  },
                  obscureText: true,
                ),
                SizedBox(
                  height: 16,
                ),

                ///로그인 버튼
                ElevatedButton(
                  onPressed: () async {
                    //ID:비밀번호
                    final rawString = '$username:$password';

                    ///BASE 64 인코딩 방법
                    Codec<String, String> stringToBase64 = utf8.fuse(base64);

                    ///코덱에서 베이스 64로 변환후 아래 RAW string으로 다시 토큰값으로
                    String token = stringToBase64.encode(rawString);

                    final resp = await dio.post(
                      'http://$ip/auth/login',
                      options: Options(
                        headers: {
                          'authorization': 'Basic $token',
                        },
                      ),
                    );

                    ///토큰 값 선언
                    final refreshToken = resp.data['refreshToken'];
                    final accesToken = resp.data['accessToken'];

                    ///스토리지에 저장
                    await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
                    await storage.write(key: ACCESS_TOKEN_KEY, value: accesToken);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RootTab(),
                      ),
                    );

                    print(resp.data);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: Text('로그인'),
                ),

                TextButton(
                  onPressed: () async {

                  },
                  child: Text('회원가입'),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.black.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다.',
      style: TextStyle(
          fontSize: 34, fontWeight: FontWeight.w700, color: Colors.black),
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      '전화번호와 비밀번호를 입력해서 로그인해주세요!\n오늘도 행복한 테니스를 찾아 볼까요!?',
      style: TextStyle(fontSize: 16, color: BODY_TEXT_COLOR),
    );
  }
}

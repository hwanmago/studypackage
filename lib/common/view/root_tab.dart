import 'package:colorfactor/common/const/colors.dart';
import 'package:colorfactor/common/layout/default_layout.dart';
import 'package:colorfactor/restaurant/view/restaurant_screen.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  int index = 0;
///컨트롤러를 선언해주고 Late로 나중에 실행될거라고 지시 한다
  late TabController controller;

  ///이닛스테이트에서 컨트롤러를 실행해주고
  @override
  void initState() {
    super.initState();
    controller = TabController (length: 5, vsync: this);
///컨트롤러에 리스너를 추가해서 탭에 연결시켜준다
    controller.addListener(tabListener);

  }

  @override
  void dispose() {
    ///여기서 리스너를 불러오고 더 불러오지 않는다
    controller.removeListener(tabListener);
    super.dispose();
  }

///텝 리스너를 선언하고 스테이트에 인덱스를 컨트롤러와 연결해준다
  void tabListener(){
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '플레져 플레이',
      child: TabBarView(
        ///상하 스크롤을 위해 스크롤 피직스를 LOCK걸어준다
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
          children: [
            RestaurantScreen(),
            Center(
              child: Container(
                child: Text('캘린더'),
              ),
            ),
            Center(
              child: Container(
                child: Text('테니스여정'),
              ),
            ),
            Center(
              child: Container(
                child: Text('채팅'),
              ),
            ),
            Center(
              child: Container(
                child: Text('마이페이지'),
              ),
            )
          ]
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: PRIMARY_ACTIVE_COLOR,
        unselectedItemColor: PRIMARY_IDLE_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (int index){
          controller.animateTo(index);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 30,),
            // icon: SvgPicture.asset('asset/svg/home.svg',width: 40, height: 40,),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today, size: 30,),
            label: '캘린더',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_tennis, size: 30,),
            label: '테니스 여정',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded, size: 30,),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined, size: 30,),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}

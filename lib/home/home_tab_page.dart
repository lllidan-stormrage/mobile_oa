import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileoa/home/homePage.dart';
import 'package:mobileoa/home/minePage.dart';

/*
@author Alan_Xiong
* @desc: 主页
* @time 2020/6/16 10:03 PM
* */
class HomeNavigationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TabNavigate();
}

class TabNavigate extends State<HomeNavigationPage> {
  //选中下标
  int _currentIndex = 0;

  //page控制器
  var _pageController = new PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[HomePage(), MinePage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          _bottomItem(
              "首页", "images/ic_home_normal.png", "images/ic_home_selected.png", 0),
          _bottomItem('我的', 'images/ic_mine_normal.png',
              'images/ic_mine_selected.png', 1)
        ],
        onTap: (index){
          setState(() {
            _pageController.jumpToPage(index);
            _currentIndex = index;
          });
        },
      ),
    );
  }

  _bottomItem(String title, String normalIcon, String selectIcon, int index) {
    return BottomNavigationBarItem(
        icon: Image.asset(normalIcon, width: 24, height: 24),
        activeIcon: Image.asset(selectIcon, width: 24, height: 24),
        title: Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            title,
            style: TextStyle(
                color: Color(_currentIndex == index ? 0xff000000 : 0xff9a9a9a),
                fontSize: 14),
          ),
        ));
  }
}

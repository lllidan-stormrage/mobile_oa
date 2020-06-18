import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mobileoa/widget/home_fun_card_widget.dart';
import 'package:mobileoa/widget/home_title_zone_widget.dart';

///首页
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              expandedHeight: 200,
              forceElevated: innerBoxIsScrolled,
              title: Text("welcome"),
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                background:
                    Image.asset("images/icon_mountain.png", fit: BoxFit.fill),
              ),
            )
          ];
        },
        body: Container(
          color: Color.fromARGB(1, 135, 137, 140),
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Center(
                  child: Text(
                    "What can i help you?",
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              HomeTitleZoneView("考勤管理"),
              Container(
                  height: 120,
                  child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      HomeFunCardView("签到打卡"),
                      SizedBox(
                        width: 10,
                      ),
                      HomeFunCardView("考勤统计"),
                      SizedBox(
                        width: 10,
                      ),
                      HomeFunCardView("加班"),
                    ],
                  )),
              HomeTitleZoneView("会议管理"),
              Container(
                  height: 120,
                  child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      HomeFunCardView("会议室预定"),
                      SizedBox(
                        width: 10,
                      ),
                      HomeFunCardView("会议记录"),
                      SizedBox(
                        width: 10,
                      ),
                      HomeFunCardView("公告"),
                    ],
                  )),
              HomeTitleZoneView("其他"),
              Container(
                  height: 120,
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return HomeFunCardView("体温记录");
                      })),
            ],
          ),
        ));
  }
}

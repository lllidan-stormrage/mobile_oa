import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mobileoa/db/db_script.dart';
import 'package:mobileoa/ui/heat_record.dart';
import 'package:mobileoa/util/app_util.dart';
import 'package:mobileoa/util/data_helper.dart';
import 'package:mobileoa/widget/home_fun_card_widget.dart';
import 'package:mobileoa/widget/home_title_zone_widget.dart';

///首页
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    initDbExecute();
  }

  void initDbExecute() async {
    int id = await AppUtils.getLoginUserId();
    await DbScript.insertOrUpdateTableSign(id);
    await DbScript.insertOrUpdateTableMeetingRoom();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              pinned: true,
              expandedHeight: 200,
              forceElevated: innerBoxIsScrolled,
              title: Text("welcome",style: TextStyle(fontSize: 17,color: Colors.black87),),
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                background:
                    Image.asset("images/icon_mountain.png", fit: BoxFit.fill),
              ),
            )
          ];
        },
        body: Container(
          color: Color(0xffF5F5F5),
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: CommonDataHelper.agenda.length,
                    itemBuilder: (context, i) {
                      return HomeFunCardView(CommonDataHelper.agenda[i], i, 0);
                    },
                  )),
              HomeTitleZoneView("会议管理"),
              Container(
                  height: 120,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: CommonDataHelper.meeting.length,
                    itemBuilder: (context, i) {
                      return HomeFunCardView(CommonDataHelper.meeting[i], i, 1);
                    },
                  )),
              Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                margin: EdgeInsets.all(25),
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "为疫情防控需要，请每天登记体温",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      RaisedButton(
                        child: Text(
                          "去登记",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Color.fromRGBO(231, 37, 68, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .push(new MaterialPageRoute(builder: (_) {
                            return HeatRecord();
                          }));
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

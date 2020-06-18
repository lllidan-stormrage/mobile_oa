import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: DataHelper.getAgendaList().length,
                    itemBuilder: (context, i) {
                      return HomeFunCardView(DataHelper.getAgendaList()[i]);
                    },
                  )),
              HomeTitleZoneView("会议管理"),
              Container(
                  height: 120,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: DataHelper.getAgendaList().length,
                    itemBuilder: (context, i) {
                      return HomeFunCardView(DataHelper.getMeetingList()[i]);
                    },
                  )),
              Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
                          //todo
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

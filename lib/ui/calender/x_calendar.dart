// Copyright 2019 The rhyme_lph Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:mobileoa/db/dao/sign_dao.dart';
import 'package:mobileoa/model/user_sign.dart';
import 'package:mobileoa/util/app_util.dart';
import 'package:mobileoa/util/date_util.dart';
import 'package:r_calendar/r_calendar.dart';

class XCalendarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _XCalendarWidget();
}

class _XCalendarWidget extends State<XCalendarWidget> {
  RCalendarController controller;
  int mUserId;
  UserSignEntity mSignData = new UserSignEntity(amIsSign: 0, pmIsSign: 0);
  var pmColor;
  var amColor;

  void _getData() async {
    mUserId = await AppUtils.getLoginUserId();
    List<UserSignEntity> datas = await SignDao.getInstance().getSign(
        mUserId,
        controller.selectedDate.year,
        controller.selectedDate.month,
        controller.selectedDate.day);

    setState(() {
      if (datas != null) {
        mSignData = datas[0];
        amColor = mSignData.amIsSign == 0 ? Colors.black26 : Colors.black;
        pmColor = mSignData.pmIsSign == 0 ? Colors.black26 : Colors.black;
      }
    });
  }

  @override
  void initState() {
    controller = RCalendarController.single(selectedDate: DateTime.now());

    _getData();
    super.initState();
    controller.addListener(() {
      _getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "签到日历",
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          iconTheme: IconThemeData(
            color: Colors.black87, //修改颜色
          ),
          brightness: Brightness.light,
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: <Widget>[
            RCalendarWidget(
              controller: controller,
              customWidget: DefaultRCalendarCustomWidget(),
              firstDate: DateTime(1970, 1, 1), //当前日历的最小日期
              lastDate: DateTime(2055, 12, 31), //当前日历的最大日期
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(child: buildCheckDate())
          ],
        ));
  }

  Widget _buildLine() {
    return Container(
      width: 1.0,
      height: 50.0,
      color: Colors.grey.shade400,
    );
  }

  Widget _buildCosLine() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: MediaQuery.of(context).size.width - 120,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }

  Widget buildCheckDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 100,
          child: Column(
            children: <Widget>[
              Text(
                "08:30",
                style: TextStyle(
                    color: amColor, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              _buildLine(),
              Text(
                "18:00",
                style: TextStyle(
                    color: pmColor, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "上班签到",
              style: TextStyle(
                  color: amColor, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              mSignData != null && mSignData.amIsSign == 1
                  ? "签到时间 ${mSignData.amSignTime}"
                  : "暂未签到",
              style: TextStyle(
                color: mSignData != null && mSignData.amIsSign == 1
                    ? Colors.black54
                    : Colors.black26,
                fontSize: 16,
              ),
            ),
            _buildCosLine(),
            Text(
              "下班签到",
              style: TextStyle(
                  color: pmColor, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              mSignData != null && mSignData.pmIsSign == 1
                  ? "签到时间 ${mSignData.pmSignTime}"
                  : "暂未签到",
              style: TextStyle(
                color: mSignData != null && mSignData.pmIsSign == 1
                    ? Colors.black54
                    : Colors.black26,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

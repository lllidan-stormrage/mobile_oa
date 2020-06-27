import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileoa/db/dao/heat_dao.dart';
import 'package:mobileoa/model/heat_entity.dart';
import 'package:mobileoa/util/app_util.dart';
import 'package:mobileoa/util/date_util.dart';

class HeatList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListPage();
}

class _ListPage extends State<HeatList> {
  var mData = new List();
  int userId;
  bool isEmpty = true;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  void _getData() async {
    userId = await AppUtils.getLoginUserId();
    mData = await HeatDao.getInstance().getHeatsByUserId(userId);
    setState(() {
      isEmpty = mData.length <= 0;
      print("mdate = ${mData.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '我的体温记录',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: ListView.builder(
          itemCount: isEmpty ? 1 : mData.length,
          itemBuilder: (context, i) {
            if (isEmpty) {
              return Container(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  "暂无体温记录",
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return _buildMsg(mData[i]);
            }
          }),
    );
  }

  Widget _buildMsg(HeatEntity data) {
    return Container(
      margin: EdgeInsets.only(top: 12, left: 10, right: 10),
      padding: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 10, top: 8, bottom: 8),
            decoration: BoxDecoration(
                color: Color(0xfff5f5f5),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image(
                      image: AssetImage("images/ic_heat_normal.png"),
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("我的体温")
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                      '${DateUtils.getTimeStrByTimeStamp(data.createTime)}'),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Text(
              data.state == 1
                  ? '${data.month}/${data.day} 体温正常'
                  : '${data.month}/${data.day} 体温异常',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Text(
              '上午体温：${data.amHeat},下午体温${data.pmHeat}',
              style: TextStyle(color: Colors.black54),
            ),
          )
        ],
      ),
    );
  }
}

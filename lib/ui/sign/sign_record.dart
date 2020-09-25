import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileoa/db/dao/sign_dao.dart';
import 'package:mobileoa/model/user_sign.dart';
import 'package:mobileoa/util/app_util.dart';

class SignRecord extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignRecordView();
}

class _SignRecordView extends State<SignRecord> {
  List<UserSignEntity> firstSign = new List();
  List<ListItem> mItems = new List();

  @override
  void initState() {
    _getData();
    super.initState();
  }

  void _getData() async {
    var date = DateTime.now();
    int userId = await AppUtils.getLoginUserId();
    firstSign = await SignDao.getInstance()
        .getSignByMonthWithUser(userId, date.year, date.month);
    setState(() {
      if (firstSign != null && firstSign.isNotEmpty) {
        for (int i = 0; i < firstSign.length; i++) {
          print("${firstSign[i].toString()}");
          if (firstSign[i].pmIsSign == 1) {
            //添加
            mItems.add(new MessageItem(
                time: firstSign[i].pmSignTime,
                place: firstSign[i].pmSignPlace,
                state: 2,
                signError: firstSign[i].leaveWorkEarly,
                timeYmd:
                    '${firstSign[i].year}/${firstSign[i].month}/${firstSign[i].day}',
                title: " 下班打卡"));
          }
          if (firstSign[i].amIsSign == 1) {
            mItems.add(new MessageItem(
                time: firstSign[i].amSignTime,
                place: firstSign[i].amSignPlace,
                state: 1,
                signError: firstSign[i].workLate,
                timeYmd:
                    '${firstSign[i].year}/${firstSign[i].month}/${firstSign[i].day}',
                title: "上班打卡"));
          }
        }
      } else {
        mItems.add(EmptyItem("暂无数据"));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的签到记录",
            style: TextStyle(fontSize: 16, color: Colors.black87)),
        iconTheme: IconThemeData(
          color: Colors.black87, //修改颜色
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          // Let the ListView know how many items it needs to build
          itemCount: mItems.length,
          // Provide a builder function. This is where the magic happens! We'll
          // convert each item into a Widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = mItems[index];
            if (item is MessageItem) {
              return _buildMsg(item);
            } else if (item is EmptyItem) {
              return Container(
                  padding: EdgeInsets.only(top: 80),
                  child: Text(
                    item.msg,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ));
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }

  Widget _buildMsg(MessageItem item) {
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
                    Icon(
                      item.state == 1 ? Icons.work : Icons.time_to_leave,
                      color: Colors.blue,
                    ),
                    Text('${item.title}')
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text('${item.time}'),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Text(
              item.signError ? "打卡异常" : '打卡成功',
              style: TextStyle(
                  color: item.signError ? Colors.amber : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Text(
              '${item.timeYmd}日，位于${item.place}打卡',
              style: TextStyle(
                color: item.signError ? Colors.amber : Colors.black54,
              ),
            ),
          )
        ],
      ),
    );
  }
}

abstract class ListItem {}

// A ListItem that contains data to display a heading
class MessageItem implements ListItem {
  final String title;
  final String time;
  final String place;
  final String timeYmd;
  bool signError;
  final int state;

  MessageItem(
      {this.title,
      this.time,
      this.place,
      this.timeYmd,
      this.state,
      this.signError});
}

class EmptyItem implements ListItem {
  final String msg;

  EmptyItem(this.msg);
}

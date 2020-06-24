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
  List<UserSign> firstSign = new List();
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
          print("not null ${firstSign[i].toString()}");
          if (firstSign[i].pmIsSign == 1) {
            //添加
            mItems.add(new MessageItem(
                time: firstSign[i].pmSignTime,
                place: firstSign[i].pmSignPlace,
                title:
                    "${firstSign[i].year}/${firstSign[i].month}/${firstSign[i].day} 下班卡"));
          }
          if (firstSign[i].amIsSign == 1) {
            mItems.add(new MessageItem(
                time: firstSign[i].amSignTime,
                place: firstSign[i].amSignPlace,
                title:
                    "${firstSign[i].year}/${firstSign[i].month}/${firstSign[i].day} 上班卡"));
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
        title: Text("我的签到记录", style: TextStyle(fontSize: 16)),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 15),
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
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            item.title,
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text(item.place),
          SizedBox(
            height: 5,
          ),
          Text(item.time),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Divider(
              height: 1,
              color: Colors.black12,
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

  MessageItem({this.title, this.time, this.place});
}

class EmptyItem implements ListItem {
  final String msg;

  EmptyItem(this.msg);
}

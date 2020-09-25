import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileoa/db/dao/Memo_dao.dart';
import 'package:mobileoa/model/memo.dart';
import 'package:mobileoa/util/app_util.dart';
import 'package:mobileoa/util/date_util.dart';

import 'add_memo.dart';

class MemoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MemoPage();
}

class _MemoPage extends State<MemoPage> {
  var nowTime = DateTime.now();
  var mData = new List();
  bool isEmpty = false;
  bool isFirst = true;

  @override
  void initState() {
    super.initState();
    _getData();
    isFirst = false;
  }

  void _getData() async {
    int userId = await AppUtils.getLoginUserId();
    mData = await MemoDao.getInstance().getRecords(userId, nowTime.year);
    setState(() {
      isEmpty = mData.length > 0 ? false : true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("我的备忘录",
            style: TextStyle(fontSize: 16, color: Colors.black87)),
        iconTheme: IconThemeData(
          color: Colors.black87, //修改颜色
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () {
              //跳转
              _toAddPage();
            },
          )
        ],
      ),
      body: Container(
        child: ListView.builder(
            itemCount: isEmpty ? 1 : mData.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, i) {
              if (isEmpty) {
                return Container(
                    padding: EdgeInsets.only(top: 50),
                    child: Text(
                      "暂无备忘录信息，点击右上+角添加",
                      textAlign: TextAlign.center,
                    ));
              } else {
                return _buildMsg(mData[i]);
              }
            }),
      ),
    );
  }

  void _toAddPage({bool mark = false, MemoEntity data}) async {
    bool result =
        await Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
      return AddMemoPage(
        showMark: mark,
        mData: data,
      );
    }));
    if (result != null && result) {
      _getData();
    }
  }

  Widget _buildMsg(MemoEntity data) {
    return GestureDetector(
      onTap: () => _toAddPage(mark: true, data: data),
      child: Container(
        margin: EdgeInsets.only(top: 12, left: 10, right: 10),
        padding: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Stack(
          alignment: Alignment(0, 0),
          children: <Widget>[
            Column(
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
                            Icons.free_breakfast,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("我的备忘录")
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                            '${DateUtils.getTimeStrByTimeStampByTime(data.year, data.month, data.day)}'),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    data.title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    data.desc,
                    style: TextStyle(color: Colors.black54),
                  ),
                )
              ],
            ),
            Positioned(
                top: 40,
                right: 20,
                child: Transform(
                  transform: Matrix4.rotationZ(-0.3),
                  child: Image.asset(
                    "images/icon_done.png",
                    width: data.isOver == 0 ? 0 : 50,
                    height: data.isOver == 0 ? 0 : 50,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileoa/db/dao/heat_dao.dart';
import 'package:mobileoa/model/heat_entity.dart';
import 'package:mobileoa/ui/heat_list.dart';
import 'package:mobileoa/util/app_util.dart';
import 'package:mobileoa/util/common_toast.dart';

///体温登记

class HeatRecord extends StatelessWidget {
  final nowTime = DateTime.now();
  final amHeatController = new TextEditingController();
  final pmHeatController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "体温登记 ${nowTime.month}/${nowTime.day}",
          style: TextStyle(fontSize: 16,color:Colors.black87),

        ),
        iconTheme: IconThemeData(
          color: Colors.black87, //修改颜色
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.receipt,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                return HeatList();
              }));
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            _buildTitle(1),
            SizedBox(
              height: 10,
            ),
            _buildTitle(2),
            Container(
              padding: EdgeInsets.only(top: 30, left: 50, right: 50),
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                textColor: Colors.white,
                child: Text("登记"),
                onPressed: () {
                  _submit(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context) async {
    if (amHeatController.text.length <= 0 ||
        pmHeatController.text.length <= 0) {
      ToastUtils.showError("请输入温度");
      return;
    }
    double am;
    double pm;
    try {
      am = double.parse(amHeatController.text);
      pm = double.parse(pmHeatController.text);
    } catch (e) {
      ToastUtils.showError('请输入正确格式的温度');
      return;
    }

    int userId = await AppUtils.getLoginUserId();
    var heat = new HeatEntity(
        userId: userId,
        amHeat: am,
        pmHeat: pm,
        createTime: DateTime.now().millisecondsSinceEpoch.toString(),
        year: nowTime.year,
        month: nowTime.month,
        day: nowTime.day);
    print(' 大小 ${am > 37.3}');
    if (am > 37.3 || pm > 37.3) {
      heat.state = 2;
    } else {
      heat.state = 1;
    }
    print(heat.toString());
    HeatDao.getInstance().insertOrUpdateAppointment(heat);
    ToastUtils.showSuccess("登记成功");
    Navigator.pop(context);
  }

  Widget _buildTitle(int type) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          RichText(
              text: TextSpan(
                  text: "*",
                  style: TextStyle(color: Colors.red),
                  children: [
                TextSpan(
                    text: type == 1 ? '上午: ' : '下午: ',
                    style: TextStyle(fontSize: 14, color: Colors.black))
              ])),
          Expanded(
            child: TextField(
              controller: type == 1 ? amHeatController : pmHeatController,
              maxLines: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(border: InputBorder.none),
            ),
          )
        ],
      ),
    );
  }
}

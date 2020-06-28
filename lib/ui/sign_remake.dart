import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobileoa/constant.dart';
import 'package:mobileoa/db/dao/remake_sign_dao.dart';
import 'package:mobileoa/model/month.dart';
import 'package:mobileoa/model/remake_sign.dart';
import 'package:mobileoa/util/app_util.dart';
import 'package:mobileoa/util/common_toast.dart';
import 'package:mobileoa/util/date_util.dart';

class SignRemake extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RemakeView();
}

class _RemakeView extends State<SignRemake> {
  TextEditingController _mReasonController = new TextEditingController();
  Month mSelectTime = new Month(year: 0, month: 0);
  int mUserId; //用户id;
  int useCount = 0; //使用的数量

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    var nowTime = DateTime.now();
    mUserId = await AppUtils.getLoginUserId();
    var list = await RemakeSignDao.getInstance()
        .getSignByUser(mUserId, nowTime.year, nowTime.month);

    setState(() {
      if (list != null && list.isNotEmpty) {
        for (int i = 0; i < list.length; i++) {
          print(list[i].toString());
        }
        useCount = list.length;
      } else {
        useCount = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "补卡申请",
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        iconTheme: IconThemeData(
          color: Colors.black87, //修改颜色
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Color(0xffF5F5F5),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(children: <Widget>[
            SizedBox(
              height: 15,
            ),
            _buildTime(),
            SizedBox(
              height: 10,
            ),
            _buildReason(),
            SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                _submit();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                margin: EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(6)),
                child: Center(
                  child: Text(
                    "提交",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget _buildTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.red),
                    children: [
                      TextSpan(
                          text: "补卡时间",
                          style: TextStyle(fontSize: 16, color: Colors.black))
                    ]),
              ),
              GestureDetector(
                onTap: () {
                  _showPicker();
                },
                child: RichText(
                  text: TextSpan(
                      text: mSelectTime.year > 0
                          ? '${mSelectTime.toString()}'
                          : "请选择时间",
                      style: TextStyle(color: Colors.black38),
                      children: [
                        WidgetSpan(
                            child: Image(
                          image: AssetImage("images/ic_right_next.png"),
                        ))
                      ]),
                ),
              )
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 8, left: 10),
            child: Text(
              "本月已申请$useCount次，还剩${Constant.remakeSignTimeCount - useCount}次",
              textAlign: TextAlign.start,
            ))
      ],
    );
  }

  Widget _buildReason() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red),
                children: [
                  TextSpan(
                      text: "补卡理由",
                      style: TextStyle(fontSize: 16, color: Colors.black))
                ]),
          ),
          TextField(
            controller: _mReasonController,
            keyboardType: TextInputType.text,
            maxLines: 8,
            minLines: 4,
            decoration:
                InputDecoration(hintText: "请输入", border: InputBorder.none),
          )
        ],
      ),
    );
  }

  void _submit() async {
    if (mSelectTime.year <= 0 || mSelectTime.month <= 0) {
      ToastUtils.showError("请选择补卡日期");
      return;
    }
    if (_mReasonController.text.length < 5) {
      ToastUtils.showError("原因不能少于5个子");
      return;
    }
    if (useCount >= Constant.remakeSignTimeCount) {
      ToastUtils.showError("本月补卡次数已用完，不能进行补卡");
      return;
    }

    //选择月份，每月补卡限制，需记录
    ReMakeSignEntity sign = new ReMakeSignEntity(
        year: mSelectTime.year,
        month: mSelectTime.month,
        userId: mUserId,
        place: "华东理工大学");

    sign.signTimeStamp = DateUtils.getTimeStamp(mSelectTime).toString();
    int value = await RemakeSignDao.getInstance().insertOrUpdateSign(sign);
    if (value == 0) {
      ToastUtils.showError("补卡成功");
      Navigator.pop(context);
    } else if (value == 1) {
      ToastUtils.showError("不存在记录");
    } else if (value == 2) {
      ToastUtils.showError("当日已全部签到，不需要补卡");
    } else if (value == 3) {
      ToastUtils.showError("补卡时间超过当前时间");
    } else if (value == 4) {
      ToastUtils.showError("下班卡时间应超过上班卡");
    }
  }

  void _showPicker() {
    showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime.now().subtract(new Duration(days: 30)), // 减 30 天
      lastDate: new DateTime.now().add(new Duration(days: 0)), // 加 0 天
    ).then((DateTime val) {
      mSelectTime.year = val.year;
      mSelectTime.month = val.month;
      mSelectTime.day = val.day;
      _showTimePicker();
    }).catchError((err) {});
  }

  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: new TimeOfDay.now(),
    ).then((val) {
      setState(() {
        print('${val.hour}:${val.minute}');
        mSelectTime.hour = val.hour;
        mSelectTime.minute = val.minute;
      });
    }).catchError((err) {
      //取消选择。重置
      mSelectTime = new Month();
    });
  }
}

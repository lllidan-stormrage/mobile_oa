import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileoa/db/dao/appoint_dao.dart';
import 'package:mobileoa/db/dao/user_dao.dart';
import 'package:mobileoa/model/appoint_entity.dart';
import 'package:mobileoa/model/user.dart';
import 'package:mobileoa/util/app_util.dart';
import 'package:mobileoa/util/common_toast.dart';
import 'package:mobileoa/util/date_util.dart';

class AddAppointPage extends StatefulWidget {
  final int roomId;
  final String roomName;
  final int userId;

  const AddAppointPage({Key key, this.roomId, this.roomName, this.userId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddAppointPage();
}

class _AddAppointPage extends State<AddAppointPage> {
  TextEditingController _mTitleController = TextEditingController();
  TextEditingController _mDescController = TextEditingController();
  String mStartTIme;
  String mEndTime;
  var nowTime = DateTime.now();
  UserEntity mUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  void getUser() async {
    mUser = await UserDao.getInstance().getUserEntityById(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '预约',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black87, //修改颜色
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          _buildTime(1),
          SizedBox(
            height: 10,
          ),
          _buildTime(2),
          SizedBox(
            height: 10,
          ),
          _buildTitle(),
          SizedBox(
            height: 10,
          ),
          _buildDesc(),
          SizedBox(
            height: 30,
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
        ],
      ),
    );
  }

  Widget _buildTitle() {
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
                    text: '会议名称：',
                    style: TextStyle(fontSize: 14, color: Colors.black))
              ])),
          Expanded(
            child: TextField(
              controller: _mTitleController,
              maxLines: 1,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(border: InputBorder.none),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTime(int type) {
    var mTime = type == 1 ? mStartTIme : mEndTime;
    return Container(
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
                      text: type == 1 ? '预定开始时间' : '预定结束时间',
                      style: TextStyle(fontSize: 14, color: Colors.black))
                ]),
          ),
          GestureDetector(
            onTap: () {
              _showTimePicker(type);
            },
            child: RichText(
              text: TextSpan(
                  text: mTime != null
                      ? '${DateUtils.getTimeStrByTimeStamp(mTime)}'
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
    );
  }

  Widget _buildDesc() {
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
                      text: "会议描述",
                      style: TextStyle(fontSize: 14, color: Colors.black))
                ]),
          ),
          TextField(
            controller: _mDescController,
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

  //1 startTime ,2 endTime
  void _showTimePicker(int type) {
    showTimePicker(
      context: context,
      initialTime: new TimeOfDay.now(),
    ).then((val) {
      setState(() {
        print('${val.hour}:${val.minute}');
        var dateTime = new DateTime(
            nowTime.year, nowTime.month, nowTime.day, val.hour, val.minute);
        if (type == 1) {
          //开始时间
          if (mEndTime != null) {
            if (Comparable.compare(
                    mEndTime, dateTime.millisecondsSinceEpoch.toString()) <=
                0) {
              ToastUtils.showError("开始时间必须小于截止时间");
              return;
            }
          }
          if (DateTime.now().millisecondsSinceEpoch >=
              dateTime.millisecondsSinceEpoch) {
            ToastUtils.showError("开始时间必须大于当前时间");
            return;
          }
          mStartTIme = (dateTime.millisecondsSinceEpoch).toString();
        } else {
          //结束时间
          if (Comparable.compare(mStartTIme != null ? mStartTIme : "0",
                  dateTime.millisecondsSinceEpoch.toString()) >=
              0) {
            ToastUtils.showError("截止时间必须大于开始时间");
            return;
          }
          mEndTime = (dateTime.millisecondsSinceEpoch).toString();
        }
      });
    }).catchError((err) {
      //取消选择。重置
    });
  }

  void _submit() async {
    if (mStartTIme == null || mEndTime == null) {
      ToastUtils.showError("请选中会议时间");
      return;
    }
    if (_mTitleController.text.length <= 0) {
      ToastUtils.showError("请输入标题");
      return;
    }
    if (_mDescController.text.length <= 0) {
      ToastUtils.showError("请输入会议的描述");
      return;
    }
    MeetingAppointmentEntity appoint = new MeetingAppointmentEntity(
        roomId: widget.roomId,
        appointUseId: mUser.id,
        year: nowTime.year,
        month: nowTime.month,
        day: nowTime.day,
        startTime: mStartTIme,
        endTime: mEndTime,
        meetingDesc: _mDescController.text,
        appointUserName: mUser.name,
        roomName: widget.roomName,
        state: 0,
        meetingTitle: _mTitleController.text);

    int value = await AppointmentDao.getInstance().insertAppointment(appoint);
    if (value == 0) {
      ToastUtils.showSuccess("预约成功");
      Navigator.pop(context, true);
    } else {
      ToastUtils.showError("预约时间冲突");
    }
  }
}

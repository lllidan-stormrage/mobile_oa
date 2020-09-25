import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileoa/db/dao/appoint_dao.dart';
import 'package:mobileoa/db/dao/user_dao.dart';
import 'package:mobileoa/model/appoint_entity.dart';
import 'package:mobileoa/model/user.dart';
import 'package:mobileoa/ui/meeting/meeting_add.dart';
import 'package:mobileoa/util/app_util.dart';
import 'package:mobileoa/util/date_util.dart';

class MeetingAppointment extends StatefulWidget {
  final String roomName;
  final int roomId;

  MeetingAppointment({Key key, this.roomId, this.roomName}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppointmentView(roomId, roomName);
}

class _AppointmentView extends State<MeetingAppointment> {
  final String roomName;
  final int roomId;

  UserEntity mUser;
  List<MeetingAppointmentEntity> mData = new List();

  _AppointmentView(this.roomId, this.roomName);

  var nowTime = DateTime.now();
  bool isEmpty = false;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  void _getData() async {
    int userId = await AppUtils.getLoginUserId();
    mUser = await UserDao.getInstance().getUserEntityById(userId);
    mData = await AppointmentDao.getInstance().getAppointments(
        nowTime.year, nowTime.month, nowTime.day, roomId,
        state: 0);
    setState(() {
      if (mData.isNotEmpty && mData.length > 0) {
        print(mData.toString());
        isEmpty = false;
      } else {
        isEmpty = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            roomName,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          iconTheme: IconThemeData(
            color: Colors.black87, //修改颜色
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: () async {
                var bool = await Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (_) {
                  return AddAppointPage(
                    roomId: roomId,
                    roomName: roomName,
                    userId: mUser.id,
                  );
                }));
                if (bool != null && bool) {
                  _getData();
                }
              },
            )
          ],
          brightness: Brightness.light,
          backgroundColor: Colors.white,
        ),
        body: Container(
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: isEmpty ? 1 : mData.length,
              itemBuilder: (context, i) {
                if (isEmpty) {
                  return Container(
                      padding: EdgeInsets.only(top: 100),
                      child: Text(
                        "当前会议室暂未预定，请点击右上角 + 开始预定",
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ));
                } else {
                  return _buildMsg(
                      "${nowTime.year}/${nowTime.month}/${nowTime.day}",
                      mData[i]);
                }
              }),
        ));
  }

  Widget _buildMsg(String date, MeetingAppointmentEntity data) {
    return GestureDetector(
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
                            Icons.location_city,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text('${data.meetingTitle}')
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text('$date'),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    "预约人：${data.appointUserName}", //预约人
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    '${DateUtils.getTimeOnlyHourMinutesStrByTimeStamp(data.startTime)} - ${DateUtils.getTimeOnlyHourMinutesStrByTimeStamp(data.endTime)}',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    '${data.meetingDesc}',
                    style: TextStyle(color: Colors.black54),
                  ),
                )
              ],
            ),
            Positioned(
                top: 80,
                right: 30,
                child: Transform(
                  transform: Matrix4.rotationZ(-0.3),
                  child: Text(
                    getStateText(data),
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black45,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  String getStateText(MeetingAppointmentEntity data) {
    if (Comparable.compare(
                int.parse(data.startTime), nowTime.millisecondsSinceEpoch) <=
            0 &&
        Comparable.compare(
                int.parse(data.endTime), nowTime.millisecondsSinceEpoch) >=
            0) {
      return '进行中';
    } else if (Comparable.compare(
                int.parse(data.startTime), nowTime.millisecondsSinceEpoch) <=
            0 &&
        Comparable.compare(
                int.parse(data.endTime), nowTime.millisecondsSinceEpoch) <=
            0) {
      return '已结束';
    } else {
      return '待开始';
    }
  }
}

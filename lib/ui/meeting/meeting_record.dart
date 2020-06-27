import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileoa/db/dao/appoint_dao.dart';
import 'package:mobileoa/model/appoint_entity.dart';
import 'package:mobileoa/util/app_util.dart';
import 'package:mobileoa/util/date_util.dart';

class MeetingRecord extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecordView();
}

class _RecordView extends State<MeetingRecord> {
  var nowTime = DateTime.now();
  var mData = new List();
  bool isEmpty = false;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  void _getData() async {
    int userId = await AppUtils.getLoginUserId();
    mData = await AppointmentDao.getInstance()
        .getAppointmentsByMonth(nowTime.year, nowTime.month, userId);
    setState(() {
      isEmpty = mData.length > 0 ? false : true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "本月我的会议记录",
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: ListView.builder(
            itemCount: isEmpty ? 1 : mData.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, i) {
              if (isEmpty) {
                return Container(
                    padding: EdgeInsets.only(top: 50),
                    child: Text(
                      "本月暂无会议记录",
                      textAlign: TextAlign.center,
                    ));
              } else {
                return _buildMsg(mData[i]);
              }
            }));
  }

  Widget _buildMsg(MeetingAppointmentEntity data) {
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
                      Icons.location_city,
                      color: Colors.blue,
                    ),
                    Text('${data.roomName}')
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text('${DateUtils.getTimeStrByTimeStamp(data.startTime)} - ${DateUtils.getTimeStrByTimeStamp(data.endTime)}'),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Text(
              '${data.meetingTitle}',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
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
    );
  }

}

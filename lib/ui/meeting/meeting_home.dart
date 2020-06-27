import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileoa/db/dao/meeting_room_dao.dart';
import 'package:mobileoa/model/meeting_room.dart';
import 'package:mobileoa/ui/meeting/meeting_appointment.dart';

class MeetingHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MeetingTablePage();
}

class _MeetingTablePage extends State<MeetingHome> {
  List<MeetingRoomEntity> mRooms = List();
  bool hasRooms = false;

  @override
  void initState() {
    _getDefaultData();
    super.initState();
  }

  void _getDefaultData() async {
    mRooms = await MeetingRoomDao.getInstance().getRooms();
    setState(() {
      hasRooms = mRooms.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "会议预定",
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: Visibility(
              visible: hasRooms,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  physics: BouncingScrollPhysics(),
                  itemCount: mRooms.length,
                  itemBuilder: (context, i) {
                    return _buildRoom(mRooms[i]);
                  })),
        ));
  }

  Widget _buildRoom(MeetingRoomEntity room) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) =>
                  MeetingAppointment(roomId: room.id, roomName: room.name)),
        );
      },
      child: Container(
        color: Colors.white,
        child: Stack(
          alignment: Alignment(0, 0),
          children: <Widget>[
            Transform(
              child: Text(
                room.name,
                style: TextStyle(fontSize: 20, color: Color(0xfff5f5f5)),
              ),
              transform: Matrix4.rotationZ(0.3),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Transform(
                child: Text(
                  room.name,
                  style: TextStyle(fontSize: 20, color: Color(0xfff5f5f5)),
                ),
                transform: Matrix4.rotationZ(0.3),
              ),
            ),
            Positioned(
              bottom: 18,
              right: 1,
              child: Transform(
                child: Text(
                  room.name,
                  style: TextStyle(fontSize: 20, color: Color(0xfff5f5f5)),
                ),
                transform: Matrix4.rotationZ(0.3),
              ),
            ),
            Positioned(
              bottom: 28,
              left: 10,
              child: Transform(
                child: Text(
                  room.name,
                  style: TextStyle(fontSize: 20, color: Color(0xfff5f5f5)),
                ),
                transform: Matrix4.rotationZ(0.3),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Transform(
                child: Text(
                  room.name,
                  style: TextStyle(fontSize: 20, color: Color(0xfff5f5f5)),
                ),
                transform: Matrix4.rotationZ(0.3),
              ),
            ),
            Positioned(
              top: 30,
              child: Text(
                room.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              bottom: 30,
              child: Text(
                "楼层：${room.floor}楼",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MeetingAppointmentEntity {
  int id;
  int year;
  int month;
  int day;
  int roomId; //会议室id
  String startTime;
  String endTime;
  int appointUseId;
  String appointUserName;
  String meetingTitle; //会议标题
  String meetingDesc; //会议描述
  String roomName; //会议室名称
  int state = 0; //0正常，1 取消


  //don't save
  bool show = false;

  MeetingAppointmentEntity(
      {this.id,
      this.year,
      this.month,
      this.day,
      this.roomId,
      this.startTime,
      this.endTime,
      this.appointUseId,
      this.appointUserName,
      this.meetingDesc,
      this.meetingTitle,
      this.roomName,
      this.state});


  Map<String, dynamic> toMap(MeetingAppointmentEntity appoint) {
    return {
      "id": appoint.id,
      "appointUseId": appoint.appointUseId,
      "year": appoint.year,
      "day": appoint.day,
      "month": appoint.month,
      "startTime": appoint.startTime,
      "endTime": appoint.endTime,
      "meetingTitle": appoint.meetingTitle,
      "meetingDesc": appoint.meetingDesc,
      "roomId": appoint.roomId,
      'appointUserName': appoint.appointUserName,
      'roomName': appoint.roomName,
      "state": appoint.state,
    };
  }

}

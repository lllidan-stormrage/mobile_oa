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
      this.roomName});
}

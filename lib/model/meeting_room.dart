///会议室
class MeetingRoomEntity {
  int id;
  String name; //名称
  int floor; //楼层

  MeetingRoomEntity({this.id, this.name, this.floor});

  @override
  String toString() {
    return 'id:$id,name:$name,floor:$floor';
  }
}

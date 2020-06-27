///补签到表
class ReMakeSignEntity {

  int id;
  int year;
  int month;
  int userId;
  String place;
  String signTimeStamp; //时间戳

  ReMakeSignEntity(
      {this.id, this.year, this.month, this.userId, this.place, this.signTimeStamp});

  @override
  String toString() {
    // TODO: implement toString
    return '$id=$id,year = $year,month = $month,place = $place,userId = $userId,signTimeStamp = $signTimeStamp';
  }

}
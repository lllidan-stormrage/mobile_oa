///补签到表
class ReMakeSign {

  int id;
  int year;
  int month;
  int userId;
  String place;
  int signTimeStamp; //时间戳

  ReMakeSign(
      {this.id, this.year, this.month, this.userId, this.place, this.signTimeStamp});

  @override
  String toString() {
    // TODO: implement toString
    return '$id=$id,year = $year,month = $month,place = $place,userId = $userId,signTimeStamp = $signTimeStamp';
  }

}
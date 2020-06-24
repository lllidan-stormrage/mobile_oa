class UserSign {

  int id;
  int userId;
  String amSignTime;
  String pmSignTime;
  String amSignPlace;
  String pmSignPlace;
  int year;
  int month;
  int day;
  int amIsSign; //上午签到
  int pmIsSign; //下午是否签到

  UserSign(
      {this.id, this.userId, this.amIsSign, this.pmIsSign, this.amSignTime, this.pmSignTime, this.amSignPlace, this.pmSignPlace,this.year,this.month,this.day});

  @override
  String toString() {
    return "Sign{id = $id,userId = $userId,amIsSign = $amIsSign,pmIsSign = $pmIsSign,amSignTime = $amSignTime"
        ",pmSignTime =$pmSignTime,amSignPlace = $amSignPlace,pmSignPlace=$pmSignPlace,year=$year,month=$month,day=$day}";
  }
}
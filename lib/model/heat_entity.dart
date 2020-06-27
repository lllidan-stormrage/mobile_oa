class HeatEntity {
  int id;
  int year;
  int month;
  int day;
  double amHeat;
  double pmHeat;
  int userId;
  String createTime;
  int state; //1 normal ,2 error

  HeatEntity(
      {this.id,
      this.userId,
      this.amHeat,
      this.pmHeat,
      this.createTime,
      this.year,
      this.day,
      this.month,
      this.state});

  @override
  String toString() {
    // TODO: implement toString
    return 'id=${this.id},userId =${this.userId},amheat=${this.amHeat},pmHeat=${this.pmHeat},createTime = $createTime,year = $year,month = $month,day = $day,state = $state';
  }
}

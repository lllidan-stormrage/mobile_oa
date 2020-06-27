class Month{

  int year;
  int month;
  int day;
  int hour;
  int minute;

  Month({this.year,this.month,this.day,this.hour,this.minute});

  @override
  String toString() {

    return '$year-$month-$day $hour:$minute';
  }
}
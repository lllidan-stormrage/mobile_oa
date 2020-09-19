class MemoEntity {
  int id;
  int userId;
  String desc;
  String title;
  int isOver = 0;
  int year;
  int month;
  int day;

  MemoEntity(
      {this.id,
      this.desc,
      this.title,
      this.isOver,
      this.year,
      this.month,
      this.userId,
      this.day});

  @override
  String toString() {
    return 'MemoEntity{id:$id,title:$title,year:$year,month:$month,day:$day,desc:$desc,isOver:$isOver}';
  }
}

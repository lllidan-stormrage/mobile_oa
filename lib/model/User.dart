class User {
  final int id;
  final String name;
  final int age;
  final int sex; //1:men ,2:women

  User({this.id, this.name, this.age, this.sex});



  @override
  String toString() {
    return 'User{id:$id,name:$name,age:$age}';
  }
}

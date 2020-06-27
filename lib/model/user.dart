class UserEntity {
  int id;
  String name;
  String password;
  int age;
  int sex; //1:men ,2:women
  String company;
  String phone;

  UserEntity({this.id, this.name, this.password, this.age, this.sex,this.company,this.phone});

  @override
  String toString() {
    return 'User{id:$id,name:$name,password:$password,age:$age,company:$company}';
  }
}

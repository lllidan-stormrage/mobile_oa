class CommonDataHelper {


  static final agenda = ["签到打卡","考勤统计","加班"];
  static final meeting = ["会议室预定","会议记录","公告"];

  static final userTitle = ["昵称","电话","年龄","加班时长"];

  static List<String> getUserInfoTitle(){
    List<String> datas = new List();
    datas.add("昵称");
    datas.add("电话");
    datas.add("年龄");
    datas.add("加班时长");
    return datas;

  }


}
class DataHelper {


  static List<String> getAgendaList() {
    List<String> datas = new List();
    datas.add("签到打卡");
    datas.add("考勤统计");
    datas.add("加班");
    return datas;
  }

  static List<String> getMeetingList() {
    List<String> datas = new List();
    datas.add("会议室预定");
    datas.add("会议记录");
    datas.add("公告");
    return datas;
  }

  static List<String> getOtherFun() {
    List<String> datas = new List();
    datas.add("体温记录");
    return datas;
  }


}
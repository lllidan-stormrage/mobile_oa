import 'package:mobileoa/model/month.dart';

class CommonDataHelper {
  static final agenda = ["签到打卡", "考勤统计", "补卡申请"];
  static final meeting = ["会议室预定", "会议记录", "公告"];

  static final userTitle = ["昵称", "电话", "年龄", "加班时长"];

  static List<String> getUserInfoTitle() {
    List<String> datas = new List();
    datas.add("昵称");
    datas.add("电话");
    datas.add("年龄");
    datas.add("加班时长");
    return datas;
  }

  //当前年月往后退3月
  static List<Month> getRecentMonth() {
    List<Month> mDatas = new List();
    var date = new DateTime.now();
    if (date.month < 3) {
      if (date.month == 2) {
        mDatas.add(new Month(year: date.year, month: date.month));
        mDatas.add(new Month(year: date.year, month: date.month - 1));
        mDatas.add(new Month(year: date.year - 1, month: 12));
      } else {
        mDatas.add(new Month(year: date.year, month: date.month));
        mDatas.add(new Month(year: date.year - 1, month: 12));
        mDatas.add(new Month(year: date.year - 1, month: 11));
      }
    } else {
      mDatas.add(new Month(year: date.year, month: date.month));
      mDatas.add(new Month(year: date.year, month: date.month - 1));
      mDatas.add(new Month(year: date.year, month: date.month - 2));
    }
    return mDatas;
  }
}

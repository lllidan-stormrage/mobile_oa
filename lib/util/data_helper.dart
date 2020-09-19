import 'package:mobileoa/model/announce_entity.dart';
import 'package:mobileoa/model/month.dart';
import 'package:mobileoa/ui/meeting/announce_msg.dart';

class CommonDataHelper {
  static final agenda = ["签到打卡", "考勤统计", "补卡申请"];
  static final meeting = ["会议室预定", "会议记录", "公告"];
  static final memo = ["待办事项"];

  static final userTitle = ["公司", "电话", "年龄"];

static List<AnnounceEntity> getAnnounceEntity(){
  List<AnnounceEntity> datas = new List();
  datas.add(AnnounceEntity(sendName: "行政部",sendTime: "2020/6/30",title: "会议室变动",desc: "由于一楼 北京厅 装修施工中，暂停使用，请预约其他会议室"));
  datas.add(AnnounceEntity(sendName: "行政部",sendTime: "2020/6/29",title: "会议室规范指南",desc: "请结束会议时关闭投影，空调等设备，节约用电"));
  datas.add(AnnounceEntity(sendName: "行政部",sendTime: "2020/6/20",title: "会议室变动",desc: "一楼 武汉厅 装修施工完毕，于今日恢复使用。"));
  datas.add(AnnounceEntity(sendName: "行政部",sendTime: "2020/6/29",title: "会议室规范指南",desc: "会议室使用请走预约流程，非必要时不要占领会议室"));
  datas.add(AnnounceEntity(sendName: "行政部",sendTime: "2020/6/21",title: "会议室变动",desc: "四楼 维也纳厅 装修施工完毕，于今日恢复使用。"));
  datas.add(AnnounceEntity(sendName: "行政部",sendTime: "2020/6/22",title: "会议室变动",desc: "三楼 米兰厅 装修施工完毕，于今日恢复使用。"));
  datas.add(AnnounceEntity(sendName: "行政部",sendTime: "2020/6/23",title: "会议室变动",desc: "二楼 纽约厅 装修施工完毕，于今日恢复使用。"));
  return datas;
}


}

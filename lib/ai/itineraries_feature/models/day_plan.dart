import './activity.dart';

class DayPlan {
  int dayNum;
  String date;
  List<Activity> planForDay;

  DayPlan({required this.dayNum, required this.date, required this.planForDay});

  static DayPlan fromJson(Map<String, dynamic> jsonMap) {
    int localDayNum;
    String localDate;
    List<dynamic> localPlan;

    {
      'day': localDayNum,
      'date': localDate,
      'planForDay': localPlan,
    } = jsonMap;

    return DayPlan(
      dayNum: localDayNum,
      date: localDate,
      planForDay: List<Activity>.from(
        localPlan.map(
          (activity) => Activity.fromJson(activity),
        ),
      ),
    );
  }
}

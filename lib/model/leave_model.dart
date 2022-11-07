




class LeaveModel{

  final String full_name;
  final String uid;
  final String id;
  final String datetime;
  final String semaster;
  final String faculty;
  final String reason;
  final bool pending;
  final bool accept;
  final bool reject;

  LeaveModel({
    required this.uid,
    required this.accept,
    required this.datetime,
    required this.full_name,
    required this.pending,
    required this.reason,
    required this.reject,
    required this.semaster,
    required this.faculty,
    required this.id
  });


}
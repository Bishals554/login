import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login/model/leave_model.dart';

final crudProvider = Provider((ref) => LeaveProvider());
final leaveStream = StreamProvider((ref) => LeaveProvider().getPosts());

class LeaveProvider{

  CollectionReference leaveDb = FirebaseFirestore.instance.collection('leaves');

  Future<String> addLeave({
    required String full_name,
    required String uid,
    required String datetime,
    required String semaster,
    required String reason,
    required String faculty
  }) async{
    try{

      await leaveDb.add({
        'full_name': full_name,
        'uid': uid,
        'Datetime': datetime,
        'semaster': semaster,
        'reason': reason,
        'pending': true,
        'accept': false,
        'faculty': faculty,
        'reject': false,
      });

      return 'success';
    }on FirebaseException catch(err){

      return '${err.message}';
    }


  }


  Stream<List<LeaveModel>> getPosts() {
    try{
      return leaveDb.snapshots().map((event) {
        return getLeaveData(event);
      });
    }on FirebaseException catch(err){
      throw '${err.message}';
    }

  }

  List<LeaveModel>getLeaveData(QuerySnapshot snapshot){
    return snapshot.docs.map((e){
      final json = e.data() as Map<String, dynamic>;
      return LeaveModel(
        faculty: json['faculty'],
          id: e.id,
          uid: json['uid'],
          accept: json['accept'],
          datetime: json['Datetime'],
          full_name: json['full_name'],
          pending: json['pending'],
          reason: json['reason'],
          reject: json['reject'],
          semaster: json['semaster']
      );
    }).toList();
  }




  Future<String> leaveGrant(String id) async{
    try{
      await leaveDb.doc(id).update({
        'pending': false,
        'accept': true,
        'reject': false,
      });
      return 'success';
    }on FirebaseException catch(err){
      return '${err.message}';
    }

  }



  Future<String> leaveReject(String id) async{
    try{
      await leaveDb.doc(id).update({
        'pending': false,
        'accept': false,
        'reject': true,
      });
      return 'success';
    }on FirebaseException catch(err){
      return '${err.message}';
    }

  }


}
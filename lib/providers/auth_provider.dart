import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:image_picker/image_picker.dart';




final userStream = StreamProvider.autoDispose((ref) => FirebaseAuth.instance.authStateChanges());
final authProvider = Provider((ref) => AuthProvider());
final friendsProvider = StreamProvider.autoDispose((ref) =>FirebaseChatCore.instance.users());

final singleUserStream = StreamProvider.autoDispose((ref) {
  final uid = FirebaseChatCore.instance.firebaseUser!.uid;
  final data =  FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  return data.map((event) {
    final json = event.data() as Map<String, dynamic>;
    String role = json['role'];

    return types.User(
        id: event.id,
        metadata: json['metadata'],
        firstName: json['firstName'],
        imageUrl: json['imageUrl'],
      role: json['role'] == 'user' ? types.Role.user : types.Role.admin
    );
  });

});
class AuthProvider {

  final userDb = FirebaseFirestore.instance.collection('users');


  Future<String> userLogin({required String email, required String password}) async{
    try{
      final response = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return 'success';
    }on FirebaseAuthException catch (err){
      return '${err.code}';
    }
  }


  Future<String> userSignUp({
    required String firstName, required String secondName,
    required String email, required String password,
    required XFile image
  }) async{
    try{

      if(email.trim() == 'abhilamixane1@gmail.com'){
        final imageId = DateTime.now().toString();
        final ref = FirebaseStorage.instance.ref().child('userImage/${imageId}');
        await ref.putFile(File(image.path));
        final imageUrl = await ref.getDownloadURL();
        UserCredential response = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        await FirebaseChatCore.instance.createUserInFirestore(
          types.User(
            id: response.user!.uid,
            firstName: firstName,
            lastName: secondName,
            role: types.Role.admin,
            imageUrl: imageUrl,
            metadata: {
              'email': email
            }
          )
        );
      }else{
        final imageId = DateTime.now().toString();
        final ref = FirebaseStorage.instance.ref().child('userImage/${imageId}');
        await ref.putFile(File(image.path));
        final imageUrl = await ref.getDownloadURL();
        UserCredential response = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        await FirebaseChatCore.instance.createUserInFirestore(
            types.User(
                id: response.user!.uid,
                firstName: firstName,
                lastName: secondName,
                role: types.Role.user,
                imageUrl: imageUrl,
                metadata: {
                  'email': email
                }
            )
        );
      }
      return 'success';
    }on FirebaseAuthException catch (err){
      return '${err.code}';
    }
  }


  Future<String> userLogOut() async{
    try{
      final response = await FirebaseAuth.instance.signOut();
      return 'success';
    }on FirebaseAuthException catch (err){
      return '${err.code}';
    }
  }






}
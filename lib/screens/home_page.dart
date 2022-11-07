import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login/providers/auth_provider.dart';
import 'package:login/screens/user_page.dart';

import 'admin_page.dart';




class HomePage extends ConsumerWidget{

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userStream);
    return Scaffold(
        body: user.when(data: (data){
          if(data!.email == 'abhilamixane1@gmail.com'){
            return AdminPage();
          }else{
            return UserPage();
          }
        },
            error: (err, stack ) => Center(child: Text('$err')),
            loading: () => Container()
        )
    );
  }
}

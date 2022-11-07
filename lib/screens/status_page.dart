import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'auth_page.dart';
import 'home_page.dart';





class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return Scaffold(
        body: Consumer(
            builder: (context, ref, child) {
              final userData = ref.watch(userStream);
              return userData.when(
                  data: (data){
                    if(data == null){
                      return AuthPage();
                    }else{
                      return HomePage();
                    }

                  },
                  error: (err, stack) => Center(child: Text('$err')),
                  loading: () => Center(child: CircularProgressIndicator())
              );
            }
        )
    );
  }
}
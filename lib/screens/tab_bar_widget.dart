import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:login/model/leave_model.dart';
import 'package:login/providers/leave_provider.dart';

enum Status { pending, accept, reject }

class TabBarWidget extends StatelessWidget {
  final Status status;
  final bool admin;
  TabBarWidget(this.status, this.admin);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Consumer(builder: (context, ref, child) {
        final data = ref.watch(leaveStream);
        return Container(
          child: data.when(
              data: (data) {
                final pending =
                    data.where((element) => element.pending == true).toList();
                print(pending);
                final accept =
                    data.where((element) => element.accept == true).toList();
                final reject =
                    data.where((element) => element.reject == true).toList();

                if (status == Status.pending) {
                  return _buildListView(pending, true);
                } else if (status == Status.accept) {
                  return _buildListView(accept, false);
                } else {
                  return _buildListView(reject, false);
                }
              },
              error: (err, stack) => Text('$err'),
              loading: () {
                return CircularProgressIndicator();
              }),
        );
      }),
    );
  }

  ListView _buildListView(List<LeaveModel> leave, bool isPending) {
    return ListView.builder(
        itemCount: leave.length,
        itemBuilder: (context, index){
          return ListTile(
            title: Text(leave[index].full_name),
            subtitle: Text(leave[index].reason),
            trailing: admin &&  isPending ? Consumer(
              builder: (context, ref, child) {
                return Container(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.defaultDialog(
                                titleStyle: TextStyle(color: Colors.green),
                                title: 'Accept',
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'Are you sure you want to grant this leave'),
                                ),
                                actions: [
                                  TextButton(onPressed: () {
                                    Navigator.of(context).pop();
                                    ref.read(crudProvider).leaveGrant(leave[index].id);
                                  }, child: Text('Yes')),
                                  TextButton(onPressed: () {
                                    Navigator.of(context).pop();
                                  }, child: Text('No')),
                                ]
                            );
                          },
                          icon: Icon(Icons.check, color: Colors.green,)),
                      IconButton(
                          onPressed: () {
                            Get.defaultDialog(
                                titleStyle: TextStyle(color: Colors.pink),
                                title: 'Reject',
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'Are you sure you want to reject this leave'),
                                ),
                                actions: [
                                  TextButton(onPressed: () {
                                    Navigator.of(context).pop();
                                    ref.read(crudProvider).leaveReject(leave[index].id);
                                  }, child: Text('Yes')),
                                  TextButton(onPressed: () {
                                    Navigator.of(context).pop();
                                  }, child: Text('No')),
                                ]
                            );
                          },
                          icon: Icon(Icons.close, color: Colors.green,)),
                    ],
                  ),
                );
              }
            ) : Container(
              width: 50,
            )
          );
        }
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:login/providers/leave_provider.dart';


class Leavepage extends StatefulWidget {
  const Leavepage({Key? key}) : super(key: key);

  @override
  State<Leavepage> createState() => _LeavepageState();
}

class _LeavepageState extends State<Leavepage> {
  // int selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();

  final fullnameController = new TextEditingController();
  final reasonController = new TextEditingController();
  final dateController = new TextEditingController();
  final facultyController = new TextEditingController();
  final semesterController = new TextEditingController();

  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    // final tabs = [
    //   Container(),
    //   Container(),
    // ];
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Apply For Leave")),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: fullnameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter Your Full Name"),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: dateController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.calendar_month_outlined),
                        // icon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                        hintText: "Date"),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          initialDatePickerMode:
                              DatePickerMode.day, //get today's date
                          firstDate: DateTime(
                              2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                          dateController.text =
                              DateFormat.yMd().format(selectedDate);
                        });
                      }
                    },
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select any date';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: facultyController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: "Faculty"),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: semesterController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: "Semester"),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: reasonController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Reason for Leave"),
                    maxLines: 5, // <-- SEE HERE
                    minLines: 1,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 17.0),
                    child: Container(
                      height: 43,
                      child: Consumer(
                        builder: (context, ref, child) {
                          return ElevatedButton(
                            onPressed: () async{
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                               final response =await ref.read(crudProvider).addLeave(
                                   full_name: fullnameController.text.trim(),
                                   faculty: facultyController.text.trim(),
                                   uid: FirebaseAuth.instance.currentUser!.uid,
                                   datetime: dateController.text.trim(),
                                   semaster: semesterController.text.trim(),
                                   reason: reasonController.text.trim()
                               );
                               if(response == 'success'){
                                 Get.back();
                               }
                              }
                            },
                            child: const Text(
                              'Submit',
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

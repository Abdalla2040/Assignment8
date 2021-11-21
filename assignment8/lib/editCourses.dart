// ignore_for_file: file_names, use_key_in_widget_constructors, no_logic_in_create_state

import 'package:assignment8/editStudent.dart';
import 'package:assignment8/main.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'editStudent.dart';
import 'Models/Courses.dart';

class EditCourse extends StatefulWidget {
  //final String id;
  final String courseName;
  final String courseInstructor;
  final String courseCredits;

  final CourseApi api = CourseApi();

  EditCourse(this.courseName, this.courseInstructor, this.courseCredits);

  @override
  _EditCourseState createState() =>
      _EditCourseState(courseName, courseInstructor, courseCredits);
}

class _EditCourseState extends State<EditCourse> {
  final String courseName, courseInstructor, courseCredits;
  _EditCourseState(this.courseName, this.courseInstructor, this.courseCredits);
  List student = [];
  bool _dbLoaded = false;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.api.getAllStudents().then((data) {
      setState(() {
        student = data;
        _dbLoaded = true;
      });
    });
  }

  void deleteStudentById(String id) {
    setState(() {
      widget.api.deleteCourseById(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to " + widget.courseName),
      ),
      body: Center(
        child: _dbLoaded
            ? Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(15.0),
                        children: [
                          ...student
                              .map<Widget>(
                                (std) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 30),
                                  child: TextButton(
                                    onPressed: () => {
                                      // _editStudentByFname(
                                      //     std['fname'], std['lname'])
                                      //Navigator.pop(context),
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditStudents(
                                            std['fname'],
                                            std['lname'],
                                          ),
                                        ),
                                      ),
                                    },
                                    child: ListTile(
                                      leading: const Icon(
                                        (Icons.agriculture_sharp),
                                      ),
                                      isThreeLine: true,
                                      title: Text(
                                        (std['fname'] +
                                            "  " +
                                            std['lname'].toString()),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      subtitle:
                                          Text(std['studentID'].toString()),
                                      trailing: FloatingActionButton(
                                        onPressed: () => {
                                          deleteStudentById(textController.text)
                                        },
                                        child: Icon(Icons.delete),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ]),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    "Database Loading",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  CircularProgressIndicator()
                ],
              ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            child: const Icon(
              Icons.home,
            ),
            onPressed: () => {
              Navigator.pop(context),
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage())),
            },
          ),
          FloatingActionButton(
            onPressed: () => {
              Navigator.pop(context),
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCourse("", "", ""),
                ),
              )
            },
            child: const Icon(Icons.refresh),
          )
        ],
      ),
    );
  }
}

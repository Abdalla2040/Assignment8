// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'editCourses.dart';
import 'main.dart';
import 'api.dart';

class EditStudents extends StatefulWidget {
  final String fname, lname;
  final CourseApi api = CourseApi();
  EditStudents(this.fname, this.lname);

  @override
  _EditStudentsState createState() => _EditStudentsState(fname, lname);
}

class _EditStudentsState extends State<EditStudents> {
  final String fname, lname;
  _EditStudentsState(this.fname, this.lname);
  TextEditingController textController = TextEditingController();
  List student = [];
  bool _dbLoaded = false;

  void _editStudentByFname(fname, lname) {
    setState(() {
      widget.api.editStudentByFname(fname, lname);
      //Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditCourse(
                  'courseName', 'courseInstructor', 'courseCredits')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to " + widget.fname),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Edit student name",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),

            TextFormField(
              keyboardType: TextInputType.text,
              controller: textController,
            ),
            //editStudentByFname(widget.fname, widget.lname),
            ElevatedButton(
              onPressed: () =>
                  {_editStudentByFname(widget.fname, textController.text)},
              child: const Text('Edited'),
            ),
            FloatingActionButton(
              child: const Icon(Icons.home),
              onPressed: () => {
                Navigator.pop(context),
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePage())),
              },
            ),
          ],
        ),
      ),
    );
  }
}

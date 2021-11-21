import 'package:assignment8/editCourses.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'editCourses.dart';
import './Models/Courses.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Courses',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);

  final CourseApi api = CourseApi();
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List courses = [];
  bool _dbLoaded = false;
  @override
  void initState() {
    super.initState();
    widget.api.getAllCourses().then((data) {
      setState(() {
        courses = data;
        _dbLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Info'),
      ),
      body: Center(
          child: _dbLoaded
              ? Column(
                  children: [
                    Expanded(
                      child: ListView(children: [
                        ...courses
                            .map<Widget>(
                              (course) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: TextButton(
                                  onPressed: () => {
                                    Navigator.pop(context),
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditCourse(
                                          course['courseName'],
                                          course['courseInstructor'],
                                          course['courseCredits'],
                                        ),
                                      ),
                                    ),
                                  },
                                  child: ListTile(
                                    leading: const Icon((Icons.school)),
                                    isThreeLine: true,
                                    title: Text(
                                      (course['courseName'] +
                                          "\n" +
                                          course['courseInstructor']),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    subtitle: Text(course['courseCredits']),
                                    trailing: FloatingActionButton(
                                      onPressed: () => {},
                                      child: const Icon(Icons.delete),
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
                    Text('Database is loading'),
                    CircularProgressIndicator(),
                  ],
                )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

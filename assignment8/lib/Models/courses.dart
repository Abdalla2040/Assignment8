// ignore_for_file: file_names

class Courses {
  final String id;
  final String courseInstructor;
  final String courseCredits;
  final String courseID;
  final String courseName;
  final String enteredDate;

  Courses._(this.id, this.courseInstructor, this.courseCredits, this.courseID,
      this.courseName, this.enteredDate);

  factory Courses.fromJson(Map json) {
    final id = json['_id'].replaceAll('ObjectId(\"', '').replaceAll('\")', '');
    final courseInstructor = json['courseInstructor'];
    final courseCredits = json['courseCredits'];
    final courseID = json['courseID'];
    final courseName = json['courseName'];
    final enteredDate = json['enteredDate'];

    return Courses._(
        id, courseInstructor, courseCredits, courseID, courseName, enteredDate);
  }
}

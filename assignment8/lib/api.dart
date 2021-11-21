import 'package:dio/dio.dart';
import 'Models/courses.dart';

const String localhost = "http://10.0.2.2:1200/";

class CourseApi {
  final _dio = Dio(BaseOptions(baseUrl: localhost));
  Future<List> getAllCourses() async {
    final response = await _dio.get('/getAllCourses');
    return response.data['courses'];
  }

  Future<List> getAllStudents() async {
    final response = await _dio.get('/getAllStudents');
    return response.data['students'];
  }

  Future editStudentByFname(String fname, String fName) async {
    final response = await _dio
        .post('/editStudentByFname', data: {'fname': fname, 'Fname': fName});
  }

  Future deleteCourseById(String id) async {
    final response = await _dio.post('/deleteCourseById', data: {'_id': id});
  }
}

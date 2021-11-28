const express = require('express');
const app = express();
const nodemon = require('nodemon');
app.use(express.json());

//MongoDB Package
const mongoose = require('mongoose');

const PORT = 1200;

const dbUrl = "mongodb+srv://admin:supers450@cluster0.8jehk.mongodb.net/mohamedDB?retryWrites=true&w=majority";

//Connect to MongoDB
mongoose.connect(dbUrl,{
    useNewUrlParser: true,
    useUnifiedTopology: true
});

//MongoDB Connection
const db = mongoose.connection;

//Handle DB Error, display connection
db.on('error', () => {
    console.error.bind(console,'connection error: ');
});
db.once('open',() => {
    console.log('MongoDB Connected')
});

require('./Models/Students');
require('./Models/Courses');

const Student = mongoose.model('Student');
const Course = mongoose.model('Course');

//gets all students
app.get('/getAllStudents', async(req,res)=>{
    try{
        let students = await Student.find({}).lean();
        return res.status(200).json({"students":students});
    }catch{
        res.status(500).json('{message: Could not find students}');
    }
    
    
});

//gets all courses
app.get('/getAllCourses', async(req,res)=>{
    try{
        let courses = await Course.find({}).lean();
        return res.status(200).json({'courses':courses});
    }catch{
        res.status(500).json('{message: Could not find courses}');
    }
    
    
});

//gets specific student using any unique field such as 'studentID': 100
app.post('/findStudent', async(req,res)=>{
    try{
        let students = await Student.find({studentID: req.body.studentID}).lean();
        return res.status(200).json(students);
    }catch{
        res.status(500).json('{message: Could not find student}');
    }
    
    
});

//gets specific course using any unique field such as 'courseID': 'CMSC2204'
app.post('/findCourse', async(req,res)=>{
    try{
        let courses = await Course.find({courseID: req.body.courseID}).lean();
        return res.status(200).json(courses);
    }catch{
        res.status(500).json('{message: Could not find course}');
    }
    
    
});

//adds a course by requiring all properties needed for a course
app.post('/addCourse', async(req, res)=>{
    try{
        let courses = {
            courseInstructor: req.body.courseInstructor,
            courseCredits: req.body.courseCredits,
            courseID: req.body.courseID,
            courseName: req.body.courseName,
            dateEntered: req.body.dateEntered

        }
    
    await Course(courses).save().then(c =>{
        return res.status(201).json('course added');
    });
    }catch{
        return res.status(500).json('{message: could not add course}');
    }
});

//adds a student by requiring all properties from a student
app.post('/addStudent', async(req, res)=>{
    try{
        let students = {
            fname: req.body.fname,
            lname: req.body.lname,
            studentID: req.body.studentID,
            dateEntered: req.body.dateEntered

        }
    
    await Student(students).save().then(c =>{
        return res.status(201).json('student added');
    });
    }catch{
        return res.status(500).json('{message: could not add student}');
    }
});

//updates the first name of student using the generic id provided by the database
app.post('/editStudentById', async(req,res)=>{
    try{
        let students = await Student.find({_id:req.body.id});
           if(students){
               await Student.updateOne({_id: req.body.id},{fname: req.body.fname});
               return res.status(500).json('{message: updated student}');
           }else{
               return res.status(500).json('{message: could not update student}'); 
           }
        
    }catch{
        res.status(500).json('{message: Could not find student}');
    }
    
    
});

//updates the first name and last name of student by using the first name that's currently on the database
app.post('/editStudentByFname', async(req,res)=>{
    try{
        let students = await Student.find({fname:req.body.fname});
           if(students){
               await Student.updateOne({firstName:req.body.fname}, {fname: req.body.Fname, lname: req.body.lname});
               return res.status(500).json('{message: updated student by first name}');
           }else{
               return res.status(500).json('{message: could not update student by first name}'); 
           }
        
    }catch{
        res.status(500).json('{message: Could not find student}');
    }
    
    
});

//updates the course Instructor's name using the course name
app.post('/editCourseByCourseName', async(req,res)=>{
    try{
        let courses = await Course.find({courseName:req.body.courseName});
           if(courses){
               await Course.updateOne({courseName:req.body.courseName}, {courseInstructor: req.body.courseInstructor});  
               return res.status(500).json('{message: updated course instructor}');
           }else{
               return res.status(500).json('{message: could not update course instructor}'); 
           }
        
    }catch{
        res.status(500).json('{message: Could not find courses}');
    }
    
    
});

//deletes a course from the courses using the generic id provided in the body
app.post('/deleteCourseById', async(req,res)=>{
    try{
        let courses = await Course.find({_id: req.body.id});
        if(courses){
            await Course.deleteOne({_id: req.body.id});
            return res.status(500).json('{message: delete course}');
        }else{
            return res.status(500).json('{message: could not delete course}'); 
        }
        
    }catch{
        res.status(500).json('{message: Could not find course}');
    }
    
    
});

//deletes student from all classes using the studentID provided in the body
app.post('/removeStudentFromClasses', async(req,res)=>{
    try{
        let students = await Student.find({studentID:req.body.studentID});
        if(students){
            await Student.deleteMany({studentID: req.body.studentID});
            return res.status(500).json('{message: deleted student from all classes}');
        }else{
            return res.status(500).json('{message: could not delete student from all classes}'); 
        }
        
    }catch{
        res.status(500).json('{message: Could not find student}');
    }
    
    
});

app.listen(PORT, () => {
    console.log(`Server Started on port ${PORT}`);
})
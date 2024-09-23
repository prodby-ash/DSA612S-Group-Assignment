import ballerina/io;
import ballerina/http;


public type Course record {
    string Course_code?;
    string Name?;
    string NQF_level?;
};


public type Lecturers record {
    string Staff_number?;
    string Title?;
    string Name?;
    string Surname?;
    string Age?;
    string Gender?;
    string Office_number?;
    string First_course?;
    string Second_course?;
    string Third_course?;
    string Email?;
};


public function main() returns error? {
    http:Client Client = check new ("localhost:8080/Faculty_of_Computing_and_Informatics");
    io:println("-------------------------------------------------------------------------------");
    io:println("|                                                                             |");
    io:println("|                       NUST Management System v4.9.0                     |");
    io:println("|                                                                             |");
    io:println("-------------------------------------------------------------------------------");
    io:println("|1.  Add a new lecturer [Staff]                                               |");
    io:println("|2.  Retrieve a list of all lecturers within the faculty [Staff]              |");
    io:println("|3.  Update an existing lecturers information [Staff]                         |");
    io:println("|4.  Retrieve the details of a specific lecturer by their staff number [Staff]|");
    io:println("|5.  Delete a lecturer record by their staff number [Staff]                   |");
    io:println("|6.  Retrieve all the lecturers that teach a certain course [Staff]           |");
    io:println("|7.  Retrieve all the lecturers that sit in the same office [Staff]           |");
    io:println("-------------------------------------------------------------------------------");
    io:println("|8.  Add a new course [Course]                                                |");
    io:println("|9.  Retrieve a list of all courses[Course]                                   |");
    io:println("|10. Update an existing courses information [Course]                          |");
    io:println("|11. Retrieve the details of a specific course by its course code  [Course]   |");
    io:println("|12. Delete a course record by its course code [Course]                       |");
    io:println("|13. Retrieve all the courses that have the same NQF Level [Course]           |");
    io:println("-------------------------------------------------------------------------------");
    string option = io:readln("Choose an option: ");


    match option {
        "1" => {
            Lecturers Lecturer = {};
            Lecturer.Staff_number = io:readln("Enter Lecturers Staff_number: ");
            Lecturer.Title = io:readln("Enter Title: ");
            Lecturer.Name = io:readln("Enter Lecturers Name: ");
            Lecturer.Surname = io:readln("Enter Lecturers Surname: ");
            Lecturer.Age = io:readln("Enter Lecturers Age: ");
            Lecturer.Gender = io:readln("Enter Lecturers Gender: ");
            Lecturer.Office_number = io:readln("Enter Lecturers Office number: ");
            Lecturer.First_course = io:readln("Enter Lecturers First course taught: ");
            Lecturer.Second_course = io:readln("Enter Lecturers Second course taught: ");
            Lecturer.Third_course = io:readln("Enter Lecturers Third course taught: ");
            Lecturer.Email = io:readln("Enter Lecturers Email: ");
            check Add_a_lecturer_function(Client, Lecturer);
        }


        "2" => {
            check Get_all_lecturers_function(Client);
        }


        "3" => {
            Lecturers Lecturer = {Staff_number: ""};
            Lecturer.Staff_number = io:readln("Enter Lecturers Staff_number: ");
            Lecturer.Title = io:readln("Enter Title: ");
            Lecturer.Name = io:readln("Enter Lecturers Name: ");
            Lecturer.Surname = io:readln("Enter Lecturers Surname: ");
            Lecturer.Age = io:readln("Enter Lecturers Age: ");
            Lecturer.Gender = io:readln("Enter Lecturers Gender: ");
            Lecturer.Office_number = io:readln("Enter Lecturers Office number: ");
            Lecturer.First_course = io:readln("Enter Lecturers First course taught: ");
            Lecturer.Second_course = io:readln("Enter Lecturers Second course taught: ");
            Lecturer.Third_course = io:readln("Enter Lecturers Third course taught: ");
            Lecturer.Email = io:readln("Enter Lecturers Email: ");
            check Update_a_lecturer_function(Client, Lecturer);
        }


        "4" => {
            string Staff = io:readln("Enter Lecturers Staff_number: ");
            check Get_lecturer_by_staffnumber_function(Client, Staff);
        }


        "5" => {
            Lecturers Lecturer = {Title: "", Name: "", Surname: "", Age: "", Gender: "", Office_number: "", First_course: "",
            Second_course: "", Third_course: "", Email: ""};
            Lecturer.Staff_number = io:readln("Enter Lecturers Staff_number: ");
            check Delete_lecturer_by_staffnumber_function(Client, Lecturer);
        }


        "6" => {
            string course_name = io:readln("Enter The course the Lecturer teaches: ");
            check Get_all_lecturers_by_course_function(Client, course_name);
        }


        "7" => {
            string office = io:readln("Enter The office number for the lecturer: ");
            check Get_all_lecturer_by_officenumber_function(Client, office);
        }

        "8" => {
            Course course = {};
            course.Course_code = io:readln("Enter Course Code: ");
            course.Name = io:readln("Enter Course Name: ");
            course.NQF_level = io:readln("Enter NQF Level: ");
            check Add_a_course_function(Client, course);
        }


        "9" => {
            check Get_all_courses_function(Client);
        }


        "10" => {
            Course course = {Course_code: ""};
            course.Course_code = io:readln("Enter Course Code: ");
            course.Name = io:readln("Enter Course Name: ");
            course.NQF_level = io:readln("Enter NQF Level: ");
            check Update_a_course_function(Client, course);
        }


        "11" => {
            string Course = io:readln("Enter Courses code: ");
            check Get_course_by_coursecode_function(Client, Course);
        }


        "12" => {
            Course course = {Course_code: "", Name: "", NQF_level: ""};
            course.Course_code = io:readln("Enter Course code: ");
            check Delete_course_by_coursecode_function(Client, course);
        }


        "13" => {
            string course_name = io:readln("Enter The NQF level : ");
            check Get_all_courses_by_NQFlevel_function(Client, course_name);
        }

        _ => {
            io:println("Invalid Option");
            check main();
        }
    }
}


public function Add_a_lecturer_function(http:Client http, Lecturers Lecturer) returns error? {
    if (http is http:Client) {
        string message = check http->/addLecturer.post(Lecturer);
        io:println(message);
        string exit = io:readln("Press 0 to go back: ");

        if (exit === "0") {
            error? mainResult = main();
            if mainResult is error {
                io:println("Error, You can't go back.");
            }
        }
    }
}


public function Add_a_course_function(http:Client http, Course course) returns error? {
    if (http is http:Client) {
        string message = check http->/addCourse.post(course);
        io:println(message);
        string exit = io:readln("Press 0 to go back: ");

        if (exit === "0") {
            error? mainResult = main();
            if mainResult is error {
                io:println("Error, You can't go back.");
            }
        }
    }
}


public function Get_all_courses_function(http:Client http) returns error? {
    if (http is http:Client) {
        Course[] course = check http->/getAllCourses;
        foreach Course item in course {
            io:println("--------------------------");
            io:println("Course code: ", item.Course_code);
            io:println("Name: ", item.Name);
            io:println("NQF level: ", item.NQF_level);
            io:println("--------------------------");
        }
        string exit = io:readln("Press 0 to go back: ");
        if (exit == "0") {
            error? mainResult = main();
            if mainResult is error {
                io:println("Error, You can't go back.");
            }
        }
    }
}

public function Get_all_lecturers_function(http:Client http) returns error? {
    if (http is http:Client) {
        Lecturers[] Lecturer = check http->/getAllLecturers;
        foreach Lecturers item in Lecturer {
            io:println("--------------------------");
            io:println("Staff number: ", item.Staff_number);
            io:println("Name: ", item.Name, " " , item.Surname);
            io:println("--------------------------");
        }
        string exit = io:readln("Press 0 to go back: ");
        if (exit == "0") {
            error? mainResult = main();
            if mainResult is error {
                io:println("Error, You can't go back.");
            }
        }
    }
}


public function Update_a_course_function(http:Client http, Course course) returns error? {
    if (http is http:Client) {
        string message = check http->/updateCourse.put(course);
        io:println(message);
        string exit = io:readln("Press 0 to go back: ");
        if (exit === "0") {
            error? mainResult = main();
            if mainResult is error {
                io:println("Error, You can't go back.");
            }
        }
    }
    io:println(course);
}


public function Update_a_lecturer_function(http:Client http, Lecturers Lecturer) returns error? {
    if (http is http:Client) {
        string message = check http->/updateLecturer.put(Lecturer);
        io:println(message);
        string exit = io:readln("Press 0 to go back: ");
        if (exit === "0") {
            error? mainResult = main();
            if mainResult is error {
                io:println("Error, You can't go back.");
            }
        }
    }
    io:println(Lecturer);
}

public function Get_course_by_coursecode_function(http:Client http, string Course_code) returns error? {
    if (http is http:Client) {
        Course course = check http->/getCoursebyCoursecode(Course_code = Course_code);
        io:println("--------------------------");
        io:println("Course Code: ", course.Course_code);
        io:println("Course Name: ", course.Name);
        io:println("NQF Level: ", course.NQF_level);
        io:println("--------------------------");
        string exit = io:readln("Press 0 to go back: ");
        if (exit == "0") {
            error? mainResult = main();
            if mainResult is error {
                io:println("Error, You can't go back.");
            }
        }
    }
}


public function Get_lecturer_by_staffnumber_function(http:Client http, string Staff_number) returns error? {
    if (http is http:Client) {
        Lecturers Lecturer = check http->/getLecturerbyStaffnumber(Staff_number = Staff_number);
        io:println("--------------------------");
        io:println("Staff number: ", Lecturer.Staff_number);
        io:println("Title: ", Lecturer.Title);
        io:println("Lecturers Name: ", Lecturer.Name, " " , Lecturer.Surname);
        io:println("Age: ", Lecturer.Age);
        io:println("Gender: ", Lecturer.Gender);
        io:println("Office number: ", Lecturer.Office_number);
        io:println("1st Course taught: ", Lecturer.First_course);
        io:println("2nd Course taught: ", Lecturer.Second_course);
        io:println("3rd Course taught ", Lecturer.Third_course);
        io:println("Email: ", Lecturer.Email);
        io:println("--------------------------");
        string exit = io:readln("Press 0 to go back: ");
        if (exit == "0") {
            error? mainResult = main();
            if mainResult is error {
                io:println("Error, You can't go back.");
            }
        }
    }
}


public function Delete_course_by_coursecode_function(http:Client http, Course course) returns error? {
    if (http is http:Client) {
        string message = check http->/deleteCourse.delete(course);
        io:println(message);
        string exit = io:readln("Press 0 to go back: ");
        if (exit === "0") {
            error? mainResult = main();
            if mainResult is error {
                io:println("Error, You can't go back.");
            }
        }
    }
}



public function Delete_lecturer_by_staffnumber_function(http:Client http, Lecturers Lecturer) returns error? {
    if (http is http:Client) {
        string message = check http->/deleteLecturer.delete(Lecturer);
        io:println(message);
        string exit = io:readln("Press 0 to go back: ");
        if (exit === "0") {
            error? mainResult = main();
            if mainResult is error {
                io:println("Error, You can't go back.");
            }
        }
    }
}


public function Get_all_courses_by_NQFlevel_function(http:Client http, string NQF_level) returns error? {
    // Check if the http client is valid
    if (http is http:Client) {
        // Fetch courses by NQF level, assuming the return type is Course[]
        Course[] courses = check http->/getCoursesbyNQFlevel(NQF_level = NQF_level);

        // Iterate through the array of Course
        foreach Course course in courses {
            io:println("--------------------------");
            io:println("This Course Has The Following NQF Level: ", course.NQF_level);
            io:println("Course Code: ", course.Course_code);
            io:println("Course Name: ", course.Name);
            io:println("--------------------------");
        }

        // Read user input to return back
        string exit = io:readln("Press 0 to go back: ");
        if (exit == "0") {
            error? mainResult = main();
            if mainResult is error {
                io:println("Error, You can't go back.");
            }
        }
    }
}



public function Get_all_lecturers_by_course_function(http:Client http, string First_course) returns error? {
    if (http is http:Client) {
        Lecturers[] Lecturer = check http->/getLecturerbyCourses(First_course = First_course);
        foreach Lecturers item in Lecturer{
        io:println("--------------------------");
        io:println("This Lecturer Teaches The Following Course: ", item.First_course);
        io:println("Staff number: ", item.Staff_number);
        io:println("Lecturers Name: ", item.Name, " " , item.Surname);
        io:println("--------------------------");
        }
        string exit = io:readln("Press 0 to go back: ");
        if (exit == "0") {
            error? mainResult = main();
            if mainResult is error {
                io:println("Error, You can't go back.");
            }
        }
    }
}


public function Get_all_lecturer_by_officenumber_function(http:Client http, string Office_number) returns error? {
    if (http is http:Client) {
        Lecturers[] Lecturer = check http->/getLecturerbyOffice(Office_number = Office_number);
        foreach Lecturers item in Lecturer{
        io:println("--------------------------");
        io:println("This Lecturer Sits In This Office: ", item.Office_number);
        io:println("Staff number: ", item.Staff_number);
        io:println("Lecturers Name: ", item.Name, " " , item.Surname);
        io:println("--------------------------");
        }
        string exit = io:readln("Press 0 to go back: ");
        if (exit == "0") {
            error? mainResult = main();
            if mainResult is error {
                io:println("Error, You can't go back.");
            }
        }
    }
}
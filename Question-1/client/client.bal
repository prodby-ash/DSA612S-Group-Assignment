import ballerina/http;
import ballerina/io;

public function main() returns error? {
    // Define the base URL for the server
    string baseUrl = "http://localhost:9000/programmeService";

    // Create an HTTP client
    http:Client programmeClient = check new (baseUrl);

    // Show menu and prompt user for input
    while true {
        io:println("\nProgramme Management System");
        io:println("1. Add a new programme");
        io:println("2. Retrieve all programmes");
        io:println("3. Update a programme");
        io:println("4. Retrieve programme by code");
        io:println("5. Delete a programme");
        io:println("6. Retrieve programmes due for review");
        io:println("7. Retrieve programmes by faculty");
        io:println("0. Exit");
        string choice = io:readln("Enter your choice: ");

        match choice {
            "1" => { check addProgramme(programmeClient); }
            "2" => { check retrieveAllProgrammes(programmeClient); }
            "3" => { check updateProgramme(programmeClient); }
            "4" => { check retrieveProgrammeByCode(programmeClient); }
            "5" => { check deleteProgrammeByCode(programmeClient); }
            "6" => { check retrieveProgrammesDueForReview(programmeClient); }
            "7" => { check retrieveProgrammesByFaculty(programmeClient); }
            "0" => {
                io:println("Exiting...");
                break;
            }
            _ => { io:println("Invalid choice, please try again."); }
        }
    }
}

// Function to add a programme
function addProgramme(http:Client Client) returns error? {
    Programme newProgramme = {
        programmeCode: io:readln("Enter programme code: "),
        programmeTitle: io:readln("Enter programme title: "),
        nqfLevel: check int:fromString(io:readln("Enter NQF level: ")),
        faculty: io:readln("Enter faculty: "),
        department: io:readln("Enter department: "),
        registrationDate: io:readln("Enter registration date (YYYY-MM-DD): "),
        courses: []
    };
    http:Response response = check Client->post("/addProgramme", newProgramme);
    io:println("Response: ", check response.getTextPayload());
}

// Function to retrieve all programmes
function retrieveAllProgrammes(http:Client Client) returns error? {
    http:Response response = check Client->get("/retrieveAllProgrammes");
    json payload = check response.getJsonPayload();
    Programme programme = check payload.cloneWithType(Programme);
    io:println(programme.programmeCode);
    //foreach Programme Programmes in programme {
    //    printProgrammeDetails(programme);
    //}
}

// Function to update a programme by code 
function updateProgramme(http:Client Client) returns error? {
    Programme updatedProgramme = {
        programmeCode: io:readln("Enter programme code: "),
        programmeTitle: io:readln("Enter updated programme title: "),
        nqfLevel: check int:fromString(io:readln("Enter updated NQF level: ")),
        faculty: io:readln("Enter updated faculty: "),
        department: io:readln("Enter updated department: "),
        registrationDate: io:readln("Enter updated registration date (YYYY-MM-DD): "),
        courses: []
    };
    http:Response response = check Client->put("/updateProgrammeByCode", updatedProgramme);
    io:println("Response: ", check response.getTextPayload());
}

// Function to retrieve a programme by code
function retrieveProgrammeByCode(http:Client Client) returns error? {
    string code = io:readln("Enter programme code: ");
    http:Response response = check Client->get("/retrieveProgrammeByCode/" + code);
    json payload = check response.getJsonPayload();
    Programme programme = check payload.cloneWithType(Programme);
    printProgrammeDetails(programme);
}

// Function to delete a programme by code
function deleteProgrammeByCode(http:Client Client) returns error? {
    string code = io:readln("Enter programme code: ");
    http:Response response = check Client->delete("/deleteProgrammeByCode/" + code);
    io:println("Response: ", check response.getTextPayload());
}

// Function to retrieve programmes due for review
function retrieveProgrammesDueForReview(http:Client Client) returns error? {
    http:Response response = check Client->get("/retrieveDueForReview");
    json responsePayload = check response.getJsonPayload();
    Programme programme = check responsePayload.cloneWithType(Programme);
    io:println(programme.programmeCode);
}

// Function to retrieve programmes by faculty
function retrieveProgrammesByFaculty(http:Client Client) returns error? {
    string faculty = io:readln("Enter faculty name: ");
    http:Response response = check Client->get("/retrieveAllProgrammesByFaculty/" + faculty);
    json payload = check response.getJsonPayload();
    Programme programme = check payload.cloneWithType(Programme);
    io:println(programme.programmeCode);
    //foreach Programme programme in programmes {
    //    printProgrammeDetails(programme);
    //}
}

// Helper function to print programme details
function printProgrammeDetails(Programme programme) {
    io:println("\nProgramme Code: ", programme.programmeCode);
    io:println("Programme Title: ", programme.programmeTitle);
    io:println("NQF Level: ", programme.nqfLevel);
    io:println("Faculty: ", programme.faculty);
    io:println("Department: ", programme.department);
    io:println("Registration Date: ", programme.registrationDate);
    io:println("-------------------------------");
}

// Define the Programme record type
type Programme record {
    readonly string programmeCode;
    string programmeTitle;
    int nqfLevel;
    string faculty;
    string department;
    string registrationDate;
    Course[] courses;
};

// Define the Course record type
type Course record {
    string courseCode;
    string courseName;
    int nqfLevel;
};

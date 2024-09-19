import ballerina/http;

type Programme record {
    readonly string programmeCode;
    string programmeTitle;
    int nqfLevel;
    string faculty;
    string department;
    string registrationDate;
    Course[] courses;
};

type Course record {
    string courseCode;
    string courseName;
    int nqfLevel;
};


// Creating a table for the Programmes
table<Programme> key(programmeCode) programmeTable = table[];

service / on new http:Listener(9000) {

    // Adding a new programme
    resource function post addProgramme(Programme newProgramme) returns string|error {
        // Error handling to ensure our app does not crash
        error? createNewProgramme = programmeTable.add(newProgramme);

        if (createNewProgramme is error) {
            return "Error " + createNewProgramme.message();
        }else {
            return newProgramme.programmeTitle + " Saved Successfully!";
        }
    }

    resource function get retrieveAllProgrammes() returns Programme[] {
        return programmeTable.toArray();
    }

    resource function get retrieveProgrammeByCode(string programmeCode) returns Programme[] {
        table<Programme> programmeResults = from var programme in programmeTable
            order by programme.programmeTitle ascending
            where programme.programmeCode === programmeCode
            select programme;

        return programmeResults.toArray();
    }

    resource function put updateProgrammeByCode(Programme updatedProgramme) returns string|error {
        // Error handling to ensure our app does not crash
        error? updateProgramme = programmeTable.put(updatedProgramme);

        if (updateProgramme is error) {
            return "Error " + updateProgramme.message();
        }else {
            return updatedProgramme.programmeTitle + " Updated Successfully!";
        }
    }

    resource function delete deleteProgrammeByCode(string programmeCode) returns string|error {
        // Error handling to ensure our app does not crash 
        Programme|error deleteProgramme = programmeTable.remove(programmeCode);

        if(deleteProgramme is error) {
            return "Error: " + deleteProgramme.message();
        }else {
            return deleteProgramme.programmeCode + " Deleted Successfully!";
        }
    }

    resource function get retrieveAllProgrammesByFaculty(string faculty) returns Programme[] {
        table<Programme> programmeByFaculty = from var programme in programmeTable
            order by programme.programmeTitle ascending
            where programme.faculty === faculty
            select programme;

        return programmeByFaculty.toArray();
    }

// Retrieve all programmes that are due for review (registered 5+ years ago)

}
import introspection_tutorial.db;

import ballerina/io;
import ballerina/persist;

// Initialize client
db:Client dbClient = check new db:Client();

public function main() returns error? {

    // Insert records
    check insertRecords();

    // Read records
    check readAndPrintRecords();
}

function insertRecords() returns persist:Error? {

    // Create insert records
    db:PatientInsert newPatient = {
        name: "John Doe",
        age: 30,
        address: "Colombo",
        gender: db:MALE,
        phoneNumber: "0771234567"
    };

    db:DoctorInsert newDoctor = {
        id: 1,
        name: "Dr. Jane Doe",
        specialty: "Cardiologist",
        phoneNumber: "0771234568",
        salary: 100000
    };

    db:AppointmentInsert newAppointment = {
        id: 1,
        patientId: 1,
        doctorId: 1,
        appointmentTime: {year: 2024, month: 4, day: 22, hour: 10, minute: 30},
        reason: "Heart pain",
        status: db:STARTED
    };

    // Insert records
    int[] result = check dbClient->/patients.post([newPatient]);
    io:println(string `Patient with ID:${result[0]} inserted successfully`);
    _ = check dbClient->/doctors.post([newDoctor]);
    io:println(string `Doctor with ID:${newDoctor.id} inserted successfully`);
    _ = check dbClient->/appointments.post([newAppointment]);
    io:println(string `Appointment with ID:${newAppointment.id} inserted successfully`);
    io:println();
}

function readAndPrintRecords() returns persist:Error? {

    stream<db:Patient, persist:Error?> patientStream = dbClient->/patients();

    db:Patient[] patients = check from db:Patient patient in patientStream select patient;
    io:println(`Patients: ${patients}${"\n"}`);
    
    stream<db:Doctor, persist:Error?> doctorStream = dbClient->/doctors();

    db:Doctor[] doctors = check from db:Doctor doctor in doctorStream select doctor;
    io:println(`Doctors: ${doctors}${"\n"}`);

    stream<db:AppointmentWithRelations, persist:Error?> appointmentStream = dbClient->/appointments();
    
    db:AppointmentWithRelations[] appointments = check from db:AppointmentWithRelations appointment in appointmentStream select appointment;
    io:println(`Appointments: ${appointments}${"\n"}`);
}

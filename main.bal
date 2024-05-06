import introspection_tutorial.entities;

import ballerina/io;
import ballerina/persist;

public function main() returns error? {

    // Initialize client
    entities:Client dbClient = check new entities:Client();

    // Insert records
    check insertRecords(dbClient);

    // Read records
    check readAndPrintRecords(dbClient);
}

function insertRecords(entities:Client dbClient) returns persist:Error? {

    // Create insert records
    entities:PatientInsert newPatient = {
        name: "John Doe",
        age: 30,
        address: "Colombo",
        gender: entities:MALE,
        phoneNumber: "0771234567"
    };

    entities:DoctorInsert newDoctor = {
        id: 1,
        name: "Dr. Jane Doe",
        specialty: "Cardiologist",
        phoneNumber: "0771234568",
        salary: 100000
    };

    entities:AppointmentInsert newAppointment = {
        id: 1,
        patientId: 1,
        doctorId: 1,
        appointmentTime: {year: 2024, month: 4, day: 22, hour: 10, minute: 30},
        reason: "Heart pain",
        status: entities:STARTED
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

function readAndPrintRecords(entities:Client dbClient) returns persist:Error? {

    stream<entities:Patient, persist:Error?> patients = dbClient->/patients();

    io:println("Patients:");
    check from entities:Patient patient in patients
    do {
        io:println(patient);
    };
    io:println();

    stream<entities:Doctor, persist:Error?> doctors = dbClient->/doctors();

    io:println("Doctors:");
    check from entities:Doctor doctor in doctors
    do {
        io:println(doctor);
    };
    io:println();

    io:println("Appointments:");
    stream<entities:AppointmentWithRelations, persist:Error?> appointments = dbClient->/appointments();
    check from entities:AppointmentWithRelations appointment in appointments
    do {
        io:println(appointment);
    };

}

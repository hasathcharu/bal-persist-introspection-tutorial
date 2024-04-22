import hospital.entities;

import ballerina/io;
import ballerina/persist;

public function main() returns error? {

    // Initialize client
    entities:Client persist = check new entities:Client();

    // Insert records
    check insertRecords(persist);

    // Read records
    check readAndPrintRecords(persist);
}

function insertRecords(entities:Client persist) returns persist:Error? {

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
    _ = check persist->/patients.post([newPatient]);
    io:println("Patient inserted successfully");
    _ = check persist->/doctors.post([newDoctor]);
    io:println("Doctor inserted successfully");
    _ = check persist->/appointments.post([newAppointment]);
    io:println("Appointment inserted successfully");

}

function readAndPrintRecords(entities:Client persist) returns persist:Error? {

    stream<entities:Patient, persist:Error?> patients = persist->/patients();

    io:println("Patients:");
    check from entities:Patient patient in patients
    do {
        io:println(patient);
    };
    io:println();

    stream<entities:Doctor, persist:Error?> doctors = persist->/doctors();

    io:println("Doctors:");
    check from entities:Doctor doctor in doctors
    do {
        io:println(doctor);
    };
    io:println();

    io:println("Appointments:");
    stream<entities:AppointmentWithRelations, persist:Error?> appointments = persist->/appointments();
    check from entities:AppointmentWithRelations appointment in appointments
    do {
        io:println(appointment);
    };

}

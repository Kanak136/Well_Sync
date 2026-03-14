//
//  getData.swift
//  wellSync
//
//  Created by Vidit Agarwal on 14/03/26.
//

import Foundation

let docID = UUID(uuidString: "6bf94a4d-cc66-4d87-a90d-be2500434e3d")!
var currentDoctor: Doctor?
var globalDoctor: [Doctor] = [
    Doctor(
        docID: docID,
        username: "admin",
        email: "meera.kumari@clinic.com",
        password: "Doc@1234",
        name: "Dr. Meera Kumari",
        dob: makeDate(1990, 3, 15),
        address: "Bengaluru, Karnataka",
        experience: 15,
        doctorImage: "profile",
        qualification: "MBBS, MD (Psychiatry)",
        registrationNumber: "KMC-2005-04821",
        identityNumber: "AADHAAR-9876-5432-1012",
        educationImageData: "image",
        registrationImageData: "image",
        identityImageData: "image"
    ),
    Doctor(
        docID: UUID(),
        username: "dr.priya_mehta",
        email: "priya.mehta@clinic.com",
        password: "Doc@1234",
        name: "Dr. Priya Mehta",
        dob: makeDate(1990, 3, 15),
        address: "45, Linking Road, Mumbai, Maharashtra",
        experience: 10,
        doctorImage: "Image",
        qualification: "MBBS, DPM (Psychological Medicine)",
        registrationNumber: "MMC-2010-07634",
        identityNumber: "AADHAAR-8765-4321-0923",
        educationImageData: "image",
        registrationImageData: "image",
        identityImageData: "image"
    ),
    Doctor(
        docID: UUID(),
        username: "dr.rohan_verma",
        email: "rohan.verma@clinic.com",
        password: "Doc@1234",
        name: "Dr. Rohan Verma",
        dob: makeDate(1990, 3, 15),
        address: "7, Sector 18, Noida, Uttar Pradesh",
        experience: 20,
        doctorImage: "Image 1",
        qualification: "MBBS, MD (Neurology), Fellowship in Psychiatry",
        registrationNumber: "DMC-2003-03312",
        identityNumber: "AADHAAR-7654-3210-8834",
        educationImageData: nil,
        registrationImageData: nil,
        identityImageData: nil
    ),
    Doctor(
        docID: UUID(),
        username: "dr.sneha_iyer",
        email: "sneha.iyer@clinic.com",
        password: "Doc@1234",
        name: "Dr. Sneha Iyer",
        dob: makeDate(1990, 3, 15),
        address: "23, Anna Nagar, Chennai, Tamil Nadu",
        experience: 8,
        doctorImage: "Image",
        qualification: "MBBS, MD (Psychiatry), CBT Certified",
        registrationNumber: "TNMC-2015-09821",
        identityNumber: "AADHAAR-6543-2109-7745",
        educationImageData: nil,
        registrationImageData: nil,
        identityImageData: nil
    ),
    Doctor(
        docID: UUID(),
        username: "dr.kabir_nair",
        email: "kabir.nair@clinic.com",
        password: "Doc@1234",
        name: "Dr. Kabir Nair",
        dob: makeDate(1990, 3, 15),
        address: "8, Indiranagar, Bengaluru, Karnataka",
        experience: 25,
        doctorImage: "Image 1",
        qualification: "MBBS, MD (Psychiatry), PhD (Clinical Psychology)",
        registrationNumber: "KMC-2000-01123",
        identityNumber: "AADHAAR-5432-1098-6656",
        educationImageData: nil,
        registrationImageData: nil,
        identityImageData: nil
    )
]
var globalPatient: [Patient] = [
    Patient(
        patientID: UUID(), docID: docID,
        name: "Aarav Sharma", email: "aarav.sharma@email.com", password: "Pass@1234",
        contact: "+91-9876543210",
        dob: makeDate(1990, 3, 15),
        nextSessionDate: makeDate(2026, 3, 14, hour: 10, minute: 0),
        imageURL: "https://picsum.photos/200.jpg", address: "12, MG Road, Bengaluru, Karnataka",
        condition: "Generalized Anxiety Disorder", sessionStatus: true, mood: 6,
        previousSessionDate: makeDate(2025, 3, 15, hour: 10, minute: 0)
    ),
    Patient(
        patientID: UUID(), docID: docID,
        name: "Priya Mehta", email: "priya.mehta@email.com", password: "Pass@1234",
        contact: "+91-9823456789",
        dob: makeDate(1995, 7, 22),
        nextSessionDate: makeDate(2026, 3, 14, hour: 11, minute: 30),
        imageURL: "https://picsum.photos/200.jpg", address: "45, Linking Road, Mumbai, Maharashtra",
        condition: "Major Depressive Disorder", sessionStatus: false, mood: 3,
        previousSessionDate: makeDate(2025, 3, 20, hour: 11, minute: 30)
    ),
    Patient(
        patientID: UUID(), docID: docID,
        name: "Rohan Verma", email: "rohan.verma@email.com", password: "Pass@1234",
        contact: "+91-9845671234",
        dob: makeDate(1988, 11, 5),
        nextSessionDate: makeDate(2026, 3, 14, hour: 9, minute: 0),
        imageURL: "https://picsum.photos/200.jpg", address: "7, Sector 18, Noida, Uttar Pradesh",
        condition: "PTSD", sessionStatus: true, mood: 5,
        previousSessionDate: makeDate(2025, 3, 22, hour: 9, minute: 0)
    ),
    Patient(
        patientID: UUID(), docID: docID,
        name: "Sneha Iyer", email: "sneha.iyer@email.com", password: "Pass@1234",
        contact: "+91-9901234567",
        dob: makeDate(1993, 1, 30),
        nextSessionDate: makeDate(2026, 3, 14, hour: 14, minute: 15),
        imageURL: "https://picsum.photos/200.jpg", address: "23, Anna Nagar, Chennai, Tamil Nadu",
        condition: "Bipolar Disorder", sessionStatus: nil, mood: 7,
        previousSessionDate: makeDate(2025, 3, 24, hour: 14, minute: 15)
    ),
    Patient(
        patientID: UUID(), docID: docID,
        name: "Kabir Nair", email: "kabir.nair@email.com", password: "Pass@1234",
        contact: "+91-9812345678",
        dob: makeDate(1985, 6, 18),
        nextSessionDate: makeDate(2026, 3, 14, hour: 16, minute: 0),
        imageURL: "https://picsum.photos/200.jpg", address: "8, Indiranagar, Bengaluru, Karnataka",
        condition: "OCD", sessionStatus: true, mood: 4,
        previousSessionDate: makeDate(2025, 3, 25, hour: 16, minute: 0)
    ),
    Patient(
        patientID: UUID(), docID: docID,
        name: "Ananya Gupta", email: "ananya.gupta@email.com", password: "Pass@1234",
        contact: "+91-9867345612",
        dob: makeDate(1997, 9, 12),
        nextSessionDate: makeDate(2026, 3, 14, hour: 10, minute: 30),
        imageURL: "https://picsum.photos/200.jpg", address: "56, Civil Lines, Delhi",
        condition: "Social Anxiety Disorder", sessionStatus: false, mood: 5,
        previousSessionDate: makeDate(2025, 3, 27, hour: 10, minute: 30)
    ),
    Patient(
        patientID: UUID(), docID: docID,
        name: "Vikram Singh", email: "vikram.singh@email.com", password: "Pass@1234",
        contact: "+91-9754321098",
        dob: makeDate(1982, 4, 25),
        nextSessionDate: makeDate(2026, 3, 14, hour: 13, minute: 0),
        imageURL: "https://picsum.photos/200.jpg", address: "34, Banjara Hills, Hyderabad, Telangana",
        condition: "Schizophrenia", sessionStatus: true, mood: 2,
        previousSessionDate: makeDate(2025, 3, 28, hour: 13, minute: 0)
    ),
    Patient(
        patientID: UUID(), docID: docID,
        name: "Meera Pillai", email: "meera.pillai@email.com", password: "Pass@1234",
        contact: "+91-9934567821",
        dob: makeDate(1991, 12, 8),
        nextSessionDate: makeDate(2026, 3, 14, hour: 15, minute: 45),
        imageURL: "https://picsum.photos/200.jpg", address: "19, Thrissur Road, Kochi, Kerala",
        condition: "Panic Disorder", sessionStatus: nil, mood: 6,
        previousSessionDate: makeDate(2025, 3, 29, hour: 15, minute: 45)
    ),
    Patient(
        patientID: UUID(), docID: docID,
        name: "Arjun Desai", email: "arjun.desai@email.com", password: "Pass@1234",
        contact: "+91-9878901234",
        dob: makeDate(1994, 2, 14),
        nextSessionDate: makeDate(2025, 4, 14, hour: 11, minute: 0),
        imageURL: "https://picsum.photos/200.jpg", address: "88, CG Road, Ahmedabad, Gujarat",
        condition: "ADHD", sessionStatus: true, mood: 8,
        previousSessionDate: makeDate(2025, 3, 31, hour: 11, minute: 0)
    ),
    Patient(
        patientID: UUID(), docID: docID,
        name: "Divya Reddy", email: "divya.reddy@email.com", password: "Pass@1234",
        contact: "+91-9745678903",
        dob: makeDate(1996, 8, 27),
        nextSessionDate: makeDate(2025, 4, 15, hour: 9, minute: 30),
        imageURL: "https://picsum.photos/200.jpg", address: "67, Jubilee Hills, Hyderabad, Telangana",
        condition: "Eating Disorder", sessionStatus: false, mood: 4,
        previousSessionDate: makeDate(2025, 4, 1, hour: 9, minute: 30)
    ),
    Patient(
        patientID: UUID(), docID: docID,
        name: "Nikhil Joshi", email: "nikhil.joshi@email.com", password: "Pass@1234",
        contact: "+91-9823109876",
        dob: makeDate(1989, 5, 3),
        nextSessionDate: makeDate(2025, 4, 16, hour: 12, minute: 0),
        imageURL: "https://picsum.photos/200.jpg", address: "14, Shivajinagar, Pune, Maharashtra",
        condition: "Insomnia Disorder", sessionStatus: true, mood: 5,
        previousSessionDate: makeDate(2025, 4, 2, hour: 12, minute: 0)
    ),
    Patient(
        patientID: UUID(), docID: docID,
        name: "Pooja Kapoor", email: "pooja.kapoor@email.com", password: "Pass@1234",
        contact: "+91-9867098765",
        dob: makeDate(1992, 10, 19),
        nextSessionDate: makeDate(2025, 4, 17, hour: 14, minute: 30),
        imageURL: "https://picsum.photos/200.jpg", address: "3, Rajouri Garden, New Delhi",
        condition: "Borderline Personality Disorder", sessionStatus: nil, mood: 3,
        previousSessionDate: makeDate(2025, 4, 3, hour: 14, minute: 30)
    ),
    Patient(
        patientID: UUID(), docID: docID,
        name: "Rahul Banerjee", email: "rahul.banerjee@email.com", password: "Pass@1234",
        contact: "+91-9812098765",
        dob: makeDate(1987, 3, 9),
        nextSessionDate: makeDate(2025, 4, 18, hour: 10, minute: 15),
        imageURL: "https://picsum.photos/200.jpg", address: "22, Salt Lake, Kolkata, West Bengal",
        condition: "Substance Use Disorder", sessionStatus: true, mood: 4,
        previousSessionDate: makeDate(2025, 4, 4, hour: 10, minute: 15)
    ),
    Patient(
        patientID: UUID(), docID: docID,
        name: "Ishita Malhotra", email: "ishita.malhotra@email.com", password: "Pass@1234",
        contact: "+91-9798765432",
        dob: makeDate(1998, 6, 2),
        nextSessionDate: makeDate(2025, 4, 19, hour: 11, minute: 30),
        imageURL: "https://picsum.photos/200.jpg", address: "9, Vasant Vihar, New Delhi",
        condition: "Dysthymia", sessionStatus: false, mood: 5,
        previousSessionDate: makeDate(2025, 4, 5, hour: 11, minute: 30)
    ),
    Patient(
        patientID: UUID(), docID: docID,
        name: "Siddharth Rao", email: "siddharth.rao@email.com", password: "Pass@1234",
        contact: "+91-9765432109",
        dob: makeDate(1990, 9, 17),
        nextSessionDate: makeDate(2025, 4, 21, hour: 13, minute: 30),
        imageURL: "https://picsum.photos/200.jpg", address: "5, Koramangala, Bengaluru, Karnataka",
        condition: "Adjustment Disorder", sessionStatus: true, mood: 6,
        previousSessionDate: makeDate(2025, 4, 7, hour: 13, minute: 30)
    ),
    Patient(
        patientID: UUID(), docID: docID,
        name: "Kavya Menon", email: "kavya.menon@email.com", password: "Pass@1234",
        contact: "+91-9745123456",
        dob: makeDate(1993, 4, 11),
        nextSessionDate: makeDate(2025, 4, 22, hour: 15, minute: 0),
        imageURL: "https://picsum.photos/200.jpg", address: "11, Marathahalli, Bengaluru, Karnataka",
        condition: "Agoraphobia", sessionStatus: nil, mood: 4,
        previousSessionDate: makeDate(2025, 4, 8, hour: 15, minute: 0)
    ),
    Patient(
        patientID: UUID(), docID: docID,
        name: "Aditya Kulkarni", email: "aditya.kulkarni@email.com", password: "Pass@1234",
        contact: "+91-9856234567",
        dob: makeDate(1986, 7, 29),
        nextSessionDate: makeDate(2025, 4, 23, hour: 9, minute: 45),
        imageURL: "https://picsum.photos/200.jpg", address: "78, Deccan Gymkhana, Pune, Maharashtra",
        condition: "Narcissistic Personality Disorder", sessionStatus: true, mood: 3,
        previousSessionDate: makeDate(2025, 4, 9, hour: 9, minute: 45)
    ),
    Patient(
        patientID: UUID(), docID: docID,
        name: "Riya Saxena", email: "riya.saxena@email.com", password: "Pass@1234",
        contact: "+91-9934123456",
        dob: makeDate(1999, 2, 5),
        nextSessionDate: makeDate(2025, 4, 24, hour: 16, minute: 30),
        imageURL: "https://picsum.photos/200.jpg", address: "33, Hazratganj, Lucknow, Uttar Pradesh",
        condition: "Separation Anxiety Disorder", sessionStatus: false, mood: 7,
        previousSessionDate: makeDate(2025, 4, 10, hour: 16, minute: 30)
    ),
    Patient(
        patientID: UUID(), docID: docID,
        name: "Manish Tiwari", email: "manish.tiwari@email.com", password: "Pass@1234",
        contact: "+91-9823456701",
        dob: makeDate(1984, 12, 22),
        nextSessionDate: makeDate(2025, 4, 25, hour: 8, minute: 30),
        imageURL: "https://picsum.photos/200.jpg", address: "6, Alkapuri, Vadodara, Gujarat",
        condition: "Intermittent Explosive Disorder", sessionStatus: true, mood: 2,
        previousSessionDate: makeDate(2025, 4, 11, hour: 8, minute: 30)
    ),
    Patient(
        patientID: UUID(), docID: docID,
        name: "Simran Kaur", email: "simran.kaur@email.com", password: "Pass@1234",
        contact: "+91-9878123456",
        dob: makeDate(1995, 5, 14),
        nextSessionDate: makeDate(2025, 4, 26, hour: 12, minute: 15),
        imageURL: "https://picsum.photos/200.jpg", address: "21, Sector 17, Chandigarh",
        condition: "Specific Phobia",  sessionStatus: nil, mood: 8,
        previousSessionDate: makeDate(2025, 4, 12, hour: 12, minute: 15)
    )
]

func getCurrentDoctor(_ username:String){
    currentDoctor = globalDoctor.first { $0.username == username }
}

func makeDate(_ year: Int, _ month: Int, _ day: Int, hour: Int = 0, minute: Int = 0) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = minute
    return Calendar.current.date(from: components)!
}

func getPatientData() -> [Patient] {
    return []
}

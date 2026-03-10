//
//  supabaseFunctions.swift
//  wellSync
//
//  Created by Vidit Agarwal on 14/02/26.
//

import Supabase
import UIKit

class AccessSupabase{
    func fetchDoctors() async {
        Task {
            do {
                let response = try await SupabaseManager.shared.client
                    .database
                    .from("doctor")
                    .select()
                    .execute()

                let doctors = try JSONDecoder().decode([Doctor].self, from: response.data)

                for i in doctors{
                    print(i,"\n")
                }
            } catch {
                print("Error:", error)
            }
        }
    }


    func fetchPatients(for doctorId: UUID) async {
        do {
            let response = try await SupabaseManager.shared.client
                .database
                .from("patients")
                .select()
                .eq("doc_id", value: doctorId.uuidString)
                .execute()

            print(String(data: response.data, encoding: .utf8)!)

            let patients = try JSONDecoder().decode([Patient].self, from: response.data)
            print(patients)

        } catch {
            print("Supabase Error:", error)
        }
    }



    private static func parseDate(_ string: String) -> Date? {
        // ISO 8601 (e.g., 2025-11-23T10:15:30Z)
        let iso = ISO8601DateFormatter()
        if let d = iso.date(from: string) { return d }

        // yyyy-MM-dd
        let df1 = DateFormatter()
        df1.locale = Locale(identifier: "en_US_POSIX")
        df1.dateFormat = "yyyy-MM-dd"
        if let d = df1.date(from: string) { return d }

        // yyyy-MM-dd HH:mm:ss
        let df2 = DateFormatter()
        df2.locale = Locale(identifier: "en_US_POSIX")
        df2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df2.date(from: string)
    }
}

//
//  TabBar.swift
//  wellSync
//
//  Created by Vidit Agarwal on 23/03/26.
//

import UIKit

class TabBar: UITabBarController {
    
    var patient: Patient? {
        didSet {
            print("Patient set in TabBar ✅")
            passPatientToChildren()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        passPatientToChildren()
    }

    private func passPatientToChildren() {
        guard let patient = patient else {
            print("TabBar: patient still nil ❌")
            return
        }

        viewControllers?.forEach { controller in
            
            if let nav = controller as? UINavigationController,
               let vc = nav.viewControllers.first {

                if let dashboard = vc as? DashboardCollectionViewController {
                    dashboard.patient = patient
                }

                if let activity = vc as? ActivityTableViewController {
                    activity.patient = patient
                }

                if let vitals = vc as? PatientVitalsCollectionViewController {
                    vitals.patient = patient
                }

                if let notes = vc as? PatientNotesCollectionViewController {
                    notes.patient = patient
                }
            }
        }
    }
}

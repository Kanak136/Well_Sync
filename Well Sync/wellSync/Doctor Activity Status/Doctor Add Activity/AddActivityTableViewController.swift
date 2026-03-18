//
//  AddActivityTableViewController.swift
//  wellSync
//
//  Created by Vidit Saran Agarwal on 07/02/26.
//

import UIKit

class AddActivityTableViewController: UITableViewController {

    @IBOutlet weak var activityListButton: UIButton!
    @IBOutlet weak var frequencyButton: UIButton!
    @IBOutlet weak var activityTimingButton: UIButton!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var doctorNote: UITextView!
    @IBOutlet weak var activityCell: UITableViewCell!
    @IBOutlet weak var nameCell: UITableViewCell!
    @IBOutlet weak var typeCell: UITableViewCell!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    var patient: Patient?
    var isCustomSelected = false
    var onSave: ((AssignedActivity) -> Void)?   

    override func viewDidLoad() {
        super.viewDidLoad()

        doctorNote.layer.cornerRadius = 20
        doctorNote.clipsToBounds = true
        setupActivityMenu()
        startDatePicker.date = Date()
        endDatePicker.date   = Date()
    }
    func setupActivityMenu() {

        let activityList = [
            "Morning Walk",
            "Breathing Exercise",
            "Journaling",
            "Art",
            "Yoga",
            "Meditation",
            "Exercise",
            "Reading"
        ]
        let frequencyList = ["Once a day", "Twice a day", "Three times a day", "Alternate days"]
        let timingList = ["Morning","Afternoon", "Evening"]
        let typeList = ["Upload","Timer"]

        let activityActions = activityList.map { option in
            UIAction(title: option) { [weak self] _ in
                guard let self = self else { return }

                self.activityListButton.setTitle(option, for: .normal)
                self.toggleCustomRows(show: false)
            }
        }
        let custom = UIAction(title: "Custom") { [weak self] _ in
            guard let self = self else { return }

            self.activityListButton.setTitle("Custom", for: .normal)
            self.toggleCustomRows(show: true)
        }
        let customGroup = UIMenu(options: .displayInline, children: [
            custom
        ])
        
        let mainGroup = UIMenu(options: .displayInline, children: activityActions)
            
        activityListButton.menu = UIMenu(children: [mainGroup, customGroup])
        activityListButton.showsMenuAsPrimaryAction = true


            // Frequency
        let frequencyActions = frequencyList.map { option in
            UIAction(title: option) { [weak self] _ in
                self?.frequencyButton.setTitle(option, for: .normal)
            }
        }


        frequencyButton.menu = UIMenu(children: frequencyActions)
        frequencyButton.showsMenuAsPrimaryAction = true


            // Timing
        let timingActions = timingList.map { option in
            UIAction(title: option) { [weak self] _ in
                self?.activityTimingButton.setTitle(option, for: .normal)
            }
        }


        activityTimingButton.menu = UIMenu(children: timingActions)
        activityTimingButton.showsMenuAsPrimaryAction = true
        
            // Type
        let typeActions = typeList.map { option in
            UIAction(title: option) { [weak self] _ in
                self?.typeButton.setTitle(option, for: .normal)
            }
        }


        typeButton.menu = UIMenu(children: typeActions)
        typeButton.showsMenuAsPrimaryAction = true
        
        
        }

        func toggleCustomRows(show: Bool) {

            guard show != isCustomSelected else { return }

            isCustomSelected = show

            let indexPaths = [
                IndexPath(row: 1, section: 0),
                IndexPath(row: 2, section: 0)
            ]

            tableView.beginUpdates()

            if isCustomSelected {
                tableView.insertRows(at: indexPaths, with: .fade)
            } else {
                tableView.deleteRows(at: indexPaths, with: .fade)
            }

            tableView.endUpdates()
        }
        override func tableView(_ tableView: UITableView,
                                numberOfRowsInSection section: Int) -> Int {

            if section == 0 {
                return isCustomSelected ? 3 : 1
            }

            return super.tableView(tableView, numberOfRowsInSection: section)
        }


        override func tableView(_ tableView: UITableView,
                                cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            if indexPath.section == 0 {

                switch indexPath.row {
                case 0:
                    return activityCell
                case 1:
                    return nameCell
                case 2:
                    return typeCell
                default:
                    break
                }
            }

            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let patientID = patient?.patientID else {
            showAlert("Patient info missing.")
            return
        }

            // 1. Get selected activity name from button
            let selectedName = activityListButton.title(for: .normal) ?? ""
            guard !selectedName.isEmpty, selectedName != "Select" else {
                showAlert("Please select an activity."); return
            }

            // 2. Find activity in catalog by name
            guard let activity = activityCatalog.first(where: {
                $0.name.lowercased() == selectedName.lowercased()
            }) else {
                showAlert("Activity not found in catalog."); return
            }

            // 3. Get frequency
            guard let frequency = resolveFrequency() else {
                showAlert("Please select a frequency."); return
            }

            // 4. Validate dates
            let start = startDatePicker.date
            let end   = endDatePicker.date
            guard end >= start else {
                showAlert("End date must be after start date."); return
            }

            // 5. Create the AssignedActivity
            let newAssignment = AssignedActivity(
                assignedID: UUID(),
                activityID: activity.activityID,
                patientID:  patientID,
                doctorID:   patient!.docID,
                frequency:  frequency,
                startDate:  start,
                endDate:    end,
                doctorNote: doctorNote.text ?? "",
                status:     .active
            )
        
        print("total assignedActivities count: \(assignedActivities.count)")
            // 6. Append directly to the global array
            assignedActivities.append(newAssignment)

            // 7. Fire closure so the list VC can reload
            onSave?(newAssignment)
            
        // ADD temporarily before dismiss(animated: true)
        print("Saved: \(newAssignment.assignedID)")
        print("isActiveToday: \(newAssignment.isActiveToday)")
        print("total assignedActivities count: \(assignedActivities.count)")
            dismiss(animated: true)
        }

        // ← ADD
        @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
            dismiss(animated: true)
        }

        // ← ADD
    private func resolveFrequency() -> Int? {
        switch frequencyButton.title(for: .normal) {
        case "Once a day":          return 1
        case "Twice a day":         return 2
        case "Three times a day":   return 3
        case "Alternate days":      return 1
        default:                    return nil
        }
    }

        // ← ADD
        private func showAlert(_ message: String) {
            let alert = UIAlertController(title: "Missing Info",
                                          message: message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

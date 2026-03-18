////
////  ActivityTableViewController.swift
////  patientSide
////
////  Created by Rishika Mittal on 27/01/26.
////
//

// ActivityTableViewController.swift
import UIKit

class ActivityTableViewController: UITableViewController {

    // MARK: - Data
    var todayItems:   [TodayActivityItem] = []
    var logSummaries: [LogSummaryItem]    = []        // ← was missing, caused the error

    let currentPatientID = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
    let sectionTitles    = ["Today", "Logs"]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle     = .none
        tableView.rowHeight          = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        loadData()
    }

    // MARK: - Data Loading
    private func loadData() {
        let today = Date()

        todayItems = buildTodayItems(for: currentPatientID).map { item in
            let todayLogs = item.logs.filter {
                Calendar.current.isDate($0.date, inSameDayAs: today)
            }
            return TodayActivityItem(
                activity: item.activity,
                assignment: item.assignment,
                completedToday: todayLogs.count,
                type: item.type,
                logs: todayLogs
            )
        }
        logSummaries = buildLogSummaries(for: currentPatientID)
        tableView.reloadData()
    }

    // MARK: - Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:  return todayItems.count
        case 1:  return logSummaries.count    // ← was logItems.count
        default: return 0
        }
    }

    // MARK: - Cell
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "activityCell",
            for: indexPath
        ) as! TodayTableViewCell

        if indexPath.section == 0 {
            cell.configure(with: todayItems[indexPath.row])
        } else {
            let summary = logSummaries[indexPath.row]   // ← now works
            cell.configureAsLog(
                activityName: summary.activity.name,
                iconName:     summary.activity.iconName,
                logCount:     summary.totalLogs
            )
        }

        return cell
    }

    // MARK: - Section Headers
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {

        let headerView    = UIView()

        let titleLabel    = UILabel()
        titleLabel.font   = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.textColor = .label

        let subtitleLabel    = UILabel()
        subtitleLabel.font   = UIFont.preferredFont(forTextStyle: .footnote)
        subtitleLabel.textColor = .secondaryLabel

        if section == 0 {
            let completed      = todayItems.filter { $0.isCompletedToday }.count
            let pending        = todayItems.count - completed
            titleLabel.text    = "Today"
            subtitleLabel.text = "\(pending) pending · \(completed) completed"
        } else {
            titleLabel.text    = "Logs"
            subtitleLabel.text = "\(logSummaries.count) activities logged"
        }

        titleLabel.translatesAutoresizingMaskIntoConstraints    = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),

            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0)
        ])

        return headerView
    }

    override func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

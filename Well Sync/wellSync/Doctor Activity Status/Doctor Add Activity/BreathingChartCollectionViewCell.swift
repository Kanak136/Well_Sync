//
//  BreathingChartCollectionViewCell.swift
//  sample
//
//  Created by Pranjal on 01/04/26.
//
//

//
//  BreathingChartCollectionViewCell.swift
//  wellSync
//

import Charts
import UIKit
import DGCharts

class BreathingChartCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var chartView: LineChartView!

    override func awakeFromNib() {
        super.awakeFromNib()

        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cardView.layer.shadowRadius = 6

        styleChart()
    }

    // MARK: - One-time chart styling

    private func styleChart() {
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        chartView.chartDescription.enabled = false

        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.granularity = 1

        chartView.leftAxis.gridColor = UIColor.systemGray4
        chartView.leftAxis.gridLineWidth = 0.5
        chartView.leftAxis.axisMinimum = 0

        chartView.drawBordersEnabled = false
        chartView.noDataText = "No activity logged"
        chartView.noDataTextColor = .secondaryLabel
    }

    // MARK: - Main configure entry point

    /// - Parameters:
    ///   - logs: All logs for this activity (unfiltered — we filter internally by week/month)
    ///   - mode: 0 = weekly, 1 = monthly
    ///   - referenceDate: The date the user tapped on the calendar (or today by default)
    func configure(with logs: [ActivityLog], mode: Int, referenceDate: Date) {
        if mode == 0 {
            configureWeekly(logs: logs, referenceDate: referenceDate)
        } else {
            configureMonthly(logs: logs, referenceDate: referenceDate)
        }
    }

    // MARK: - Weekly (Sun → Sat of the week containing referenceDate)

    private func configureWeekly(logs: [ActivityLog], referenceDate: Date) {
        let calendar = Calendar.current

        // --- Step 1: Find Sunday of the week containing referenceDate ---
        // weekday: 1=Sun, 2=Mon ... 7=Sat
        let weekday = calendar.component(.weekday, from: referenceDate)
        let daysFromSunday = weekday - 1   // 0 if already Sunday
        guard let weekStart = calendar.date(
            byAdding: .day,
            value: -daysFromSunday,
            to: calendar.startOfDay(for: referenceDate)
        ) else { return }

        // --- Step 2: Build 7 day slots (Sun=0 … Sat=6) ---
        let dayLabels = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        var minutesPerSlot: [Double] = Array(repeating: 0.0, count: 7)

        for log in logs {
            let logDay = calendar.startOfDay(for: log.date)
            let diff = calendar.dateComponents([.day], from: weekStart, to: logDay).day ?? -1
            // diff 0…6 means it falls within this week
            if diff >= 0 && diff < 7 {
                minutesPerSlot[diff] += Double(log.duration ?? 0) / 60.0
            }
        }

        applyToChart(entries: minutesPerSlot, labels: dayLabels)
    }

    // MARK: - Monthly (day 1 → last day of the month containing referenceDate)

    private func configureMonthly(logs: [ActivityLog], referenceDate: Date) {
        let calendar = Calendar.current

        // --- Step 1: Find the first day and number of days in the month ---
        let components = calendar.dateComponents([.year, .month], from: referenceDate)
        guard
            let firstOfMonth = calendar.date(from: components),
            let range = calendar.range(of: .day, in: .month, for: firstOfMonth)
        else { return }

        let daysInMonth = range.count   // 28, 29, 30, or 31

        // --- Step 2: Build N-slot array (index 0 = day 1) ---
        var minutesPerDay: [Double] = Array(repeating: 0.0, count: daysInMonth)

        for log in logs {
            let logComponents = calendar.dateComponents([.year, .month, .day], from: log.date)
            // Must be same year + month
            guard
                logComponents.year  == components.year,
                logComponents.month == components.month,
                let day = logComponents.day,
                day >= 1 && day <= daysInMonth
            else { continue }

            minutesPerDay[day - 1] += Double(log.duration ?? 0) / 60.0
        }

        // --- Step 3: Build x-axis labels (show every 5th day to avoid crowding) ---
        let labels: [String] = (1...daysInMonth).map { day in
            day % 5 == 1 ? "\(day)" : ""
        }

        applyToChart(entries: minutesPerDay, labels: labels)
    }

    // MARK: - Shared chart rendering

    private func applyToChart(entries minutesArray: [Double], labels: [String]) {
        // Build ChartDataEntry array
        let chartEntries = minutesArray.enumerated().map { index, value in
            ChartDataEntry(x: Double(index), y: value)
        }

        // Dataset styling
        let dataSet = LineChartDataSet(entries: chartEntries)
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 3
        dataSet.setColor(.systemTeal)
        dataSet.circleColors = [.systemTeal]
        dataSet.circleRadius = 4
        dataSet.drawValuesEnabled = false
        dataSet.drawFilledEnabled = true
        dataSet.fillColor = UIColor.systemTeal.withAlphaComponent(0.15)
        dataSet.fillAlpha = 1.0

        // Apply data
        chartView.data = LineChartData(dataSet: dataSet)

        // Apply labels
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        chartView.xAxis.labelCount = labels.count

        chartView.notifyDataSetChanged()
        chartView.animate(xAxisDuration: 0.4)
    }
}
//import Charts
//import UIKit
//import DGCharts
//
//
//class BreathingChartCollectionViewCell: UICollectionViewCell {
//   
//    @IBOutlet weak var cardView: UIView!
//    @IBOutlet weak var chartView: LineChartView!
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        cardView.layer.cornerRadius = 20
//        cardView.layer.shadowColor = UIColor.black.cgColor
//        cardView.layer.shadowOpacity = 0.08
//        cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
//        cardView.layer.shadowRadius = 6
//        setupChart()
//    }
//
//    func setupChart() {
//
//        let entries = [
//            ChartDataEntry(x:0,y:2),
//            ChartDataEntry(x:1,y:6),
//            ChartDataEntry(x:2,y:3),
//            ChartDataEntry(x:3,y:7),
//            ChartDataEntry(x:4,y:1),
//            ChartDataEntry(x:5,y:5),
//            ChartDataEntry(x:6,y:4)
//        ]
//
//        let dataSet = LineChartDataSet(entries: entries)
//
//        dataSet.mode = .cubicBezier
//        dataSet.lineWidth = 3
//        dataSet.setColor(.systemTeal)
//        dataSet.circleColors = [.systemTeal]
//        dataSet.drawValuesEnabled = false
//
//        chartView.data = LineChartData(dataSet: dataSet)
//
//        chartView.rightAxis.enabled = false
//        chartView.legend.enabled = false
//        chartView.chartDescription.enabled = false
//        chartView.xAxis.drawGridLinesEnabled = false
//        
//        chartView.leftAxis.gridColor = UIColor.systemGray4
//        chartView.xAxis.gridColor = UIColor.systemGray4
//        chartView.leftAxis.gridLineWidth = 0.5
//        chartView.xAxis.gridLineWidth = 0.5
//        chartView.drawBordersEnabled = false
//
//        chartView.noDataText = ""
//
//        let days = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
//        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
//        chartView.xAxis.granularity = 1
//    }
//}

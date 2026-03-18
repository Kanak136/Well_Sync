//
//  BarChartCollectionViewCell.swift
//  wellSync
//
//  Created by Vidit Agarwal on 04/02/26.
//

import UIKit
import DGCharts

class MoodChartCollectionViewCell: UICollectionViewCell, ChartViewDelegate {
    
    @IBOutlet weak var moodChartView: LineChartView!
    
    // MARK: - Public Properties
    var moodLogs: [MoodLog] = [] {
        didSet {
            setData()
        }
    }
    var isWeekly: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupChart()
    }
    
    func setupChart() {
        moodChartView.backgroundColor = .clear
        moodChartView.chartDescription.enabled = false
        moodChartView.legend.enabled = false
        moodChartView.dragEnabled = true
        moodChartView.setScaleEnabled(false)
        
        // X Axis
        let xAxis = moodChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = .lightGray
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1
        xAxis.avoidFirstLastClippingEnabled = true
        
        // Disable left axis
        moodChartView.leftAxis.enabled = false
        let rightAxis = moodChartView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelTextColor = .lightGray
        rightAxis.gridColor = UIColor.darkGray.withAlphaComponent(0.3)
        rightAxis.axisMinimum = 1
        rightAxis.axisMaximum = 5
        rightAxis.granularity = 1
        rightAxis.granularityEnabled = true
        rightAxis.labelCount = 5
        rightAxis.forceLabelsEnabled = true
        rightAxis.drawAxisLineEnabled = false
        
        moodChartView.noDataText = "NO DATA AVAILABLE"
        moodChartView.noDataTextColor = .secondaryLabel
        moodChartView.noDataFont = .systemFont(ofSize: 18, weight: .semibold)
        
        moodChartView.highlightPerTapEnabled = true
        moodChartView.xAxis.granularity = 1
        moodChartView.xAxis.valueFormatter = TimeFormatter()
        moodChartView.extraTopOffset = 20
        moodChartView.setViewPortOffsets(left: 16, top: 30, right: 50, bottom: 30)
    }
    
    func setData() {
        if moodLogs.isEmpty {
            moodChartView.data = nil
            moodChartView.setNeedsDisplay()
            return
        }
        
        let sortedLogs = moodLogs.sorted { ($0.date ?? Date()) < ($1.date ?? Date()) }
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = isWeekly ? "EEE" : "d"
        
        var entries: [ChartDataEntry] = []
        var dayLabels: [String] = []
        
        var lastDayLabel = ""
        for (index, log) in sortedLogs.enumerated() {
            entries.append(ChartDataEntry(x: Double(index), y: Double(log.mood)))
            
            if let date = log.date {
                let dayStr = dayFormatter.string(from: date)
                if dayStr != lastDayLabel {
                    dayLabels.append(dayStr)
                    lastDayLabel = dayStr
                } else {
                    dayLabels.append("")
                }
            } else {
                dayLabels.append("")
            }
        }
        
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.mode = .cubicBezier
        dataSet.cubicIntensity = 0.25
        dataSet.setColor(.systemCyan)
        dataSet.lineWidth = 3
        dataSet.drawCirclesEnabled = true
        dataSet.circleRadius = 4
        dataSet.setCircleColor(.systemCyan)
        dataSet.circleHoleColor = .white
        dataSet.circleHoleRadius = 2
        
        let gradientColors = [
            UIColor.systemCyan.withAlphaComponent(0.7).cgColor,
            UIColor.clear.cgColor
        ] as CFArray
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors, locations: nil)!
        dataSet.fill = LinearGradientFill(gradient: gradient, angle: 90)
        dataSet.drawFilledEnabled = true
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.highlightColor = .white
        
        let data = LineChartData(dataSet: dataSet)
        data.setDrawValues(false)
        moodChartView.data = data
        
        moodChartView.xAxis.valueFormatter = WeekFormatter(labels: dayLabels)
        moodChartView.xAxis.axisMinimum = 1
        moodChartView.xAxis.axisMaximum = Double(entries.count - 1)
        
        let marker = MoodBubbleMarker()
        marker.chartView = moodChartView
        marker.sortedLogs = sortedLogs
        moodChartView.marker = marker
    }
}

class WeekFormatter: AxisValueFormatter {
    var labels: [String]
    init(labels: [String]) {
        self.labels = labels
    }
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        if index >= 0 && index < labels.count {
            return labels[index]
        }
        return ""
    }
}

class TimeFormatter: AxisValueFormatter {
    var timers: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        var time: [String] = []
        for i in weeklyMoodLog {
            time.append(formatter.string(from: i.date ?? Date()))
        }
        return time
    }
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        if index >= 0 && index < timers.count {
            return timers[index]
        }
        return ""
    }
}

class MoodBubbleMarker: MarkerView {
    private let label = UILabel()
    private let padding: CGFloat = 10
    var sortedLogs: [MoodLog] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.85)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        addSubview(label)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let index = highlight.dataIndex >= 0 ? highlight.dataIndex : Int(entry.x)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE, d MMM"
        
        var timeStr = ""
        var dayStr = ""
        
        if index < sortedLogs.count, let date = sortedLogs[index].date {
            timeStr = timeFormatter.string(from: date)
            dayStr = dayFormatter.string(from: date)
        }
        
        label.text = "\(dayStr)  \(timeStr)  Mood \(Int(entry.y))"
        label.sizeToFit()
        
        frame.size = CGSize(
            width: label.frame.width + padding * 2,
            height: label.frame.height + padding
        )
        label.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
    }
    
}

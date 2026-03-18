//
//  SummmaryMoodTableViewCell.swift
//  wellSync
//
//  Created by Vidit Saran Agarwal on 07/02/26.
//

import UIKit
import DGCharts

class SummmaryMoodTableViewCell: UITableViewCell{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sMoodCell", for: indexPath)
        return cell
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 8, right: 16))
    }
    var items: [String] = []

    @IBOutlet var lineChart:LineChartView!
    override func awakeFromNib() {
        super.awakeFromNib()
        showLineChart()
        
    }
    func showLineChart(){
        var perDayValues: [[Double]] = (0..<7).map { _ in
            let count = Int.random(in: 1...5)
            return (0..<count).map { _ in Double(Int.random(in: 1...5)) }
        }
        var detailedEntries: [ChartDataEntry] = []
        for (dayIndex, values) in perDayValues.enumerated() {
            let n = max(values.count, 1)
            for (idx, value) in values.enumerated() {
                let t = n == 1 ? 0.0 : Double(idx) / Double(n - 1)
                let x = Double(dayIndex) - 0.25 + 0.5 * t
                detailedEntries.append(ChartDataEntry(x: x, y: value))
            }
        }
        detailedEntries.sort { $0.x < $1.x }
        
        let avgEntries: [ChartDataEntry] = perDayValues.enumerated().map { (dayIndex, values) in
            let avg = values.reduce(0, +) / Double(values.count)
            return ChartDataEntry(x: Double(dayIndex), y: avg)
        }
        
        let detailedSet = LineChartDataSet(entries: detailedEntries, label: "Mood logs")
        detailedSet.mode = .linear
        detailedSet.lineWidth = 1.5
        detailedSet.setColor(.systemBlue)
        detailedSet.setCircleColor(.systemBlue)
        detailedSet.circleRadius = 2.5
        detailedSet.drawCirclesEnabled = true
        detailedSet.drawValuesEnabled = false
        detailedSet.highlightEnabled = false
        detailedSet.drawFilledEnabled = false
        
        let avgSet = LineChartDataSet(entries: avgEntries, label: "Daily average")
        avgSet.mode = .cubicBezier
        avgSet.lineWidth = 2.0
        avgSet.setColor(.systemGreen)
        avgSet.setCircleColor(.systemGreen)
        avgSet.circleRadius = 3
        avgSet.drawCirclesEnabled = true
        avgSet.drawValuesEnabled = false
        avgSet.highlightEnabled = false
        avgSet.drawFilledEnabled = false
        let data = LineChartData(dataSets: [detailedSet, avgSet])
        lineChart.data = data
        
        let dayLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let xAxis = lineChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.granularity = 1
        xAxis.axisMinimum = -0.5
        xAxis.axisMaximum = 6.5
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = IndexAxisValueFormatter(values: dayLabels)
        
        let leftAxis = lineChart.leftAxis
        leftAxis.axisMinimum = 0.0
        leftAxis.axisMaximum = 6.0
        leftAxis.granularity = 1
        leftAxis.drawGridLinesEnabled = true
        lineChart.rightAxis.enabled = false
        
        lineChart.legend.enabled = true
        lineChart.chartDescription.enabled = false
        lineChart.setScaleEnabled(false)
        lineChart.pinchZoomEnabled = false
        lineChart.doubleTapToZoomEnabled = false
        
        lineChart.animate(xAxisDuration: 0.4, yAxisDuration: 0.6, easingOption: .easeOutQuart)
    }
}

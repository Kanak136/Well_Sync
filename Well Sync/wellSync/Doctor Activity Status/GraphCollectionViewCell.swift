//
//  GraphCollectionViewCell.swift
//  wellSync
//
//  Created by Vidit Agarwal on 06/02/26.
//

import UIKit
import DGCharts
class GraphCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var barChart: BarChartView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        barchart()
    }
//    func barchart(){
//        // step 1
//        let days = ["Sun","Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
//        let values = [28, 50, 60, 30, 42, 91, 52]
//        
//        // step 2
//        var dataEntry: [BarChartDataEntry] = []
//        //step 3
//        for i in 0..<days.count {
//            let value = BarChartDataEntry(x: Double(i), y: Double(values[i]))
//            dataEntry.append(value)
//        }
//        // step 4
//        let dataSet = BarChartDataSet(entries: dataEntry, label: "Barchart Unit Test Data")
//        // step 5
//        let data = BarChartData(dataSet: dataSet)
//        
//        // step 6
//        barChart.data = data
//        data.barWidth = 0.5
//        dataSet.colors = [.red, .blue, .yellow, .green, .orange, .purple, .systemCyan]
//        barChart.xAxis.enabled = false
//        barChart.rightAxis.enabled = false
//        barChart.leftAxis.enabled = false
//        barChart.legend.enabled = false
//        barChart.leftAxis.enabled = false
//        barChart.animate(yAxisDuration: 1.0)
//    }
    func barchart() {

        let values = [5, 3, 1, 2, 3, 4, 5]

        var entries: [BarChartDataEntry] = []

        for i in 0..<values.count {
            entries.append(BarChartDataEntry(x: Double(i), y: Double(values[i])))
        }

        let dataSet = BarChartDataSet(entries: entries)

        dataSet.colors = [.systemOrange]      // single color
        dataSet.drawValuesEnabled = false   // hide value labels
        dataSet.highlightEnabled = false

        let data = BarChartData(dataSet: dataSet)
        data.barWidth = 0.6

        barChart.data = data

        // 🔥 Remove EVERYTHING
        barChart.legend.enabled = false
        barChart.chartDescription.enabled = false

        barChart.xAxis.enabled = false
        barChart.leftAxis.enabled = false
        barChart.rightAxis.enabled = false

        barChart.drawGridBackgroundEnabled = false
        barChart.drawBarShadowEnabled = false

        barChart.setScaleEnabled(false)
        barChart.doubleTapToZoomEnabled = false
        barChart.pinchZoomEnabled = false
        barChart.highlightPerTapEnabled = false

        // 🔥 remove extra padding
        barChart.minOffset = 0
        barChart.extraTopOffset = 0
        barChart.extraBottomOffset = 0
        barChart.extraLeftOffset = 0
        barChart.extraRightOffset = 0

        barChart.animate(yAxisDuration: 0.8)
    }

}

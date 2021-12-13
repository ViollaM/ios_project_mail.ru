//
//  SwipeChartCell.swift
//  StepperApp
//
//  Created by Ruben Egikian on 13.12.2021.
//

import Foundation
import UIKit
import Charts

final class SwipeChartCell: UICollectionViewCell {
    var week: SteppingWeek? {
        didSet {
            setupChartData(week: week)
        }
    }
    
    private let marker:BalloonMarker = BalloonMarker(color: StepColor.lineAndPointsChart, font: .systemFont(ofSize: 15, weight: .regular), textColor: UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 20.0, right: 7.0))
    
    private lazy var chart: LineChartView = {
        let chart = LineChartView()
        chart.dragEnabled = false
        chart.doubleTapToZoomEnabled = false
        chart.legend.enabled = false
        chart.extraRightOffset = 22
        
        marker.minimumSize = CGSize(width: 50.0, height: 25.0)
        chart.marker = marker
        
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChartData(week: nil)
        setupLayout()
        configureUI()
        setGradientBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setGradientBackground() {
        contentView.backgroundColor = .clear
    }
    
    private func setupLayout () {
        contentView.addSubview(chart)
        NSLayoutConstraint.activate([
            chart.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            chart.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            chart.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            chart.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        ])
    }
    
    private func configureUI () {
        setupChartUI()
    }
    
    private func setupChartData(week: SteppingWeek?){
        
        let getlabelCountByMax = [10000: 5,
                                  20000: 4,
                                  30000: 6,
                                  40000: 4,
                                  50000: 5,]
        
        var steps = [ChartDataEntry]()
        var days = [String]()
        if week == nil {
            for x in 0..<7{
                steps.append(ChartDataEntry(x: Double(x), y: Double(Int.random(in: 5000...40000))))
            }
            days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        } else {
            let week = week!
            
            if week.steppingDays.count == 7{
                for x in 0..<7{
                    steps.append(ChartDataEntry(x: Double(x), y: Double(week.steppingDays[x].steps)))
                    days.append(convertDateToWeekday(date: week.steppingDays[x].date))
                }
            } else {
                for x in 0..<week.steppingDays.count{
                    steps.append(ChartDataEntry(x: Double(x), y: Double(week.steppingDays[x].steps)))
                    days.append(convertDateToWeekday(date: week.steppingDays[x].date))
                }
                for x in week.steppingDays.count..<7{
                    steps.append(ChartDataEntry(x: Double(x), y: Double(0)))
                }
                days = getRightDays(days: days)
            }
            
        }
        
        var set: LineChartDataSet! = nil
        
        set = LineChartDataSet(entries: steps, label: "Week Steps")
        set.colors = [
            StepColor.lineAndPointsChart,
        ]
        set.circleColors.removeAll(keepingCapacity: false)
        set.lineWidth = 3
        set.circleColors.append(StepColor.lineAndPointsChart)
        set.drawValuesEnabled = {false}()
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.drawVerticalHighlightIndicatorEnabled = false
        
        let data = LineChartData(dataSet: set)
        chart.data = data
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values:days)
        
        let maxSteps = set.yMax
        let roundmaxSteps = (maxSteps/10000).rounded(.up)*10000
        chart.leftAxis.axisMaximum = roundmaxSteps
        chart.leftAxis.labelCount = getlabelCountByMax[Int(roundmaxSteps)] ?? 1
    }
    
    private func setupChartUI(){
        let weekAxis = chart.xAxis
        let leftAxis = chart.leftAxis
        let rightAxis = chart.rightAxis
        
        leftAxis.axisMinimum = 0
        leftAxis.labelFont = .systemFont(ofSize: 12, weight: .regular)
        leftAxis.xOffset = 12
        leftAxis.gridLineDashLengths = [4]
        leftAxis.axisLineDashLengths = [4]
        leftAxis.labelTextColor = UIColor(red: 32/255, green: 58/255, blue: 56/255, alpha: 1)
        leftAxis.gridColor = StepColor.gridChart
        leftAxis.axisLineColor = StepColor.gridChart
        
        rightAxis.drawLabelsEnabled = false
        rightAxis.drawGridLinesEnabled = false
        rightAxis.axisLineDashLengths = [4]
        rightAxis.axisLineColor = StepColor.gridChart
        
        weekAxis.granularity = 1
        weekAxis.drawGridLinesEnabled = false
        weekAxis.labelPosition = XAxis.LabelPosition.top
        weekAxis.labelFont = .systemFont(ofSize: 14, weight: .regular)
        weekAxis.labelRotatedHeight = 30
        weekAxis.yOffset = 15
        weekAxis.gridLineDashLengths = [4]
        weekAxis.axisLineDashLengths = [4]
        weekAxis.labelTextColor = UIColor(red: 32/255, green: 58/255, blue: 56/255, alpha: 1)
        weekAxis.gridColor = StepColor.gridChart
        weekAxis.axisLineColor = StepColor.gridChart
    }
}

private func convertDateToWeekday(date: Date) -> String{
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_EN")
    dateFormatter.dateFormat = "EEEE"
    
    let weekday = dateFormatter.string(from: date)
    let capitalizedWeekday = weekday.capitalized
    
    return String(capitalizedWeekday.prefix(3))
}


private func getRightDays(days: [String]) -> [String]{
    var new_days = days
    let days_list = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    let last_day_inx = days_list.firstIndex(of: days.last ?? "Mon")!
    
    for i in 1...(7-days.count){
        new_days.append(days_list[last_day_inx+i])
    }
    
    return new_days

}

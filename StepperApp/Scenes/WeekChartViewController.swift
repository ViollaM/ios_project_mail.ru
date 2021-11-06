//
//  WeekChartViewController.swift
//  StepperApp
//
//  Created by Стас Чебыкин on 23.10.2021.
//

import UIKit
import Charts


final class WeekChartViewController: UIViewController{

    private lazy var chart: LineChartView = {
        let chart = LineChartView()
        return chart
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        configureUI()
    }

    func setupLayout () {
        view.addSubview(chart)
        
        chart.pin
            .vCenter()
            .horizontally(32)
            .height(view.frame.height/2)
    }

    func configureUI () {
        setupChartData()
    }
}

extension WeekChartViewController {
    func setupChartData(){
        let values = (0..<7).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(100) + 3)
            return ChartDataEntry(x: Double(i), y: val, icon: nil)
        }
        let set = LineChartDataSet(entries: values, label: "Week steps")
        set.drawIconsEnabled = false
        setupDataSet(set)
        let value = ChartDataEntry(x: Double(3), y: 3)
        _ = set.addEntryOrdered(value)
        let data = LineChartData(dataSet: set)
        chart.data = data
    }
    private func setupDataSet(_ dataSet: LineChartDataSet) {
        dataSet.lineDashLengths = [5, 2.5]
        dataSet.highlightLineDashLengths = [5, 2.5]
        dataSet.setColor(.black)
        dataSet.setCircleColor(.black)
        dataSet.lineWidth = 1
        dataSet.circleRadius = 3
        dataSet.drawCircleHoleEnabled = false
        dataSet.valueFont = .systemFont(ofSize: 9)
        dataSet.formLineDashLengths = [5, 2.5]
        dataSet.formLineWidth = 1
        dataSet.formSize = 15
    }
}

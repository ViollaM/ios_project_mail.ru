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
        chart.translatesAutoresizingMaskIntoConstraints = false
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
        NSLayoutConstraint.activate([
            chart.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chart.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            chart.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            chart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            chart.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
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

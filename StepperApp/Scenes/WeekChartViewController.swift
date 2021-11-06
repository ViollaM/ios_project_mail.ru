//
//  WeekChartViewController.swift
//  StepperApp
//
//  Created by Стас Чебыкин on 23.10.2021.
//

import UIKit
import Charts


final class WeekChartViewController: UIViewController{

    private lazy var chart: BarChartView = {
        let chart = BarChartView()
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
            //chart..constraint(equalTo: view.centerYAnchor),
            chart.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            chart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            chart.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            chart.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }

    func configureUI () {
        setupChartData()
    }
}

extension WeekChartViewController {
    func setupChartData(){
        var steps = [BarChartDataEntry]()
        
        for x in 0..<7{
            steps.append(BarChartDataEntry(x: Double(x), y: Double(Int.random(in: 0...20000))))
        }
        
        var set: BarChartDataSet! = nil
       
        set = BarChartDataSet(entries: steps, label: "Week Steps")
        set.colors = [
            NSUIColor(cgColor: UIColor.systemGreen.cgColor),
        ]
        
        set.drawValuesEnabled = {false}()
        
        let data = BarChartData(dataSet: set)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
        data.barWidth = 0.75
        data.setDrawValues(false)
        chart.data = data
        
        chart.doubleTapToZoomEnabled = false
        chart.legend.enabled = false

        let weekAxis = chart.xAxis
        let leftAxis = chart.leftAxis
        let rightAxis = chart.rightAxis
        
        //rightAxis.removeAllLimitLines()
        //rightAxis.axisMaximum = 10000
        rightAxis.axisMinimum = 0
        //rightAxis.drawLimitLinesBehindDataEnabled = false
    
        leftAxis.drawLabelsEnabled = false
        leftAxis.gridColor = .clear
        leftAxis.axisMinimum = 0

        
        let days = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
        weekAxis.valueFormatter = IndexAxisValueFormatter(values:days)
        weekAxis.granularity = 1
        weekAxis.labelPosition = XAxis.LabelPosition.bottom
        
        //weekAxis.gridColor = .clear
        //rightAxis.gridColor = .clear
        
    }
}

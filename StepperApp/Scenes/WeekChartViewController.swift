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
        chart.dragEnabled = false
        chart.doubleTapToZoomEnabled = false
        chart.legend.enabled = false
        chart.extraRightOffset = 22
        
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        configureUI()
        setGradientBackground()
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 204/255, green: 228/255, blue: 225/255, alpha: 0.5).cgColor
        let colorBottom = UIColor(red: 204/255, green: 228/255, blue: 225/255, alpha: 1).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = chart.frame
        gradientLayer.cornerRadius = 10
        gradientLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }

    func setupLayout () {
        view.addSubview(chart)
        chart.pin
            .all()
            .height(283)
    }

    func configureUI () {
        setupChartData()
        setupChartUI()
    }
}


extension WeekChartViewController {
    func setupChartData(){
        var steps = [ChartDataEntry]()
        
        for x in 0..<7{
            steps.append(ChartDataEntry(x: Double(x), y: Double(Int.random(in: 0...40000))))
        }
        
        var set: LineChartDataSet! = nil
       
        set = LineChartDataSet(entries: steps, label: "Week Steps")
        set.colors = [
            UIColor(red: 46/255, green: 85/255, blue: 82/255, alpha: 1),
        ]
        
        set.circleColors.removeAll(keepingCapacity: false)
        set.lineWidth = 3
        set.circleColors.append(UIColor(red: 46/255, green: 85/255, blue: 82/255, alpha: 1))
        set.drawValuesEnabled = {false}()
        
        let data = LineChartData(dataSet: set)
        data.highlightEnabled = false
        chart.data = data
        
        let days = ["Sun", "Mod", "Tue", "Wed", "Thu", "Fri", "Sat"]
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values:days)
        
        chart.leftAxis.axisMaximum = 40000
    }
    
    func setupChartUI(){
        let weekAxis = chart.xAxis
        let leftAxis = chart.leftAxis
        let rightAxis = chart.rightAxis
        
        leftAxis.labelCount = 4
        leftAxis.axisMinimum = 0
        leftAxis.labelFont = .systemFont(ofSize: 12, weight: .regular)
        leftAxis.xOffset = 12
        leftAxis.gridLineDashLengths = [4]
        leftAxis.axisLineDashLengths = [4]
        leftAxis.labelTextColor = UIColor(red: 32/255, green: 58/255, blue: 56/255, alpha: 1)
        leftAxis.gridColor = UIColor(red: 75/255, green: 126/255, blue: 121/255, alpha: 1)
        leftAxis.axisLineColor = UIColor(red: 75/255, green: 126/255, blue: 121/255, alpha: 1)
        
        rightAxis.drawLabelsEnabled = false
        rightAxis.drawGridLinesEnabled = false
        rightAxis.axisLineDashLengths = [4]
        rightAxis.axisLineColor = UIColor(red: 75/255, green: 126/255, blue: 121/255, alpha: 1)
        
        
        weekAxis.granularity = 1
        weekAxis.drawGridLinesEnabled = false
        weekAxis.labelPosition = XAxis.LabelPosition.top
        weekAxis.labelFont = .systemFont(ofSize: 14, weight: .regular)
        weekAxis.labelRotatedHeight = 30
        weekAxis.yOffset = 15
        weekAxis.gridLineDashLengths = [4]
        weekAxis.axisLineDashLengths = [4]
        weekAxis.labelTextColor = UIColor(red: 32/255, green: 58/255, blue: 56/255, alpha: 1)
        weekAxis.gridColor = UIColor(red: 75/255, green: 126/255, blue: 121/255, alpha: 1)
        weekAxis.axisLineColor = UIColor(red: 75/255, green: 126/255, blue: 121/255, alpha: 1)
    }
}

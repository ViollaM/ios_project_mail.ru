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
        }
        chart.data = data
    }
}

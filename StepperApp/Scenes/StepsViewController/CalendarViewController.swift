//
//  CalendarViewController.swift
//  Test Project
//
//  Created by Ruben Egikian on 01.12.2021.
//

import Foundation
import UIKit
import FSCalendar

final class CalendarViewController: UIViewController {
    private lazy var calendar: FSCalendar = {
        let cal = FSCalendar()
        cal.translatesAutoresizingMaskIntoConstraints = false
        cal.firstWeekday = 2
        cal.delegate = self
        cal.dataSource = self
        cal.backgroundColor = .clear
        let darkGreen = UIColor(red: 12/255, green: 38/255, blue: 36/255, alpha: 1)
        cal.appearance.headerTitleColor = darkGreen
        cal.appearance.weekdayTextColor = darkGreen
        cal.appearance.todayColor = darkGreen
        cal.appearance.selectionColor = darkGreen
        cal.appearance.titleDefaultColor = darkGreen.withAlphaComponent(0.8)
        cal.appearance.titleWeekendColor = darkGreen
        return cal
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 204/255, green: 228/255, blue: 225/255, alpha: 1)
        view.addSubview(calendar)
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            calendar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
        dismiss(animated: true, completion: nil)
    }
}

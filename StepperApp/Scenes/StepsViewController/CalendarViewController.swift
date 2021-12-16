//
//  CalendarViewController.swift
//  Test Project
//
//  Created by Ruben Egikian on 01.12.2021.
//

import Foundation
import UIKit
import FSCalendar
import PanModal

protocol CalendarDelegate: AnyObject {
    func didSelectDay(_ date: Date)
}

final class CalendarViewController: UIViewController {
    var delegate: CalendarDelegate?
    var height: CGFloat?
    
    private lazy var calendar: FSCalendar = {
        let cal = FSCalendar()
        cal.translatesAutoresizingMaskIntoConstraints = false
        cal.firstWeekday = 2
        cal.delegate = self
        cal.dataSource = self
        cal.backgroundColor = .clear
        cal.appearance.headerTitleColor = StepColor.darkGreen
        cal.appearance.weekdayTextColor = StepColor.darkGreen
        cal.appearance.todayColor = StepColor.darkGreen
        cal.appearance.selectionColor = StepColor.darkGreen
        cal.appearance.titleDefaultColor = StepColor.darkGreen.withAlphaComponent(0.8)
        cal.appearance.titleWeekendColor = StepColor.darkGreen
        cal.appearance.titlePlaceholderColor = StepColor.darkGreen.withAlphaComponent(0.5)
        return cal
    }()
    
    let screenHeight = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.layer.cornerRadius = 12
        view.backgroundColor = StepColor.cellBackground
        view.addSubview(calendar)
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            calendar.heightAnchor.constraint(equalToConstant: height!)
        ])
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dismiss(animated: true, completion: nil)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let newDate = date.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT(for: date)))
        if newDate <= Date() {
            delegate?.didSelectDay(newDate)
            return true
        } else {
            return false
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        var color: UIColor?
        let newDate = date.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT(for: date)))
        if newDate >= Date() {
            color = StepColor.darkGreen.withAlphaComponent(0.2)
        } else {
            color = nil
        }
        return color
    }
}

extension CalendarViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }
    
    var longFormHeight: PanModalHeight {
        .contentHeight(height ?? screenHeight * 0.45)
    }
}

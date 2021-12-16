//
//  WeekChartViewController.swift
//  StepperApp
//
//  Created by Стас Чебыкин on 23.10.2021.
//

import UIKit
import Charts

protocol ChartDelegate: AnyObject {
    func updateData(stepWeek: SteppingWeek)
}

final class WeekChartViewController: UIViewController{
    
    private var week: SteppingWeek = SteppingWeek(steppingDays: [])
    private let countOfWeeks = 30
    private var arrayOfWeeks: [SteppingWeek] = Array(repeating: SteppingWeek(steppingDays: []), count: 31)
    private var previousPage = 0
    private var oldMonday = Date()
    private let stepsService: StepsService
    private var total = 0
    private var averageSteps = 0
    
    init(stepsService: StepsService) {
        self.stepsService = stepsService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var chartsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.isHidden = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.isPagingEnabled = true
        collection.backgroundColor = StepColor.cellBackground.withAlphaComponent(0.8)
        collection.register(SwipeChartCell.self, forCellWithReuseIdentifier: "SwipeChartCell")
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        return collection
    }()
    
    private lazy var weekInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = StepColor.cellBackground.withAlphaComponent(0.8)
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 12
        return view
    }()
    private lazy var weekTotalSteps: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = StepColor.weekTotalAndAverage
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    private lazy var weekAverageSteps: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = StepColor.weekTotalAndAverage
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    private lazy var weekDaysRange: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = StepColor.weekRange
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateLabelTap))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setupArrayOfWeeks()
        setupLayout()
        previousPage = chartsCollectionView.numberOfItems(inSection: 0) - 1
    }
    
    private func moveToTheRightCell() {
        let row = chartsCollectionView.numberOfItems(inSection: 0) - 1
        let newIndexPath = IndexPath(row: row, section: 0)
        chartsCollectionView.selectItem(at: newIndexPath, animated: false, scrollPosition: .left)
    }
    
    private func setupArrayOfWeeks() {
        oldMonday = week.steppingDays.first!.date
        for i in 1...countOfWeeks {
            let newMonday = Calendar.iso8601UTC.date(byAdding: .day, value: -7, to: oldMonday)!
            oldMonday = newMonday
            stepsService.fetchWeekContains(day: newMonday) { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let week):
                    self.arrayOfWeeks[i] = week
                    DispatchQueue.main.async {
                        self.chartsCollectionView.reloadData()
                        self.moveToTheRightCell()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    private func setupLayout () {
        
        [weekTotalSteps, weekAverageSteps, weekDaysRange].forEach {
            weekInfoView.addSubview($0)
        }
        [weekInfoView].forEach {
            view.addSubview($0)
        }
        
        view.addSubview(chartsCollectionView)
        NSLayoutConstraint.activate([
            weekInfoView.topAnchor.constraint(equalTo: view.topAnchor),
            weekInfoView.heightAnchor.constraint(equalToConstant: 50),
            weekInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weekInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            weekDaysRange.centerYAnchor.constraint(equalTo: weekAverageSteps.centerYAnchor, constant: -16),
            weekDaysRange.trailingAnchor.constraint(equalTo: weekInfoView.trailingAnchor, constant: -8),
            weekDaysRange.heightAnchor.constraint(equalToConstant: 24),

            weekTotalSteps.topAnchor.constraint(equalTo: weekInfoView.topAnchor, constant: 4),
            weekTotalSteps.leadingAnchor.constraint(equalTo: weekInfoView.leadingAnchor, constant: 8),
            weekTotalSteps.trailingAnchor.constraint(equalTo: weekInfoView.trailingAnchor),
            weekTotalSteps.heightAnchor.constraint(equalToConstant: 20),

            weekAverageSteps.topAnchor.constraint(equalTo: weekTotalSteps.bottomAnchor, constant: 2),
            weekAverageSteps.leadingAnchor.constraint(equalTo: weekInfoView.leadingAnchor, constant: 8),
            weekAverageSteps.trailingAnchor.constraint(equalTo: weekInfoView.trailingAnchor),
            weekAverageSteps.heightAnchor.constraint(equalToConstant: 20),

            chartsCollectionView.topAnchor.constraint(equalTo: weekInfoView.bottomAnchor),
//            chartsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chartsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chartsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chartsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func swipeRight() {
        var newDay: Date
        if let firstDay = self.week.steppingDays.first {
            let firstDate = firstDay.date
            newDay = Calendar.iso8601UTC.date(byAdding: .day, value: -1, to: firstDate)!
            didSelect(newDay)
        }
    }
    private func swipeLeft() {
        var newDay: Date
        if let lastDay = self.week.steppingDays.last {
            let lastDate = lastDay.date
            newDay = Calendar.iso8601UTC.date(byAdding: .day, value: 1, to: lastDate)!
            if newDay < Date() {
                didSelect(newDay)
            }
        }
    }
    
    private func updateWeekLabels(week: SteppingWeek) {
        let firstDateFormatter = DateFormatter()
        let lastDateFormatter = DateFormatter()
        lastDateFormatter.dateFormat = "d MMM yyyy"
        let first = week.steppingDays.first ?? SteppingDay()
        let last = week.steppingDays.last ?? SteppingDay()
        if Calendar.iso8601UTC.component(.month, from: first.date) == Calendar.iso8601UTC.component(.month, from: last.date) {
            firstDateFormatter.dateFormat = "d"
            weekDaysRange.widthAnchor.constraint(greaterThanOrEqualToConstant: 160).isActive = true
        } else if Calendar.iso8601UTC.component(.year, from: first.date) == Calendar.iso8601UTC.component(.year, from: last.date) {
            firstDateFormatter.dateFormat = "d MMM"
            weekDaysRange.widthAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
        } else {
            firstDateFormatter.dateFormat = "d MMM yyyy"
            weekDaysRange.widthAnchor.constraint(greaterThanOrEqualToConstant: 250).isActive = true
        }
        let firstDay = firstDateFormatter.string(from: first.date)
        let lastDay = lastDateFormatter.string(from: last.date)
        weekDaysRange.text = "\(firstDay) - \(lastDay)"
        self.total = week.totalStepsForWeek
        weekTotalSteps.text = "Total: \(total)"
        self.averageSteps = week.averageStepsForWeek
        weekAverageSteps.text = "Average: \(averageSteps)"
    }
    
    private func didSelect(_ date: Date) {
        stepsService.fetchWeekContains(day: date) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let week):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    //                    self.updateWeekLabels(week: week)
                    //                    self.chartDelegate?.updateData(stepWeek: week)
                    self.week = week
                    self.chartsCollectionView.reloadData()
                }
                //                self.selectedWeek = week
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc
    private func dateLabelTap() {
        let vc = CalendarViewController()
        vc.delegate = self
        vc.height = view.frame.height + view.safeAreaInsets.bottom + 15
        presentPanModal(vc)
    }
}

extension WeekChartViewController: ChartDelegate{
    func updateData(stepWeek: SteppingWeek) {
        week = stepWeek
        arrayOfWeeks[0] = week
        updateWeekLabels(week: week)
        setupArrayOfWeeks()
        //        chartsCollectionView.reloadData()
        //        moveToTheRightCell()
    }
}

extension WeekChartViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrayOfWeeks.count > 0 {
            return arrayOfWeeks.count
        } else {
            return 1
        }
        //        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwipeChartCell", for: indexPath) as? SwipeChartCell {
            if arrayOfWeeks.count > 1 {
                cell.week = arrayOfWeeks[countOfWeeks - indexPath.row]
            } else {
                cell.week = week
            }
            return cell
            //            cell.week = week
            //            return cell
        }
        return .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: view.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - weekInfoView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        updateWeekLabels(week: arrayOfWeeks[countOfWeeks - currentPage])
        if currentPage > previousPage {
            print("Swipe left")
            swipeLeft()
        } else if currentPage < previousPage {
            print("Swipe right")
            swipeRight()
        }
        previousPage = currentPage
    }
    
}


extension WeekChartViewController: CalendarDelegate {
    func didSelectDay(_ date: Date) {
        for i in 0...arrayOfWeeks.count-1 {
            for j in 0...arrayOfWeeks[i].steppingDays.count-1{
                if arrayOfWeeks[i].steppingDays[j].date == date {
                    let indexPath = IndexPath(row: countOfWeeks - i, section: 0)
                    updateWeekLabels(week: arrayOfWeeks[i])
                    chartsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    return
                }
            }
        }
    }
}





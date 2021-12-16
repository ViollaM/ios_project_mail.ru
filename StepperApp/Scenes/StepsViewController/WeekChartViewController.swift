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
//        chartsCollectionView.scrollToItem(at: correctIndexPath, at: .left, animated: true)
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
        view.addSubview(chartsCollectionView)
        NSLayoutConstraint.activate([
            chartsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
}

extension WeekChartViewController: ChartDelegate{
    func updateData(stepWeek: SteppingWeek) {
        week = stepWeek
        arrayOfWeeks[0] = week
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
        CGSize(width: view.frame.width, height: view.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
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

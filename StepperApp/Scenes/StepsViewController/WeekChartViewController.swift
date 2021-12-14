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
    
    private var week: SteppingWeek?
    
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
    
    private var previousPage = 0
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let row = chartsCollectionView.numberOfItems(inSection: 0) - 1
        let newIndexPath = IndexPath(row: row, section: 0)
        chartsCollectionView.selectItem(at: newIndexPath, animated: false, scrollPosition: .left)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        previousPage = chartsCollectionView.numberOfItems(inSection: 0) - 1
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
}

extension WeekChartViewController: ChartDelegate{
    func updateData(stepWeek: SteppingWeek) {
        week = stepWeek
        chartsCollectionView.reloadData()
    }
}

extension WeekChartViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        52
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwipeChartCell", for: indexPath) as? SwipeChartCell {
            cell.week = week
            return cell
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
        } else if currentPage < previousPage {
            print("Swipe right")
        }
        previousPage = currentPage
    }
    
}

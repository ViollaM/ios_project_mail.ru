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
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        chartsCollectionView.isPagingEnabled = true
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
        10
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
    
}

//
//  CompetitionViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 09.10.2021.
//

import Foundation
import UIKit
import PinLayout



final class CompetitionViewController: UIViewController {

    var timer = Timer()
    
    var currentTime = timeData(hour: 23 - hour, minute: 59 - minute, second: 59 - second, time: time)
    
    var competitions = [
        competitionData(name: "Daily step competition", maxValue: 10000, currentValue: Double.random(in: 0...20000.0), remainingTime: time, currentLeader: "@max"),
        competitionData(name: "10 km per day", maxValue: 10, currentValue: Double.random(in: 0...20.0), remainingTime: time, currentLeader: "@katty"),
        competitionData(name: "15000 steps per day", maxValue: 15000, currentValue: Double.random(in: 0...20000.0), remainingTime: time, currentLeader: "@violla")
        /*competitionData(name: "Daily step competition", maxValue: 10000, currentValue: Double.random(in: 0...20000.0), remainingTime: time, currentLeader: "@max"),
        competitionData(name: "Daily step competition", maxValue: 10000, currentValue: Double.random(in: 0...20000.0), remainingTime: time, currentLeader: "@max"),
        competitionData(name: "Daily step competition", maxValue: 10000, currentValue: Double.random(in: 0...20000.0), remainingTime: time, currentLeader: "@max"),
        competitionData(name: "Daily step competition", maxValue: 10000, currentValue: Double.random(in: 0...20000.0), remainingTime: time, currentLeader: "@max"),
        competitionData(name: "Daily step competition", maxValue: 10000, currentValue: Double.random(in: 0...20000.0), remainingTime: time, currentLeader: "@max")*/
    ]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(CompetitionViewCell.self, forCellWithReuseIdentifier: String(describing: CompetitionViewCell.self))
        collection.frame = view.bounds
        collection.backgroundColor = .clear
        return collection
    }()
    
    private let cellsOffset: CGFloat = 22
    private let numberOfItemsPerRow: CGFloat = 2
    
    
    private lazy var label: UILabel = {
        let label = UILabel()
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Competitions"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    private lazy var currentCompetitionButton: UIButton = {
        let button = UIButton()
        button.setTitle("current", for: .normal)
        button.setTitleColor(HexColor(rgb: 0xCCE4E1), for: .normal)
        button.backgroundColor = HexColor(rgb: 0x0C2624)
        button.addTarget(self, action: #selector(currentCompetitionButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var finishedCompetitionButton: UIButton = {
        let button = UIButton()
        button.setTitle("finished", for: .normal)
        button.setTitleColor(HexColor(rgb: 0x0C2624), for: .normal)
        button.backgroundColor = HexColor(rgb: 0xCCE4E1)
        button.addTarget(self, action: #selector(finishedCompetitionButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        
        setupLayout()
    }
    
    @objc func updateTimeLabel() {
        hour = calendar.component(.hour, from: date)
        minute = calendar.component(.minute, from: date)
        second = calendar.component(.second, from: date)
        hour = 23 - hour
        minute = 59 - minute
        second = 59 - second
        time = "\(hour)" + ":" + "\(minute)" + ":" + "\(second)"
        currentTime = timeData(hour: hour, minute: minute, second: second, time: time)
        
        //label.text = time
        
        let visibleCellsIndexPaths = collectionView.indexPathsForVisibleItems
        for index in visibleCellsIndexPaths {
            competitions[index.row].remainingTime = time
            //collectionView.cellForItem(at: index)
        }
        //collectionView.reloadData()
        //collectionView.cellForItem(at: visibleCellsIndexPaths)
        //print(competitions)
    }
    
    @objc func currentCompetitionButtonPressed() {
        currentCompetitionButton.setTitleColor(HexColor(rgb: 0xCCE4E1), for: .normal)
        currentCompetitionButton.backgroundColor = HexColor(rgb: 0x0C2624)
        finishedCompetitionButton.setTitleColor(HexColor(rgb: 0x0C2624), for: .normal)
        finishedCompetitionButton.backgroundColor = HexColor(rgb: 0xCCE4E1)
    }
    
    @objc func finishedCompetitionButtonPressed() {
        finishedCompetitionButton.setTitleColor(HexColor(rgb: 0xCCE4E1), for: .normal)
        finishedCompetitionButton.backgroundColor = HexColor(rgb: 0x0C2624)
        currentCompetitionButton.setTitleColor(HexColor(rgb: 0x0C2624), for: .normal)
        currentCompetitionButton.backgroundColor = HexColor(rgb: 0xCCE4E1)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = CGRect(x: view.safeAreaInsets.left, y: view.safeAreaInsets.top + 119, width: view.frame.width, height: view.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 119)
    }

    func setupLayout () {
        view.addSubview(collectionView)
        view.addSubview(label)
        label.pin
            .horizontally(24)
            .top(57)
            .height(50)
        
        view.addSubview(currentCompetitionButton)
        view.addSubview(finishedCompetitionButton)
        currentCompetitionButton.pin
            .below(of: label).marginTop(8)
            .left(cellsOffset)
            .width((collectionView.frame.width - cellsOffset * (numberOfItemsPerRow + 1)) / 2)
            .height(28)
        
        finishedCompetitionButton.pin
            .below(of: label).marginTop(8)
            .right(of: currentCompetitionButton).marginLeft(cellsOffset)
            .width((collectionView.frame.width - cellsOffset * (numberOfItemsPerRow + 1)) / 2)
            .height(28)
        
    }
    

    func setupNavigationItem () {
        self.title = "Competition"
    }

}

extension CompetitionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompetitionViewCell", for: indexPath) as? CompetitionViewCell else {
            return .init()
        }
        
        let comp = competitions[indexPath.row]
        cell.configure(with: comp)
        cell.configureUI()
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return competitions.count
    }
}


extension CompetitionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - cellsOffset * (numberOfItemsPerRow + 1)
        let cellWidth = availableWidth / numberOfItemsPerRow
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: cellsOffset, bottom: cellsOffset, right: cellsOffset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellsOffset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellsOffset
    }
}


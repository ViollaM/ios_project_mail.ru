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
    private var competitions = allCompetitions
    var timer = Timer()
    
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
        label.text = "Competitions"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    private lazy var currentCompetitionButton: UIButton = {
        let button = UIButton()
        button.setTitle("current", for: .normal)
        button.setTitleColor(HexColor(rgb: 0x0C2624), for: .normal)
        button.backgroundColor = HexColor(rgb: 0xCCE4E1)
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
    
    @objc
    private func updateTimeLabel() {
        date = Date()
        hour = calendar.component(.hour, from: date)
        minute = calendar.component(.minute, from: date)
        time = currentTime()
        collectionView.reloadData()
    }
    
    @objc
    private func currentCompetitionButtonPressed() {
        currentCompetitionButton.setTitleColor(HexColor(rgb: 0xCCE4E1), for: .normal)
        currentCompetitionButton.backgroundColor = HexColor(rgb: 0x0C2624)
        finishedCompetitionButton.setTitleColor(HexColor(rgb: 0x0C2624), for: .normal)
        finishedCompetitionButton.backgroundColor = HexColor(rgb: 0xCCE4E1)
        var t = 0
        self.competitions = []
        for i in allCompetitions {
            if (!i.isFinished) {
                competitions.append(i)
                competitions[t].remainingTime = currentTime()
                t += 1
            }
        }
        collectionView.reloadData()
    }
    
    @objc
    private func finishedCompetitionButtonPressed() {
        finishedCompetitionButton.setTitleColor(HexColor(rgb: 0xCCE4E1), for: .normal)
        finishedCompetitionButton.backgroundColor = HexColor(rgb: 0x0C2624)
        currentCompetitionButton.setTitleColor(HexColor(rgb: 0x0C2624), for: .normal)
        currentCompetitionButton.backgroundColor = HexColor(rgb: 0xCCE4E1)
        var t = 0
        self.competitions = []
        for i in allCompetitions {
            if (i.isFinished) {
                competitions.append(i)
                competitions[t].remainingTime = currentTime()
                t += 1
            }
        }
        collectionView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = CGRect(x: view.safeAreaInsets.left, y: view.safeAreaInsets.top + 119, width: view.frame.width, height: view.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 119)
    }

    private func setupLayout () {
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

}

extension CompetitionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompetitionViewCell", for: indexPath) as? CompetitionViewCell else {
            return .init()
        }
        
        let comp = competitions[indexPath.row]
        cell.competition = comp
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let competitionVC = EachCompetitionViewController()
        let comp = competitions[indexPath.row]
        competitionVC.competition = comp
        present(competitionVC, animated: true, completion: nil)
    }
}




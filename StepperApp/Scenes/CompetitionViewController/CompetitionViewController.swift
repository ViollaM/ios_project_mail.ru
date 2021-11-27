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
    
    private let stepsService: StepsService
    
    init(stepsService: StepsService) {
        self.stepsService = stepsService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var week: SteppingWeek = SteppingWeek(steppingDays: [])
    
    private func loadStepsData() {
        stepsService.fetchLastWeekSteps { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let week):
                self.week = week
                DispatchQueue.main.async { [weak self] in
                    currentSteps = week.steppingDays.last!.steps
//                    allCompetitions.forEach { competition in
//                        competition.currentValue = week.steppingDays.last!.steps
//                    }
                    for i in 0..<(allCompetitions.count - 1) {
                        allCompetitions[i].currentValue = Double(currentSteps)
                    }
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(CompetitionViewCell.self, forCellWithReuseIdentifier: String(describing: CompetitionViewCell.self))
        collection.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: HeaderCollectionReusableView.self))
        collection.frame = view.bounds
        collection.backgroundColor = .clear
        return collection
    }()
    
    private let cellsOffset: CGFloat = 22
    private let numberOfItemsPerRow: CGFloat = 2
    private var buttonWidth: CGFloat {
        return (view.frame.width - cellsOffset * (numberOfItemsPerRow + 1)) / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        setupLayout()
        //loadStepsData()
    }
    
    @objc
    private func updateTimeLabel() {
        date = Date()
        hour = calendar.component(.hour, from: date)
        minute = calendar.component(.minute, from: date)
        time = currentTime()
        loadStepsData()
        //print(currentSteps)
        collectionView.reloadData()
    }
    
    @objc
    private func currentCompetitionButtonPressed() {
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

    private func setupLayout () {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
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
        competitions.count
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
        cellsOffset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        cellsOffset
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: HeaderCollectionReusableView.self), for: indexPath) as! HeaderCollectionReusableView
        header.currentCompetitionButton.addTarget(self, action: #selector(currentCompetitionButtonPressed), for: .touchUpInside)
        header.finishedCompetitionButton.addTarget(self, action: #selector(finishedCompetitionButtonPressed), for: .touchUpInside)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.frame.width, height: 47)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let competitionVC = EachCompetitionViewController()
        let comp = competitions[indexPath.row]
        competitionVC.competition = comp
        present(competitionVC, animated: true, completion: nil)
    }
}




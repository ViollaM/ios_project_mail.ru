//
//  CompetitionViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 09.10.2021.
//

import Foundation
import UIKit
import PinLayout
import Charts

final class CompetitionViewController: UIViewController {
    private var competitions: [CompetitionData] = CompetitionsState.current.fetch()
    private var steps = 0
    private var distanceKM: Double = 0
    private var distanceMI: Double = 0
    var timer = Timer()
    
    private let stepsService: StepsService
    private let pedometerService: PedometerService
    
    init(stepsService: StepsService, pedometerService: PedometerService) {
        self.stepsService = stepsService
        self.pedometerService = pedometerService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private var plusButton: UIButton = {
        let plus = UIButton()
        let config = UIImage.SymbolConfiguration(weight: .bold)
        if let plusImage = UIImage(systemName: "plus", withConfiguration: config) {
            plus.setImage(plusImage, for: .normal)
        }
        plus.isHidden = true
        plus.tintColor = StepColor.darkGreen
        plus.layer.cornerRadius = 10
        plus.backgroundColor = StepColor.cellBackground
        plus.frame.size = CGSize(width: 28, height: 28)
        return plus
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStepsData()
        updatesStepData()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        setupLayout()
        plusButton.addTarget(self, action: #selector(addNewCompetitionButtonPressed), for: .touchUpInside)
    }
    
    private func loadStepsData() {
        stepsService.fetchLastWeekInfo { result in
            switch result {
            case .success(let week):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if let day = week.steppingDays.last {
                        self.steps = day.steps
                        self.distanceKM = day.km
                        self.distanceMI = day.miles
                        for i in 0..<allCompetitions.count {
                            if allCompetitions[i].isStepsCompetition {
                                allCompetitions[i].currentValue = Double(self.steps)
                            } else if allCompetitions[i].isKM {
                                allCompetitions[i].currentValue = self.distanceKM
                            } else {
                                allCompetitions[i].currentValue = self.distanceMI
                            }
                        }
                        self.competitions = CompetitionsState.current.fetch()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func updatesStepData() {
        pedometerService.updateStepsAndDistanceForCompetitions { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let update):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
//                    let pedometerDistance = Double(truncating: update.distance) / 1000
//                    let pedometerSteps = Int(truncating: update.steps)
//                    let totalSteps = self.steps + pedometerSteps
//                    let totalDistance = self.distanceKM + pedometerDistance
                    let pedometerSteps = Int(truncating: update.steps)
                    let pedometerDistanceKM = Double(truncating: update.distance) / 1000
                    let pedometerDistanceMI = Double(truncating: update.distance) / 1609.34
                    let totalSteps = self.steps + pedometerSteps
                    let totalDistanceKM = self.distanceKM + pedometerDistanceKM
                    let totalDistanceMI = self.distanceMI + pedometerDistanceMI
                    for i in 0..<allCompetitions.count {
                        if allCompetitions[i].isStepsCompetition {
                            allCompetitions[i].currentValue = Double(totalSteps)
                        } else if allCompetitions[i].isKM {
                            allCompetitions[i].currentValue = totalDistanceKM
                        } else {
                            allCompetitions[i].currentValue = totalDistanceMI
                        }                    }
                    self.competitions = CompetitionsState.current.fetch()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchCompetitions(state : CompetitionsState) -> [CompetitionData] {
        var competitions = state.fetch()
        for i in 0..<competitions.count {
            competitions[i].remainingTime = currentTime()
        }
        return competitions
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
    private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let state: CompetitionsState = sender.selectedSegmentIndex == 0 ? .current : .finished
        self.competitions = fetchCompetitions(state: state)
        collectionView.reloadData()
    }
    
    @objc
    private func addNewCompetitionButtonPressed() {
        let newVC = AddNewCompetitionViewController()
        present(newVC, animated: true)
    }
    
    private func setupLayout () {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: plusButton)
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
        header.buttonsSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
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

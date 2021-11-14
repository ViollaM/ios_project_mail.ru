//
//  ViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 09.10.2021.
//

import UIKit
import PinLayout

class StepsViewController: UIViewController {
    
    private let stepsService: StepsService
    
    init(stepsService: StepsService) {
        self.stepsService = stepsService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [stepsCountLabel, distanceLabel, stepsRemainingLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 45, leading: 0, bottom: 20, trailing: 0)
        stack.spacing = 10
        stack.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.47)
        return stack
    }()
    
    private lazy var stepsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "7509"
        label.font = .systemFont(ofSize: 36, weight: .bold)
        return label
    }()
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "distance: 6.0km"
        return label
    }()
    private lazy var stepsRemainingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "left: 2131"
        return label
    }()
    
    var week: SteppingWeek = SteppingWeek(steppingDays: [])
    
    private lazy var weekChartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Week", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.47)
        button.addTarget(self, action: #selector(weekButtonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        stepsServiceAuth()
        setupNavigation()
        setupLayout()
    }
    
    private func stepsServiceAuth() {
        stepsService.authorizeService { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let result):
                if result {
                    self.loadStepsData()
                } else {
                    print("Alert! Give us permission!")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateLabelsData(stepsCount: Int) {
        stepsCountLabel.text = "\(stepsCount)"
        if 10000 - stepsCount > 0 {
            stepsRemainingLabel.text = "left: \(10000-stepsCount)"
        } else {
            stepsRemainingLabel.isHidden = true
        }
    }
    
    private func loadStepsData() {
        stepsService.fetchLastWeekSteps { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let week):
                self.week = week
                DispatchQueue.main.async { [weak self] in
                    self?.updateLabelsData(stepsCount: week.steppingDays.last!.steps)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            print("Week info: \(self.week)")
        }
    }

    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(toAuthorization))
    }
    
    private func setupLayout() {
        view.addSubview(stackView)
        view.addSubview(weekChartButton)
        stackView.pin
            .top(80)
            .height(200)
            .width(200)
            .hCenter()
        
        weekChartButton.pin
            .bottom(100)
            .horizontally(100)
            .height(40)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        stackView.layer.cornerRadius = stackView.frame.width/2
        weekChartButton.layer.cornerRadius = 10
    }
    
    @objc
    private func weekButtonPressed () {
        let vc = WeekChartViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func toAuthorization() {
        let rootVC = AuthorizationViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
}

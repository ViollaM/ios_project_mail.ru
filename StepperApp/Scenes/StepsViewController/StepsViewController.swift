//
//  ViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 09.10.2021.
//

import UIKit
import PinLayout

final class StepsViewController: UIViewController {
    
    private var weekChartViewController: UIViewController!
    private let stepsService: StepsService
    
    init(stepsService: StepsService) {
        self.stepsService = stepsService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var circleStepContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.47)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stepsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.text = "0"
        label.font = .systemFont(ofSize: 36, weight: .bold)
        return label
    }()
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.text = "distance: 0 km"
        return label
    }()
    private lazy var stepsRemainingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.text = "left: 0"
        return label
    }()
    
    private var week: SteppingWeek = SteppingWeek(steppingDays: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepsServiceAuth()
        setupNavigation()
        setupLayout()
        getWeekChartView()
        setupWeekChartViewLayout()
    }
    
    private func getWeekChartView(){
        weekChartViewController = WeekChartViewController()
        addChild(weekChartViewController)
        view.insertSubview(weekChartViewController.view, at: 0)
        weekChartViewController.didMove(toParent: self)
        
        self.chartDelegate = (weekChartViewController as? ChartDelegate)
    }
    
    
    private func setupWeekChartViewLayout(){
        weekChartViewController.view.pin
            .horizontally(0)
            .height(283)
            .bottom(83)
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
            stepsCountLabel.font = .systemFont(ofSize: 44, weight: .bold)
        }
    }
    
    weak var chartDelegate: ChartDelegate?
    
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
                    self?.chartDelegate?.updateData(stepWeek: week)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func setupNavigation() {
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(toAuthorization))
        logoutButton.tintColor = UIColor(red: 12/255, green: 38/255, blue: 36/255, alpha: 1)
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    private func setupLayout() {
        view.addSubview(circleStepContainerView)
        [stepsCountLabel, distanceLabel, stepsRemainingLabel].forEach {
            circleStepContainerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            circleStepContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            circleStepContainerView.heightAnchor.constraint(equalToConstant: 200),
            circleStepContainerView.widthAnchor.constraint(equalToConstant: 200),
            circleStepContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stepsCountLabel.leadingAnchor.constraint(equalTo: circleStepContainerView.leadingAnchor, constant: 28),
            stepsCountLabel.topAnchor.constraint(equalTo: circleStepContainerView.topAnchor, constant: 70),
            stepsCountLabel.trailingAnchor.constraint(equalTo: circleStepContainerView.trailingAnchor, constant: -28),
            stepsCountLabel.heightAnchor.constraint(equalToConstant: 42),
            
            distanceLabel.leadingAnchor.constraint(equalTo: circleStepContainerView.leadingAnchor, constant: 30),
            distanceLabel.topAnchor.constraint(equalTo: stepsCountLabel.bottomAnchor, constant: 8),
            distanceLabel.trailingAnchor.constraint(equalTo: circleStepContainerView.trailingAnchor, constant: -30),
            distanceLabel.heightAnchor.constraint(equalToConstant: 22),
            
            stepsRemainingLabel.leadingAnchor.constraint(equalTo: circleStepContainerView.leadingAnchor, constant: 50),
            stepsRemainingLabel.bottomAnchor.constraint(equalTo: circleStepContainerView.bottomAnchor, constant: -25),
            stepsRemainingLabel.trailingAnchor.constraint(equalTo: circleStepContainerView.trailingAnchor, constant: -50),
            stepsRemainingLabel.heightAnchor.constraint(equalToConstant: 22),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        circleStepContainerView.layer.cornerRadius = circleStepContainerView.frame.height/2
    }
    
    
    @objc
    private func toAuthorization() {
        UserDefaults.standard.set(false, forKey: "isLogged")
        let rootVC = AuthorizationViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
}

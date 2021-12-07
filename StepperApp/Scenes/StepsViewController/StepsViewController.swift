//
//  ViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 09.10.2021.
//

import UIKit
import PinLayout
import PanModal

final class StepsViewController: UIViewController {
    
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
    
    private var steps = 0
    private var distance: Double = 0
    
    private lazy var circleStepContainerView: CircleView = {
        let view = CircleView()
        view.backgroundColor = StepColor.alpha5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stepsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.text = String(steps)
        label.font = .systemFont(ofSize: 36, weight: .bold)
        return label
    }()
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.text = "distance: \(distance) km"
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
    
    private lazy var settingsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingsButtonPressed))
        button.tintColor = StepColor.darkGreen
        return button
    }()
        
    private let weekChartViewController = WeekChartViewController()
    private let calendarViewController = CalendarViewController()
    weak var chartDelegate: ChartDelegate?
    
    private let widthOfUIElements = UIScreen.main.bounds.width / 1.8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepsServiceAuth()
        pedometerServiceActivation()
        setupNavigation()
        setupLayout()
        getWeekChartView()
    }
    
    private func stepsServiceAuth() {
        stepsService.authorizeService { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let result):
                if result {
                    self.loadWeekData()
                } else {
                    print("Alert! Give us permission!")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadWeekData() {
        stepsService.fetchLastWeekInfo { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let week):
                DispatchQueue.main.async { [weak self] in
                    self?.updateLabelsData(lastDay: week.steppingDays.last!)
                    self?.chartDelegate?.updateData(stepWeek: week)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        // MARK: - You can test fetchWeekContains(day: Date) in this block
//        let customDate = Calendar.current.date(byAdding: DateComponents(day: -7, hour: -4), to: Date())!
//        let anotherCustomDate = Calendar.current.date(byAdding: DateComponents(day: 5), to: Date())!
//        print(anotherCustomDate)
//        stepsService.fetchWeekContains(day: Date()) { [weak self] result in
//            guard let self = self else {
//                return
//            }
//            switch result {
//            case .success(let week):
//                DispatchQueue.main.async { [weak self] in
//                    print("[DEBUG] \(week)")
//                    self?.updateLabelsData(lastDay: week.steppingDays.last!)
//                    self?.chartDelegate?.updateData(stepWeek: week)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
        // MARK: -
    }
    
    private func updateLabelsData(lastDay: SteppingDay) {
        self.steps = lastDay.steps
        self.distance = lastDay.km
        let roundedDistanceLabel = String(format: "%.1f", distance)
        distanceLabel.text = "distance: " + roundedDistanceLabel + " km"
        stepsCountLabel.text = "\(self.steps)"
        if 10000 - self.steps > 0 {
            stepsRemainingLabel.text = "left: \(10000-steps)"
        } else {
            stepsRemainingLabel.isHidden = true
            stepsCountLabel.font = .systemFont(ofSize: 44, weight: .bold)
        }
    }
    
    private func pedometerServiceActivation() {
        pedometerService.updateStepsAndDistance { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let update):
                DispatchQueue.main.async { [weak self] in
                    let pedometerDistance = Double(truncating: update.distance) / 1000
                    let pedometerSteps = Int(truncating: update.steps)
                    let totalSteps = self!.steps + pedometerSteps
                    let totalDistance = self!.distance + pedometerDistance
                    self?.stepsCountLabel.text = "\(totalSteps)"
                    let roundedDistanceLabel = String(format: "%.1f", totalDistance)
                    self?.distanceLabel.text = "distance: " + roundedDistanceLabel + " km"
                    if 10000 - totalSteps > 0 {
                        self?.stepsRemainingLabel.text = "left: \(10000-totalSteps)"
                    } else {
                        self?.stepsRemainingLabel.isHidden = true
                        self?.stepsCountLabel.font = .systemFont(ofSize: 44, weight: .bold)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupNavigation() {
        self.navigationItem.rightBarButtonItem = settingsButton
    }
    
    private func setupLayout() {
        view.addSubview(circleStepContainerView)
        [stepsCountLabel, distanceLabel, stepsRemainingLabel].forEach {
            circleStepContainerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            circleStepContainerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 125),
            circleStepContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleStepContainerView.heightAnchor.constraint(equalToConstant: widthOfUIElements),
            circleStepContainerView.widthAnchor.constraint(equalToConstant: widthOfUIElements),
            
            stepsCountLabel.centerXAnchor.constraint(equalTo: circleStepContainerView.centerXAnchor),
            stepsCountLabel.centerYAnchor.constraint(equalTo: circleStepContainerView.centerYAnchor, constant: -widthOfUIElements * 0.08),
            stepsCountLabel.widthAnchor.constraint(equalTo: circleStepContainerView.widthAnchor, multiplier: 0.715),
            stepsCountLabel.heightAnchor.constraint(equalTo: circleStepContainerView.heightAnchor, multiplier: 0.21),
            
            distanceLabel.centerXAnchor.constraint(equalTo: circleStepContainerView.centerXAnchor),
            distanceLabel.topAnchor.constraint(equalTo: stepsCountLabel.bottomAnchor, constant: widthOfUIElements * 0.04),
            distanceLabel.widthAnchor.constraint(equalTo: stepsCountLabel.widthAnchor),
            distanceLabel.heightAnchor.constraint(equalTo: circleStepContainerView.heightAnchor, multiplier: 0.11),

            stepsRemainingLabel.centerXAnchor.constraint(equalTo: circleStepContainerView.centerXAnchor),
            stepsRemainingLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: widthOfUIElements * 0.04),
            stepsRemainingLabel.widthAnchor.constraint(equalTo: circleStepContainerView.widthAnchor, multiplier: 0.5),
            stepsRemainingLabel.heightAnchor.constraint(equalTo: distanceLabel.heightAnchor)
        ])
    }
    
    private func getWeekChartView(){
        self.addChild(weekChartViewController)
        view.insertSubview(weekChartViewController.view, at: 0)
        weekChartViewController.didMove(toParent: self)
        self.chartDelegate = weekChartViewController
        setupWeekChartViewLayout()
    }
    
    private func setupWeekChartViewLayout(){
        weekChartViewController.view.pin
            .horizontally(0)
            .height(400)
            .bottom()

    }
    
    @objc
    private func settingsButtonPressed() {
        let vc = StepsScreenSettings()
        setupBackground(on: vc)
        vc.navigationController?.navigationBar.tintColor = StepColor.darkGreen
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension StepsViewController: CalendarDelegate {
    func didSelect(_ date: Date) {
        stepsService.fetchWeekContains(day: date) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let week):
                DispatchQueue.main.async { [weak self] in
                    self?.chartDelegate?.updateData(stepWeek: week)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

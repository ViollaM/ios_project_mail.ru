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
    
    private lazy var circleStepContainerView: UIView = {
        let view = UIView()
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
    
    private lazy var dateIntervalSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Day", "Week", "Month"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentTintColor = StepColor.darkGreen8
        sc.selectedSegmentIndex = 0
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: StepColor.cellBackground], for: .selected)
        sc.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        return sc
    }()
    
    weak var chartDelegate: ChartDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepsServiceAuth()
        pedometerServiceActivation()
        setupNavigation()
        setupLayout()
        getWeekChartView()
        setupWeekChartViewLayout()
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

        // MARK: - You can test fetchWeekAfter and fetchWeekBefore in this block
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
                    print("HealthKit Steps: \(self!.steps)")
                    print("Pedometer Steps: \(pedometerSteps)")
                    print("Total Steps: \(totalSteps)")
                    print("--------------------")
                    print("HealthKit Distance: \(self!.distance)")
                    print("Pedometer Distance: \(pedometerDistance)")
                    print("Total Distance: \(totalDistance)")
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
        navigationController?.navigationBar.addSubview(dateIntervalSegmentedControl)
        NSLayoutConstraint.activate([
            dateIntervalSegmentedControl.centerXAnchor.constraint(equalTo: navigationController!.navigationBar.centerXAnchor),
            dateIntervalSegmentedControl.centerYAnchor.constraint(equalTo: navigationController!.navigationBar.centerYAnchor),
            dateIntervalSegmentedControl.heightAnchor.constraint(equalToConstant: navigationController!.navigationBar.frame.height/1.5),
            dateIntervalSegmentedControl.widthAnchor.constraint(equalToConstant: navigationController!.navigationBar.frame.width/1.5)
        ])
    }
    
    private func setupLayout() {
        view.addSubview(circleStepContainerView)
        [stepsCountLabel, distanceLabel, stepsRemainingLabel].forEach {
            circleStepContainerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            circleStepContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        circleStepContainerView.layer.cornerRadius = circleStepContainerView.frame.height/2
    }
    
    @objc
    private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: print("Day")
//        case 1: case1()
        case 1: print("Week")
        case 2: print("Month")
        default:
            print("default")
        }
    }
    
//    private func case1() {
//        [circleStepContainerView, distanceLabel, stepsCountLabel, stepsRemainingLabel].forEach {
//            $0.isHidden = true
//        }
//        weekChartViewController.view.pin
//            .horizontally(0)
//            .top(view.safeAreaInsets.top + 20)
//            .bottom(view.safeAreaInsets.bottom)
//        print("Week")
//        let vc = CalendarViewController()
//        present(vc, animated: true)
//    }
}

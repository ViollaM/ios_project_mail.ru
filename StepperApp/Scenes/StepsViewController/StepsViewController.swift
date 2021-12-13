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
    private var total = 0
    private var averageSteps = 0
    private var firstDay = ""
    private var lastDay = ""
    private var circleProgress: CircleProgressView = {
        let circle = CircleProgressView(progress: 0.01, baseColor: StepColor.alpha5, progressColor: StepColor.darkGreen8)
        circle.animateCircle(duration: 1, delay: 0.1)
        circle.translatesAutoresizingMaskIntoConstraints = false
        return circle
    }()
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
        label.textColor = StepColor.darkGreen
        label.text = String(steps)
        label.font = .systemFont(ofSize: 36, weight: .bold)
        return label
    }()
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = StepColor.darkGreen
        label.text = "distance: \(distance) km"
        return label
    }()
    private lazy var stepsRemainingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = StepColor.darkGreen
        label.text = "left: 0"
        return label
    }()
    private lazy var weekInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = StepColor.cellBackground.withAlphaComponent(0.8)
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 12
        return view
    }()
    private lazy var weekTotalSteps: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = StepColor.weekTotalAndAverage
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    private lazy var weekAverageSteps: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = StepColor.weekTotalAndAverage
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    private lazy var weekDaysRange: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = StepColor.weekRange
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.backgroundColor = StepColor.cellBackground
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateLabelTap))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    private lazy var settingsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingsButtonPressed))
        button.tintColor = StepColor.darkGreen
        return button
    }()
    
    private let weekChartViewController = WeekChartViewController()
    private let calendarViewController = CalendarViewController()
    private let circleProgressBarViewController = CircleProgressBarViewController()
    weak var chartDelegate: ChartDelegate?
    weak var progressDelegate: ProgressDelegate?
    private var selectedWeek = SteppingWeek(steppingDays: [])
    
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
                    let lastDay = week.steppingDays.last ?? SteppingDay()
                    self?.steps = lastDay.steps
                    self?.distance = lastDay.km
                    self?.updateTodayLabels(lastDay: lastDay)
                    self?.updateWeekLabels(week: week)
                    self?.chartDelegate?.updateData(stepWeek: week)
//                    self?.otherCircle.progress = CGFloat(lastDay.steps/10000)
//                    self?.otherCircle.layoutSubviews()
//                    self?.progressDelegate?.updateData(progress: CGFloat(lastDay.steps)/10000)
                    self?.circleProgress.progress = CGFloat(lastDay.steps)/10000
                    self?.circleProgress.layoutSubviews()
                }
                self.selectedWeek = week
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateTodayLabels(lastDay: SteppingDay) {
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
    
    private func updateWeekLabels(week: SteppingWeek) {
        let firstDateFormatter = DateFormatter()
        let lastDateFormatter = DateFormatter()
        lastDateFormatter.dateFormat = "d MMM yyyy"
        let first = week.steppingDays.first ?? SteppingDay()
        let last = week.steppingDays.last ?? SteppingDay()
        if Calendar.iso8601UTC.component(.month, from: first.date) == Calendar.iso8601UTC.component(.month, from: last.date) {
            firstDateFormatter.dateFormat = "d"
            weekDaysRange.widthAnchor.constraint(greaterThanOrEqualToConstant: 160).isActive = true
        } else if Calendar.iso8601UTC.component(.year, from: first.date) == Calendar.iso8601UTC.component(.year, from: last.date) {
            firstDateFormatter.dateFormat = "d MMM"
            weekDaysRange.widthAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
        } else {
            firstDateFormatter.dateFormat = "d MMM yyyy"
            weekDaysRange.widthAnchor.constraint(greaterThanOrEqualToConstant: 250).isActive = true
        }
        self.firstDay = firstDateFormatter.string(from: first.date)
        self.lastDay = lastDateFormatter.string(from: last.date)
        weekDaysRange.text = "\(firstDay) - \(lastDay)"
        self.total = week.totalStepsForWeek
        weekTotalSteps.text = "Total: \(total)"
        self.averageSteps = week.averageStepsForWeek
        weekAverageSteps.text = "Average: \(averageSteps)"
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
                    print("[STEPVC] STEPS: \(update.steps)")
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
        [stepsCountLabel, distanceLabel, stepsRemainingLabel].forEach {
            circleStepContainerView.addSubview($0)
        }
        [weekTotalSteps, weekAverageSteps, weekDaysRange].forEach {
            weekInfoView.addSubview($0)
        }
        [circleStepContainerView, weekInfoView, circleProgress].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            circleStepContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.center.y * 0.55),
            circleStepContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleStepContainerView.heightAnchor.constraint(equalToConstant: widthOfUIElements),
            circleStepContainerView.widthAnchor.constraint(equalToConstant: widthOfUIElements),
            
            circleProgress.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.center.y * 0.55),
            circleProgress.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleProgress.heightAnchor.constraint(equalToConstant: widthOfUIElements),
            circleProgress.widthAnchor.constraint(equalToConstant: widthOfUIElements),
         
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
            stepsRemainingLabel.heightAnchor.constraint(equalTo: distanceLabel.heightAnchor),
            
            weekInfoView.topAnchor.constraint(equalTo: circleStepContainerView.bottomAnchor, constant: 130),
            weekInfoView.heightAnchor.constraint(equalToConstant: 50),
            weekInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weekInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            weekDaysRange.centerYAnchor.constraint(equalTo: weekAverageSteps.centerYAnchor, constant: -4),
            weekDaysRange.trailingAnchor.constraint(equalTo: weekInfoView.trailingAnchor, constant: -8),
            weekDaysRange.heightAnchor.constraint(equalToConstant: 24),
            
            weekTotalSteps.topAnchor.constraint(equalTo: weekInfoView.topAnchor, constant: 4),
            weekTotalSteps.leadingAnchor.constraint(equalTo: weekInfoView.leadingAnchor, constant: 8),
            weekTotalSteps.trailingAnchor.constraint(equalTo: weekInfoView.trailingAnchor),
            weekTotalSteps.heightAnchor.constraint(equalToConstant: 20),
            
            weekAverageSteps.topAnchor.constraint(equalTo: weekTotalSteps.bottomAnchor, constant: 2),
            weekAverageSteps.leadingAnchor.constraint(equalTo: weekInfoView.leadingAnchor, constant: 8),
            weekAverageSteps.trailingAnchor.constraint(equalTo: weekInfoView.trailingAnchor),
            weekAverageSteps.heightAnchor.constraint(equalToConstant: 20),
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
        let chartView = weekChartViewController.view
        chartView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chartView!.topAnchor.constraint(equalTo: weekInfoView.bottomAnchor),
            chartView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chartView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chartView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
//        chartView!.isUserInteractionEnabled = true
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(chartSwipe))
//        swipeLeft.direction = .left
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(chartSwipe))
//        swipeRight.direction = .right
//        chartView!.addGestureRecognizer(swipeLeft)
//        chartView!.addGestureRecognizer(swipeRight)
    }
    
    @objc
    private func dateLabelTap() {
        let vc = CalendarViewController()
        vc.delegate = self
        vc.height = weekInfoView.frame.minY
        presentPanModal(vc)
    }
    @objc
    private func chartSwipe(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left: swipeLeft()
        case .right: swipeRight()
        default: break
        }
    }
    private func swipeRight() {
        var newDay = Date()
        if let firstDay = self.selectedWeek.steppingDays.first {
            let firstDate = firstDay.date
            newDay = Calendar.iso8601UTC.date(byAdding: .day, value: -1, to: firstDate)!
        }
        didSelect(newDay)
    }
    private func swipeLeft() {
        var newDay = Date()
        if let lastDay = self.selectedWeek.steppingDays.last {
            let lastDate = lastDay.date
            newDay = Calendar.iso8601UTC.date(byAdding: .day, value: 1, to: lastDate)!
            if newDay < Date() {
                didSelect(newDay)
            }
        }
    }
    
    @objc
    private func settingsButtonPressed() {
        let vc = StepsScreenSettings()
        vc.view.backgroundColor = StepColor.background
        vc.navigationController?.navigationBar.tintColor = StepColor.darkGreen
        UserDefaults.standard.register(defaults: ["stepsGoal": 10000, "distanceGoal": 10])
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
                    self?.updateWeekLabels(week: week)
                    self?.chartDelegate?.updateData(stepWeek: week)
                }
                self.selectedWeek = week
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

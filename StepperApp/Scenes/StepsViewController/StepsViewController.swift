//
//  ViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 09.10.2021.
//

import UIKit
import PanModal
import KDCircularProgress

final class StepsViewController: UIViewController {
    
    private let stepsService: StepsService
    private let pedometerService: PedometerService
    private let usersService: UsersService
    private let userOperations: UserOperations
    
    init(stepsService: StepsService, pedometerService: PedometerService, usersService: UsersService, userOperations: UserOperations) {
        self.usersService = usersService
        self.stepsService = stepsService
        self.pedometerService = pedometerService
        self.userOperations = userOperations
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let currentDay = Date()
    private var lastDay = SteppingDay()
    private var usersGoal: Goal = {
        var stepGoal = UserDefaults.standard.integer(forKey: "stepsGoal")
        if stepGoal == 0 {
            stepGoal = 10000
            UserDefaults.standard.set(stepGoal, forKey: "stepsGoal")
        }
        var distanceGoal = UserDefaults.standard.double(forKey: "distanceGoal")
        if distanceGoal == 0 {
            distanceGoal = 10
            UserDefaults.standard.set(distanceGoal, forKey: "distanceGoal")
        }
        let isMiles = UserDefaults.standard.bool(forKey: "km_miles")
        let isDistance = UserDefaults.standard.bool(forKey: "steps_distance")
        return Goal(steps: stepGoal, distance: distanceGoal, isSteps: !isDistance, isKM: !isMiles)
    } ()
    private var steps = 0
    private var distanceKM: Double = 0
    private var distanceMI: Double = 0
    private var total = 0
    private var averageSteps = 0
    private var circleProgress: KDCircularProgress = {
        let progress = KDCircularProgress(frame: .zero)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.startAngle = -90
        progress.progressThickness = 0.2
        progress.trackThickness = 0.2
        progress.trackColor = StepColor.alpha5
        progress.clockwise = true
        progress.roundedCorners = true
        progress.glowMode = .forward
        progress.glowAmount = 0.9
        progress.set(colors: StepColor.progress)
        progress.angle = 0
        return progress
    }()
    private lazy var circleStepContainerView: CircleView = {
        let view = CircleView()
        view.backgroundColor = StepColor.alpha5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var stepIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "shoeIcon")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = StepColor.darkGreen
        return image
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
        return label
    }()
    private lazy var goalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = StepColor.darkGreen
        return label
    }()
    private lazy var settingsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingsButtonPressed))
        button.tintColor = StepColor.darkGreen
        return button
    }()
    
    private var weekChartViewController: WeekChartViewController!
    private let calendarViewController = CalendarViewController()
    weak var chartDelegate: ChartDelegate?
    private var selectedWeek = SteppingWeek(steppingDays: [])
    
    private let widthOfUIElements = UIScreen.main.bounds.width / 1.8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weekChartViewController = WeekChartViewController(stepsService: stepsService)
        stepsServiceAuth()
        pedometerServiceActivation(lastDay: lastDay)
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
                    self.loadContainsWeek(day: Date())
                } else {
                    print("Alert! Give us permission!")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    private func loadContainsWeek(day: Date) {
        stepsService.fetchWeekContains(day: day) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(var week):
                self.circleProgress.angle = 0
                let lastDay = week.steppingDays.last ?? SteppingDay()
                let user = self.userOperations.getUser()
                var correctDay = lastDay
                guard var guardUser = user else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if guardUser.steps < lastDay.steps {
                        self.steps = lastDay.steps
                        guardUser.steps = lastDay.steps
                    } else {
                        self.steps = guardUser.steps
                        correctDay.steps = guardUser.steps
                        week.steppingDays[week.steppingDays.count - 1].steps = guardUser.steps
                    }
                    if guardUser.km < lastDay.km {
                        self.distanceKM = lastDay.km
                        guardUser.km = lastDay.km
                    } else {
                        self.distanceKM = guardUser.km
                        correctDay.km = guardUser.km
                        week.steppingDays[week.steppingDays.count - 1].km = guardUser.km
                    }
                    if guardUser.miles < lastDay.miles {
                        self.distanceMI = lastDay.miles
                        guardUser.miles = lastDay.miles
                    } else {
                        self.distanceMI = guardUser.miles
                        correctDay.miles = guardUser.miles
                        week.steppingDays[week.steppingDays.count - 1].miles = guardUser.miles
                    }
                    print("[HEALTHKIT] Steps: \(correctDay.steps), KM: \(correctDay.km), Miles: \(correctDay.miles)")
                    self.updateTodayLabels(lastDay: correctDay)
                    self.chartDelegate?.updateData(stepWeek: week)
                    if self.usersGoal.isSteps {
                        let angle = (Double(correctDay.steps)/Double(self.usersGoal.steps))*360
                        self.angleCheck(angle: angle)
                    } else {
                        var angle: Double
                        if self.usersGoal.isKM {
                            angle = (correctDay.km/self.usersGoal.distance)*360
                        } else {
                            angle = (correctDay.miles/self.usersGoal.distance)*360
                        }
                        self.angleCheck(angle: angle)
                    }
                }
                self.selectedWeek = week
                self.lastDay = correctDay
                self.userOperations.saveUser(user: guardUser)
                self.usersService.updateUser(user: guardUser) { error in
                    if error != nil {
                        print("Update user error")
                    }
                    print("User's steps are updated by healthkit!")
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
            case .success(var week):
                self.circleProgress.angle = 0
                let lastDay = week.steppingDays.last ?? SteppingDay()
                let user = self.userOperations.getUser()
                var correctDay = lastDay
                guard var guardUser = user else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if guardUser.steps < lastDay.steps {
                        self.steps = lastDay.steps
                        guardUser.steps = lastDay.steps
                    } else {
                        self.steps = guardUser.steps
                        correctDay.steps = guardUser.steps
                        week.steppingDays[week.steppingDays.count - 1].steps = guardUser.steps
                    }
                    if guardUser.km < lastDay.km {
                        self.distanceKM = lastDay.km
                        guardUser.km = lastDay.km
                    } else {
                        self.distanceKM = guardUser.km
                        correctDay.km = guardUser.km
                        week.steppingDays[week.steppingDays.count - 1].km = guardUser.km
                    }
                    if guardUser.miles < lastDay.miles {
                        self.distanceMI = lastDay.miles
                        guardUser.miles = lastDay.miles
                    } else {
                        self.distanceMI = guardUser.miles
                        correctDay.miles = guardUser.miles
                        week.steppingDays[week.steppingDays.count - 1].miles = guardUser.miles
                    }
                    self.updateTodayLabels(lastDay: correctDay)
                    self.chartDelegate?.updateData(stepWeek: week)
                    if self.usersGoal.isSteps {
                        let angle = (Double(correctDay.steps)/Double(self.usersGoal.steps))*360
                        self.angleCheck(angle: angle)
                    } else {
                        var angle: Double
                        if self.usersGoal.isKM {
                            angle = (correctDay.km/self.usersGoal.distance)*360
                        } else {
                            angle = (correctDay.miles/self.usersGoal.distance)*360
                        }
                        self.angleCheck(angle: angle)
                    }
                }
                self.selectedWeek = week
                self.lastDay = correctDay
                self.userOperations.saveUser(user: guardUser)
                self.usersService.updateUser(user: guardUser) { error in
                    if error != nil {
                        print("Update user error")
                    }
                    print("User's steps are updated by pedometer!")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    private func pedometerServiceActivation(lastDay: SteppingDay) {
        pedometerService.updateStepsAndDistance { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let update):
                //                if self.currentDay != self.pedometerService.getPedometerOldDate() {
                //                    self.pedometerService.pedometerStop()
                //                    self.steps = 0
                //                    self.distanceKM = 0.0
                //                    self.distanceMI = 0.0
                //                    var user = self.userOperations.getUser()
                //                    user?.steps = 0
                //                    user?.miles = 0.0
                //                    user?.km = 0.0
                //                    self.lastDay.km = 0.0
                //                    self.lastDay.miles = 0.0
                //                    self.lastDay.steps = 0
                //                    self.lastDay.date = Date()
                //                    self.userOperations.saveUser(user: user!)
                //                    self.usersService.updateUser(user: user!) { error in
                //                        if error != nil {
                //                            print("Update user error")
                //                        }
                //                        print("User's steps are updated!")
                //                    }
                //                    self.pedometerServiceActivation(lastDay: self.lastDay)
                //                }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let pedometerSteps = Int(truncating: update.steps)
                    let pedometerDistanceKM = Double(truncating: update.distance) / 1000
                    let pedometerDistanceMI = Double(truncating: update.distance) / 1609.34
                    let totalSteps = self.steps + pedometerSteps
                    let totalDistanceKM = self.distanceKM + pedometerDistanceKM
                    let totalDistanceMI = self.distanceMI + pedometerDistanceMI
                    var user = self.userOperations.getUser()
                    var correctDay = lastDay
                    correctDay.steps = totalSteps
                    correctDay.miles = totalDistanceMI
                    correctDay.km = totalDistanceKM
                    user?.steps = totalSteps
                    user?.miles = totalDistanceMI
                    user?.km = totalDistanceKM
                    self.userOperations.saveUser(user: user!)
                    self.usersService.updateUser(user: user!) { error in
                        if error != nil {
                            print("Update user error")
                        }
                        print("User's steps are updated!")
                    }
                    if self.usersGoal.isSteps {
                        let angle = (Double(totalSteps)/Double(self.usersGoal.steps))*360
                        self.angleCheck(angle: angle)
                    } else {
                        var angle: Double
                        if self.usersGoal.isKM {
                            angle = (totalDistanceKM/self.usersGoal.distance)*360
                        } else {
                            angle = (totalDistanceMI/self.usersGoal.distance)*360
                        }
                        self.angleCheck(angle: angle)
                    }
                    self.updateTodayLabels(lastDay: correctDay)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    private func updateTodayLabels(lastDay: SteppingDay) {
        if usersGoal.isSteps {
            stepIcon.isHidden = false
            distanceLabel.isHidden = false
            stepsCountLabel.text = "\(lastDay.steps)"
            let fullString = NSMutableAttributedString(string: "")
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "arrow.forward")
            imageAttachment.image?.withTintColor(StepColor.darkGreen)
            let imageString = NSAttributedString(attachment: imageAttachment)
            fullString.append(imageString)
            fullString.append(.init(string: " "))
            var roundedDistance: String
            if usersGoal.isKM {
                roundedDistance = String(format: "%.01f", lastDay.km)
                fullString.append(NSAttributedString(string: "\(roundedDistance) km"))
            } else {
                roundedDistance = String(format: "%.01f", lastDay.miles)
                fullString.append(NSAttributedString(string: "\(roundedDistance) mi"))
            }
            distanceLabel.attributedText = fullString
            goalLabel.text = "Goal: \(usersGoal.steps)"
        } else {
            stepIcon.isHidden = true
            distanceLabel.isHidden = true
            var roundedDistance: String
            if usersGoal.isKM {
                roundedDistance = String(format: "%.01f", lastDay.km)
                goalLabel.text = "Goal: \(usersGoal.distance) km"
                stepsCountLabel.text = roundedDistance
            } else {
                roundedDistance = String(format: "%.01f", lastDay.miles)
                goalLabel.text = "Goal: \(usersGoal.distance) mi"
                stepsCountLabel.text = roundedDistance
            }
        }
    }

    private func setupNavigation() {
        self.navigationItem.rightBarButtonItem = settingsButton
    }
    
    private func setupLayout() {
        [stepsCountLabel, distanceLabel, goalLabel, stepIcon].forEach {
            circleStepContainerView.addSubview($0)
        }
        [circleStepContainerView,  circleProgress].forEach {
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            circleStepContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.center.y * 0.55),
            circleStepContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleStepContainerView.heightAnchor.constraint(equalToConstant: widthOfUIElements),
            circleStepContainerView.widthAnchor.constraint(equalToConstant: widthOfUIElements),
            
            circleProgress.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.center.y * 0.55),
            circleProgress.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleProgress.heightAnchor.constraint(equalToConstant: widthOfUIElements/0.8),
            circleProgress.widthAnchor.constraint(equalToConstant: widthOfUIElements/0.8),
            
            stepsCountLabel.centerXAnchor.constraint(equalTo: circleStepContainerView.centerXAnchor),
            stepsCountLabel.centerYAnchor.constraint(equalTo: circleStepContainerView.centerYAnchor, constant: -widthOfUIElements * 0.08),
            stepsCountLabel.widthAnchor.constraint(equalTo: circleStepContainerView.widthAnchor, multiplier: 0.715),
            stepsCountLabel.heightAnchor.constraint(equalTo: circleStepContainerView.heightAnchor, multiplier: 0.21),
            
            stepIcon.bottomAnchor.constraint(equalTo: stepsCountLabel.topAnchor, constant: -6),
            stepIcon.centerXAnchor.constraint(equalTo: circleStepContainerView.centerXAnchor),
            stepIcon.widthAnchor.constraint(equalToConstant: 30),
            stepIcon.heightAnchor.constraint(equalToConstant: 30),
            
            goalLabel.centerXAnchor.constraint(equalTo: circleStepContainerView.centerXAnchor),
            goalLabel.topAnchor.constraint(equalTo: stepsCountLabel.bottomAnchor, constant: widthOfUIElements * 0.04),
            goalLabel.widthAnchor.constraint(equalTo: stepsCountLabel.widthAnchor),
            goalLabel.heightAnchor.constraint(equalTo: circleStepContainerView.heightAnchor, multiplier: 0.11),
            
            distanceLabel.centerXAnchor.constraint(equalTo: circleStepContainerView.centerXAnchor),
            distanceLabel.topAnchor.constraint(equalTo: goalLabel.bottomAnchor, constant: widthOfUIElements * 0.04),
            distanceLabel.widthAnchor.constraint(equalTo: circleStepContainerView.widthAnchor, multiplier: 0.5),
            distanceLabel.heightAnchor.constraint(equalTo: goalLabel.heightAnchor),
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
            chartView!.topAnchor.constraint(equalTo: circleStepContainerView.bottomAnchor, constant: 160),
            chartView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chartView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chartView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func angleCheck(angle: Double) {
        if angle >= 360 {
            self.circleProgress.animate(toAngle: 360, duration: 1) { bool in
                self.circleProgress.trackColor = StepColor.progress
            }
        } else {
            self.circleProgress.animate(toAngle: angle, duration: 1, completion: nil)
        }
    }
    
    @objc
    private func settingsButtonPressed() {
        let vc = StepsScreenSettings()
        vc.goalDelegate = self
        vc.view.backgroundColor = StepColor.background
        vc.navigationController?.navigationBar.tintColor = StepColor.darkGreen
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension StepsViewController: GoalDelegate {
    func getNewGoal(newGoal: Goal) {
        if usersGoal != newGoal {
            usersGoal = newGoal
            loadContainsWeek(day: Date())
            pedometerService.pedometerStop()
            pedometerServiceActivation(lastDay: lastDay)
        }
    }
}

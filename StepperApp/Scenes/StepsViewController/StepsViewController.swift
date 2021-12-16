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
    private var currentDay = Date()
    private var lastDay = SteppingDay()
    private var usersGoal = Goal()
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
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
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
    private lazy var addProgressButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addProgress))
        button.tintColor = StepColor.darkGreen
        return button
    }()
    
    @objc
    private func addProgress() {
        let angle = circleProgress.angle + 100
        angleCheck(angle: angle)
    }
    
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
//                    self.loadWeekData()
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
                    self.updateWeekLabels(week: week)
                    self.chartDelegate?.updateData(stepWeek: week)
                    if self.usersGoal.isSteps {
                        let angle = (Double(correctDay.steps)/Double(self.usersGoal.steps))*360
                        if angle >= 360 {
                            self.circleProgress.animate(toAngle: 360, duration: 1, completion: nil)
                            self.circleProgress.isHidden = true // должен перестать меняться вместо пропадания
                        } else {
                            self.circleProgress.isHidden = false
                            self.circleProgress.animate(toAngle: angle, duration: 1, completion: nil)
                        }
                    } else if self.usersGoal.isKM {
                        let angle = (correctDay.km/self.usersGoal.distance)*360
                        if angle >= 360 {
                            self.circleProgress.animate(toAngle: 360, duration: 1, completion: nil)
                            self.circleProgress.isHidden = true
                        } else {
                            self.circleProgress.isHidden = false
                            self.circleProgress.animate(toAngle: angle, duration: 1, completion: nil)
                        }
                    } else {
                        let angle = (correctDay.miles/self.usersGoal.distance)*360
                        if angle >= 360 {
                            self.circleProgress.animate(toAngle: 360, duration: 1, completion: nil)
                            self.circleProgress.isHidden = true
                        } else {
                            self.circleProgress.isHidden = false
                            self.circleProgress.animate(toAngle: angle, duration: 1, completion: nil)
                        }
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
                    print("[HEALTHKIT] Steps: \(correctDay.steps), KM: \(correctDay.km), Miles: \(correctDay.miles)")
                    self.updateTodayLabels(lastDay: correctDay)
                    self.updateWeekLabels(week: week)
                    self.chartDelegate?.updateData(stepWeek: week)
                    if self.usersGoal.isSteps {
                        let angle = (Double(correctDay.steps)/Double(self.usersGoal.steps))*360
                        if angle >= 360 {
                            self.circleProgress.animate(toAngle: 360, duration: 1, completion: nil)
                            self.circleProgress.isHidden = true // должен перестать меняться вместо пропадания
                        } else {
                            self.circleProgress.isHidden = false
                            self.circleProgress.animate(toAngle: angle, duration: 1, completion: nil)
                        }
                    } else if self.usersGoal.isKM {
                        let angle = (correctDay.km/self.usersGoal.distance)*360
                        if angle >= 360 {
                            self.circleProgress.animate(toAngle: 360, duration: 1, completion: nil)
                            self.circleProgress.isHidden = true
                        } else {
                            self.circleProgress.isHidden = false
                            self.circleProgress.animate(toAngle: angle, duration: 1, completion: nil)
                        }
                    } else {
                        let angle = (correctDay.miles/self.usersGoal.distance)*360
                        if angle >= 360 {
                            self.circleProgress.animate(toAngle: 360, duration: 1, completion: nil)
                            self.circleProgress.isHidden = true
                        } else {
                            self.circleProgress.isHidden = false
                            self.circleProgress.animate(toAngle: angle, duration: 1, completion: nil)
                        }
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
                if self.currentDay != self.pedometerService.getPedometerOldDate() {
                    self.pedometerService.pedometerStop()
                    self.steps = 0
                    self.distanceKM = 0.0
                    self.distanceMI = 0.0
                    var user = self.userOperations.getUser()
                    user?.steps = 0
                    user?.miles = 0.0
                    user?.km = 0.0
                    self.lastDay.km = 0.0
                    self.lastDay.miles = 0.0
                    self.lastDay.steps = 0
                    self.lastDay.date = Date()
                    self.userOperations.saveUser(user: user!)
                    self.usersService.updateUser(user: user!) { error in
                        if error != nil {
                            print("Update user error")
                        }
                        print("User's steps are updated!")
                    }
                    self.pedometerServiceActivation(lastDay: self.lastDay)
                }
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
                    print("[PEDOMETER UPDATE] Steps: \(pedometerSteps), KM: \(pedometerDistanceKM), MI: \(pedometerDistanceMI)")
                    print("[AFTER PEDOMETER UPDATE] Steps: \(correctDay.steps), KM: \(correctDay.km), Miles: \(correctDay.miles)")
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
//            stepsCountLabel.text = "\(steps)"
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
//                roundedDistance = String(format: "%.01f", distanceKM)
                roundedDistance = String(format: "%.01f", lastDay.km)
                fullString.append(NSAttributedString(string: "\(roundedDistance) km"))
            } else {
//                roundedDistance = String(format: "%.01f", distanceMI)
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
//                roundedDistance = String(format: "%.01f", distanceKM)
                goalLabel.text = "Goal: \(usersGoal.distance) km"
                stepsCountLabel.text = roundedDistance
            } else {
                roundedDistance = String(format: "%.01f", lastDay.miles)
//                roundedDistance = String(format: "%.01f", distanceMI)
                goalLabel.text = "Goal: \(usersGoal.distance) mi"
                stepsCountLabel.text = roundedDistance
            }
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
        let firstDay = firstDateFormatter.string(from: first.date)
        let lastDay = lastDateFormatter.string(from: last.date)
        weekDaysRange.text = "\(firstDay) - \(lastDay)"
        self.total = week.totalStepsForWeek
        weekTotalSteps.text = "Total: \(total)"
        self.averageSteps = week.averageStepsForWeek
        weekAverageSteps.text = "Average: \(averageSteps)"
    }
    
    private func setupNavigation() {
        self.navigationItem.rightBarButtonItem = settingsButton
        self.navigationItem.leftBarButtonItem = addProgressButton
    }
    
    private func setupLayout() {
        [stepsCountLabel, distanceLabel, goalLabel, stepIcon].forEach {
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
            
            weekInfoView.topAnchor.constraint(equalTo: circleStepContainerView.bottomAnchor, constant: 130),
            weekInfoView.heightAnchor.constraint(equalToConstant: 50),
            weekInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weekInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            weekDaysRange.centerYAnchor.constraint(equalTo: weekAverageSteps.centerYAnchor, constant: -16),
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
    private func dateLabelTap() {
        let vc = CalendarViewController()
        vc.delegate = self
        vc.height = weekChartViewController.view.frame.height + view.safeAreaInsets.bottom + 15
        presentPanModal(vc)
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
        vc.goalDelegate = self
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
                    guard let self = self else { return }
                    self.updateWeekLabels(week: week)
                    self.chartDelegate?.updateData(stepWeek: week)
                }
                self.selectedWeek = week
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension StepsViewController: GoalDelegate {
    func getNewGoal(newGoal: Goal) {
        if usersGoal != newGoal {
            usersGoal = newGoal
//            loadWeekData()
            loadContainsWeek(day: Date())
            pedometerService.pedometerStop()
            pedometerServiceActivation(lastDay: lastDay)
        }
    }
}

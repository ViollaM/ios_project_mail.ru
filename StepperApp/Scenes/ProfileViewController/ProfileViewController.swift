//
//  ProfileViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 09.10.2021.
//

import UIKit
import HealthKit

final class ProfileViewController: UIViewController {
    
    private let profileService: ProfileService
    
    private let imageLoaderService: ImageLoaderService
    
    private let usersService: UsersService
    
    private let userOperations = UserOperations()
    
    init(profileService: ProfileService, usersService: UsersService, imageLoaderService: ImageLoaderService) {
        self.profileService = profileService
        self.imageLoaderService = imageLoaderService
        self.usersService = usersService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var localImageName: String = ""
    
    private var imageCircle: CircleImageView = CircleImageView(image: UIImage(named: "Photo.png"))
    
    private lazy var editButton = UIButton()
    
    private lazy var logoutButton = UIButton()
    
    private lazy var nameTextView = UIView()
    
    private lazy var nameLabel = UILabel()
    
    private lazy var nameTextField = UITextField()
    
    private lazy var nameLeftViewLabel = UILabel()
    
    private lazy var ageTextView = UIView()
    
    private lazy var ageLabel = UILabel()
    
    private lazy var ageTextField = UITextField()
    
    private lazy var ageDatePicker = UIDatePicker()
    
    private lazy var genderSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Male", "Female"])
        sc.selectedSegmentTintColor = UIColor(red: 99/255, green: 142/255, blue: 135/255, alpha: 1)
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: StepColor.cellBackground], for: .selected)
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupLayout()
        configureUI()
    }
    
    private func setupLayout() {
        
        [nameTextView, ageTextView, imageCircle, logoutButton, genderSegmentedControl].forEach {
            view.addSubview($0)
        }
        
        nameTextView.addSubview(nameLabel)
        nameTextView.addSubview(nameTextField)
        
        ageTextView.addSubview(ageLabel)
        ageTextView.addSubview(ageTextField)
        
        imageCircleLayout()
        nameLayout()
        ageLayout()
        genderLayout()
        logoutLayout()
    }
    
    //MARK: configureUI
    
    private func configureUI() {
        let textViews: [UIView] = [nameTextView, ageTextView]
        let textFields: [UITextField] = [nameTextField, ageTextField]
        let textLabels: [UILabel] = [nameLabel, ageLabel]
        
        textViews.forEach {
            $0.backgroundColor = StepColor.cellBackground
            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(handleTap)
            )
            $0.addGestureRecognizer(tapGesture)
        }
        
        textLabels.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textAlignment = .left
            $0.font = UIFont(name: "Arial", size: 20)
        }
        
        textFields.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.autocapitalizationType = .none
            $0.autocorrectionType = .no
            $0.font = UIFont(name: "Arial", size: 20)
            $0.isUserInteractionEnabled = false
        }
        
        let viewTapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.viewTapped(gestureReognizer:)))
        
        view.addGestureRecognizer(viewTapGestureRecogniser)
        
        setUpUIElements()
    }
    
    @objc
    private func viewTapped(gestureReognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        nameTextView.layer.cornerRadius = 10
        ageTextView.layer.cornerRadius = 10
        logoutButton.layer.cornerRadius = 10
    }
    
    @objc
    private func saveButtonClicked() {
        if let name = nameTextField.text {
            let age = profileService.getDate() ?? Date()
            let responseName = Validation.shared.validate(values: (ValidationType.userName, name))
            if ageTextField.text != nil && getAge(birthdate: age) <= 100 {
                switch responseName {
                case .success:
                    let id = userOperations.getUser()!.id
                    let gender = Bool(truncating: genderSegmentedControl.selectedSegmentIndex as NSNumber)
                    let img = imageCircle.image
                    let user = User(id: id, name: name, birthDate: age, isMan: gender, imageName: localImageName)
                    usersService.updateUser(user: user) { [weak self] result in
                        guard let self = self else {
                            return
                        }
                        switch result {
                        case nil:
                            print("success add user")
                            self.userOperations.saveUser(user: user)
                            self.profileService.saveImage(image: img)
                            DispatchQueue.main.async {
                                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.editButton)
                                [self.nameTextField, self.ageTextField].forEach {
                                    $0.isUserInteractionEnabled = false
                                }
                                self.genderSegmentedControl.isUserInteractionEnabled = false
                                self.imageCircle.isUserInteractionEnabled = false
                                self.logoutButton.isHidden = true
                            }
                        case CustomError.userNameTaken?:
                            displayAlert(message: result?.localizedDescription ?? "", viewController: self )
                        default:
                            displayAlert(message: result?.localizedDescription ?? "", viewController: self )
                        }
                    }
                case .failure:
                    displayAlert(message: "Name should contain from 1 to 6 lower- or uppercase letters, digits or -", viewController: self)
                }
            }
            else {
                switch responseName {
                case .success:
                    displayAlert(message: "Age should be in the range [0, 100]", viewController: self)
                case .failure:
                    displayAlert(message: "Name should contain from 1 to 6 lower- or uppercase letters, digits or -; age should be in the range [0, 100]", viewController: self)
                }
            }
        }
        else {
            displayAlert(message: "Name should contain from 1 to 6 lower- or uppercase letters, digits or -", viewController: self)
        }
    }
    
    @objc
    private func editButtonClicked() {
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonClicked))
        saveButton.tintColor = StepColor.darkGreen
        self.navigationItem.rightBarButtonItem = saveButton
        [nameTextField, ageTextField].forEach {
            $0.isUserInteractionEnabled = true
        }
        genderSegmentedControl.isUserInteractionEnabled = true
        imageCircle.isUserInteractionEnabled = true
        logoutButton.isHidden = false
    }
    
    @objc
    private func handleTap(tapGestureRecognizer: UITapGestureRecognizer) {
        guard tapGestureRecognizer.state == .ended else {
            return
        }
        tapGestureRecognizer.view?.becomeFirstResponder()
    }
    
    @objc
    private func handleImageTap(tapGestureRecognizer: UITapGestureRecognizer) {
        guard tapGestureRecognizer.state == .ended else {
            return
        }
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc
    private func dateChanged() {
        let age = getAge(birthdate: ageDatePicker.date)
        profileService.saveDate(birthdate: ageDatePicker.date)
        ageTextField.text = String(age)
    }
    
    private func getAge(birthdate: Date) -> Int {
        let calendar = Calendar.current
        let now = calendar.dateComponents([.year, .month, .day], from: Date())
        let birthdate = calendar.dateComponents([.year, .month, .day], from: birthdate)
        let ageComponents = calendar.dateComponents([.year], from: birthdate, to: now)
        let age = ageComponents.year!
        return age
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func setupNavigationItem () {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
    }
    
    @objc
    private func toAuthorization() {
        UserDefaults.standard.set(false, forKey: "isLogged")
        let authService = AuthServiceImplementation()
        let signUpVC = SignUpViewController(authService: authService)
        let loginVc = LoginViewController(authService: authService)
        let rootVC = AuthorizationViewController(loginVc: loginVc, signUpVc: signUpVC)
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    //MARK: Supporting Functions
    
    private func imageCircleLayout() {
        imageCircle.pin.top(150).hCenter().width(220).height(220)
    }
    
    private func nameLayout() {
        nameTextView.pin.below(of: imageCircle).margin(66).height(43).hCenter().width(220)
        inTextViewConstraints(nameTextView, nameLabel, nameTextField)
    }
    
    private func ageLayout() {
        ageTextView.pin.below(of: nameTextView).margin(4).width(220).height(43).hCenter()
        inTextViewConstraints(ageTextView, ageLabel, ageTextField)
    }
    
    private func genderLayout() {
        genderSegmentedControl.pin.below(of: ageTextView).margin(4).height(43).hCenter().width(220)
    }
    
    private func logoutLayout() {
        logoutButton.pin.below(of: genderSegmentedControl).margin(8).height(43).hCenter().width(220)
    }
    
    private func inTextViewConstraints(_ textView: UIView, _ label: UILabel, _ text: UITextField) {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: textView.topAnchor),
            label.widthAnchor.constraint(equalToConstant: 80),
            label.heightAnchor.constraint(equalToConstant: 43),
            
            text.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -16),
            text.topAnchor.constraint(equalTo: textView.topAnchor),
            text.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 4),
            text.widthAnchor.constraint(equalToConstant: 104),
            text.heightAnchor.constraint(equalToConstant: 43)
        ])
    }
    
    private func setUpUIElements() {
        nameTextField.placeholder = "name"
        nameLeftViewLabel.text = "@"
        nameLeftViewLabel.font = UIFont(name: "Arial", size: 20)
        nameLeftViewLabel.isUserInteractionEnabled = false
        nameTextField.leftView = nameLeftViewLabel
        nameTextField.leftViewMode = .always
        ageTextField.placeholder = "Date of birth"
        
        nameTextField.text = userOperations.getUser()?.name
        
        if let date = userOperations.getUser()?.birthDate {
            ageTextField.text = String(ConvertBrithDayToAge(birthDate: date))
        }
        if let isMan = userOperations.getUser()?.isMan {
            genderSegmentedControl.selectedSegmentIndex = isMan ? 0 : 1
        }
        
       
        if let imPath = profileService.getImage() {
            imageCircle = CircleImageView(image: UIImage(data: imPath))
        } else {
            let imageName = userOperations.getUser()?.imageName

            imageLoaderService.getImage(with: imageName!) { [weak self] result in
                guard let self = self else {
                    return
                }
                DispatchQueue.main.async { [self] in
                    self.imageCircle.image = result
                }
            }
        }
        
        nameLabel.text = "Name:"
        ageLabel.text = "Age:"
        
        genderSegmentedControl.backgroundColor = StepColor.cellBackground
        let font = UIFont(name: "Arial", size: 20)
        genderSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .normal)
        genderSegmentedControl.isUserInteractionEnabled = false
        
        logoutButton.backgroundColor = UIColor(hue: 1, saturation: 1, brightness: 1, alpha: 0)
        logoutButton.setTitleColor(StepColor.darkGreen8, for: .normal)
        logoutButton.titleLabel?.font = UIFont(name: "Arial", size: 20)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.addTarget(self, action: #selector(toAuthorization), for: .touchUpInside)
        logoutButton.isHidden = true
        
        editButton.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        editButton.setTitleColor(StepColor.darkGreen8, for: .normal)
        editButton.titleLabel?.font = UIFont(name: "Arial", size: 16)
        editButton.setTitle("Edit", for: .normal)
        if let editImage = UIImage(named: "pencil.png") {
            editButton.setImage(editImage, for: .normal)
        }
        editButton.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        
        imageCircle.isUserInteractionEnabled = false
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleImageTap)
        )
        imageCircle.addGestureRecognizer(tapGesture)
        
        ageDatePicker.backgroundColor = StepColor.cellBackground
        ageDatePicker.maximumDate = Date()
        ageDatePicker.datePickerMode = .date
        ageDatePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        //ageDatePicker.isHidden = true
        if #available(iOS 14.0, *) {
            ageDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        ageTextField.inputView = ageDatePicker
    }
}

// MARK: image picker setup
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        var imageName = UUID().uuidString
        
        imageLoaderService.upload(image: image) { [weak self] result in
            guard self != nil else {
                return
            }
            switch result{
            case .success(let Id):
                imageName = Id
            case.failure(let error):
                print(error.localizedDescription)
                return
            }
        }
        localImageName = imageName
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath)
            imageCircle.image = UIImage(data: jpegData)
        }
        dismiss(animated: true)
    }
}


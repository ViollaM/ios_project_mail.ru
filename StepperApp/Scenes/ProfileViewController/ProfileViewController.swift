//
//  ProfileViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 09.10.2021.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let profileService: ProfileService
    
    private let imageLoaderService: ImageLoaderService
    
    private let usersService: UsersService
    
    init(profileService: ProfileService, usersService: UsersService, imageLoaderService: ImageLoaderService) {
        self.profileService = profileService
        self.imageLoaderService = imageLoaderService
        self.usersService = usersService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private var localImageName: String = "Photo.png"
    
    private lazy var imageCircle: CircleImageView = {
        var i = CircleImageView(image: UIImage(named: "Photo.png"))
        if let imPath = profileService.getUserInfo().3 {
            i = CircleImageView(image: UIImage(data: imPath))
        }
        return i
    }()
    
    private lazy var editButton = UIButton()
    
    private lazy var logoutButton = UIButton()
    
    private lazy var nameTextView = UIView()
    
    private lazy var nameLabel = UILabel()
    
    private lazy var nameTextField = ErrorTextField()
    
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
            if let age = ageTextField.text {
                let response = Validation.shared.validate(values: (ValidationType.userName, name), (ValidationType.userAge, age))
                switch response.0 {
                case .success:
                    let name = nameTextField.text ?? ""
                    let age = profileService.getDate() ?? Date()
                    let gender = genderSegmentedControl.selectedSegmentIndex
                    let img = imageCircle.image
                    let user = User(id: "12", login: name, birthDate: age, isMan: false, imageName: localImageName)
                    profileService.saveUserInfo(userName: name, userGender: gender, userPicture: img)
                    usersService.updateUser(user: user) { [weak self] result in
                        guard self != nil else {
                            return
                            
                        }
                        switch result {
                        case nil:
                            print("success add user")
                        default:
                            displayAlert(message: result?.localizedDescription ?? "", viewController: self ?? UIViewController())
                        }
                    }
                    
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
                    [nameTextField, ageTextField].forEach {
                        $0.isUserInteractionEnabled = false
                    }
                    genderSegmentedControl.isUserInteractionEnabled = false
                    imageCircle.isUserInteractionEnabled = false
                    logoutButton.isHidden = true
                case .failure:
                    inputAlert(response.1)
                }
            }
            else {
                inputAlert("a")
            }
        }
        else {
            inputAlert("n")
        }
    }
    
    private func inputAlert(_ c: Character) {
        let alert = UIAlertController(title: "Alert", message: "Name should contain only lower- or uppercase letters, age should be in the range [0, 100]", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in self.textError(c)}))
        present(alert, animated: true, completion: nil)
    }
    
    private func textError(_ c: Character) {
        switch c {
        case "n":
            nameTextField.isError(numberOfShakes: 3, revert: true)
        case "a":
            return
        default:
            fatalError()
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
        ageTextField.placeholder = "Выберите дату рождения"
        
        nameTextField.text = profileService.getUserInfo().0
        let date = profileService.getUserInfo().1 ?? Date()
        ageTextField.text = String(getAge(birthdate: date))
        genderSegmentedControl.selectedSegmentIndex = profileService.getUserInfo().2
        
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


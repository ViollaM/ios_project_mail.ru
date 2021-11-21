//
//  ProfileViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 09.10.2021.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let profileService: ProfileService
    
    init(profileService: ProfileService) {
        self.profileService = profileService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageCircle: CircleImageView = {
        var i = CircleImageView(image: UIImage(named: "Photo.png"))
        if let imPath = UserDefaults.standard.data(forKey: "image") {
            i = CircleImageView(image: UIImage(data: imPath))
        }
        return i
    }()
    
    private lazy var editButton = UIButton()
    
    private lazy var editPhotoButton = UIButton()
    
    private lazy var nameTextView = UIView()
    
    private lazy var nameLabel = UILabel()
    
    private lazy var nameTextField = ErrorTextField()
    
    private lazy var ageTextView = UIView()
    
    private lazy var ageLabel = UILabel()
    
    private lazy var ageTextField = ErrorTextField()
    
    private let bgColour = UIColor(red: 204/255, green: 228/255, blue: 225/255, alpha: 1)
    
    private lazy var genderSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Male", "Female"])
        sc.selectedSegmentTintColor = UIColor(red: 99/255, green: 142/255, blue: 135/255, alpha: 1)
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: bgColour], for: .selected)
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupLayout()
        configureUI()
    }
    
    private func setupLayout() {
        
        [nameTextView, ageTextView, editPhotoButton, imageCircle].forEach {
            view.addSubview($0)
        }
        view.addSubview(genderSegmentedControl)
        
        nameTextView.addSubview(nameLabel)
        nameTextView.addSubview(nameTextField)
        
        ageTextView.addSubview(ageLabel)
        ageTextView.addSubview(ageTextField)
        
        imageCircleLayout()
        editPhotoButtonLayout()
        nameLayout()
        ageLayout()
        genderLayout()
    }
    
    //MARK: configureUI
    
    private func configureUI() {
        let textViews: [UIView] = [nameTextView, ageTextView]
        let textFields: [UITextField] = [nameTextField, ageTextField]
        let textLabels: [UILabel] = [nameLabel, ageLabel]
        
        textViews.forEach {
            $0.backgroundColor = bgColour
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
        
        setUpUIElements()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        nameTextView.layer.cornerRadius = 10
        ageTextView.layer.cornerRadius = 10
    }
    
    @objc
    private func saveButtonClicked() {
        
        if let name = nameTextField.text {
            if let age = ageTextField.text {
                let response = Validation.shared.validate(values: (ValidationType.userName, name), (ValidationType.userAge, age))
                switch response.0 {
                case .success:
                    UserDefaults.standard.set(nameTextField.text, forKey: "name")
                    UserDefaults.standard.set(ageTextField.text, forKey: "age")
                    //UserDefaults.standard.set(genderSegmentedControl.selectedSegmentIndex, forKey: "gender")
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
                    [nameTextField, ageTextField].forEach {
                        $0.isUserInteractionEnabled = false
                    }
                    genderSegmentedControl.isUserInteractionEnabled = false
                    editPhotoButton.alpha = 0
                    editPhotoButton.isEnabled = false
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
        UserDefaults.standard.set(genderSegmentedControl.selectedSegmentIndex, forKey: "gender")
    }
    
    private func inputAlert(_ c: Character) {
        let alert = UIAlertController(title: "Alert", message: "Name should start with @ and contain only lower- or uppercase letters, age should be in the range [0, 100]", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in self.textError(c)}))
        present(alert, animated: true, completion: nil)
    }
    
    private func textError(_ c: Character) {
        switch c {
        case "n":
            nameTextField.isError(numberOfShakes: 3, revert: true)
        case "a":
            ageTextField.isError(numberOfShakes: 3, revert: true)
        default:
            fatalError()
        }
    }
    
    @objc
    private func editButtonClicked() {
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonClicked))
        saveButton.tintColor = UIColor(red: 12/255, green: 38/255, blue: 36/255, alpha: 1)
        self.navigationItem.rightBarButtonItem = saveButton
        [nameTextField, ageTextField].forEach {
            $0.isUserInteractionEnabled = true
        }
        genderSegmentedControl.isUserInteractionEnabled = true
        editPhotoButton.alpha = 1
        editPhotoButton.isEnabled = true
    }
    
    @objc
    private func handleTap(tapGestureRecognizer: UITapGestureRecognizer) {
        guard tapGestureRecognizer.state == .ended else {
            return
        }
        tapGestureRecognizer.view?.becomeFirstResponder()
    }
    
    @objc
    private func editPhotoButtonClicked() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func setupNavigationItem () {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
    }
    
    //MARK: Supporting Functions
    
    private func imageCircleLayout() {
        imageCircle.pin.top(200).hCenter().width(220).height(220)
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
    
    private func editPhotoButtonLayout() {
        NSLayoutConstraint.activate([
            editPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editPhotoButton.topAnchor.constraint(equalTo: imageCircle.bottomAnchor, constant: 5)
        ])
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
        nameTextField.placeholder = "@name"
        ageTextField.placeholder = "age"
        
        nameTextField.text = UserDefaults.standard.string(forKey: "name") ?? ""
        ageTextField.text = UserDefaults.standard.string(forKey: "age") ?? ""
        genderSegmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "gender")
        
        nameLabel.text = "Name:"
        ageLabel.text = "Age:"
        
        genderSegmentedControl.backgroundColor = bgColour
        let font = UIFont(name: "Arial", size: 20)
        genderSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .normal)
        genderSegmentedControl.isUserInteractionEnabled = false
        
        editButton.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        editButton.setTitleColor(UIColor(red: 12/255, green: 38/255, blue: 36/255, alpha: 0.8), for: .normal)
        editButton.titleLabel?.font = UIFont(name: "Arial", size: 16)
        editButton.setTitle("Edit", for: .normal)
        if let editImage = UIImage(named: "pencil.png") {
            editButton.setImage(editImage, for: .normal)
        }
        editButton.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        
        editPhotoButton.isEnabled = false
        editPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        editPhotoButton.alpha = 0
        editPhotoButton.setTitle("Edit photo", for: .normal)
        editPhotoButton.titleLabel?.font = UIFont(name: "Arial", size: 16)
        editPhotoButton.setTitleColor(UIColor(red: 12/255, green: 38/255, blue: 36/255, alpha: 0.8), for: .normal)
        editPhotoButton.frame = CGRect(x: 0, y: 0, width: 90, height: 16)
        editPhotoButton.addTarget(self, action: #selector(editPhotoButtonClicked), for: .touchUpInside)
    }
}

// MARK: image picker setup
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath)
            UserDefaults.standard.set(jpegData, forKey: "image")
            imageCircle.image = UIImage(data: jpegData)
        }
        dismiss(animated: true)
    }
}

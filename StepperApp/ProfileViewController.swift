//
//  ProfileViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 09.10.2021.
//

import UIKit

class UserModel: NSObject, NSCoding {
    
    let name: String
    let age: Int
    let gender: String
    
    init(name: String, age: Int, gender: String){
        self.name = name
        self.age = age
        self.gender = gender
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(age, forKey: "age")
        coder.encode(gender, forKey: "gender")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        age = coder.decodeObject(forKey: "age") as? Int ?? -1
        gender = coder.decodeObject(forKey: "gender") as? String ?? ""
    }
}

final class UserSettings {
    
    private enum SettingsKeys: String {
        case userModel
    }
    
    static var userModel: UserModel! {
        get {
            guard let savedData = UserDefaults.standard.object(forKey: SettingsKeys.userModel.rawValue) as? Data, let decodedModel = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? UserModel else {return nil}
            return decodedModel
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.userModel.rawValue
            if let userModel = newValue {
                if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: userModel, requiringSecureCoding: false) {
                    defaults.set(savedData, forKey: key)
                }
            }
            else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private lazy var nameTextField: UITextField = {
        let nameTextField = UITextField()
        return nameTextField
    }()
    
    private lazy var nameTextFieldInput: UITextField = {
        let nameTextFieldInput = UITextField()
        return nameTextFieldInput
    }()
    
    private lazy var ageTextField: UITextField = {
        let ageTextField = UITextField()
        return ageTextField
    }()
    
    private lazy var ageTextFieldInput: UITextField = {
        let ageTextFieldInput = UITextField()
        return ageTextFieldInput
    }()
    
    private lazy var genderTextField: UITextField = {
        let genderTextField = UITextField()
        return genderTextField
    }()
    
    private lazy var genderTextFieldInput: UITextField = {
        let genderTextFieldInput = UITextField()
        return genderTextFieldInput
    }()
    
    private lazy var editButton: UIButton = {
        let editButton = UIButton()
        return editButton
    }()
    
    private lazy var editPhotoButton: UIButton = {
        let editPhotoButton = UIButton()
        return editPhotoButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationItem()
        setupBackground()
        setupLayout()
        configureUI()
    }

    func setupLayout() {
        
        [nameTextFieldInput, ageTextFieldInput, genderTextFieldInput, editButton, editPhotoButton].forEach {
            view.addSubview($0)
        }
        
        nameTextFieldInputLayout()
        ageTextFieldInputLayout()
        genderTextFieldInputLayout()
        editPhotoButtonLayout()
        
        
        NSLayoutConstraint.activate([
            //разделить по компонентам
            //title в nav bar
            //edit в nav bar
            //настроить констрейнты относительно не view
            
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -7)
        ])
    }
    
    private func nameTextFieldInputLayout() {
        NSLayoutConstraint.activate([
            nameTextFieldInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 359),
            nameTextFieldInput.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextFieldInput.widthAnchor.constraint(equalToConstant: 220),
            nameTextFieldInput.heightAnchor.constraint(equalToConstant: 43)
        ])
    }
    
    private func ageTextFieldInputLayout() {
        NSLayoutConstraint.activate([
            ageTextFieldInput.topAnchor.constraint(equalTo: nameTextFieldInput.bottomAnchor, constant: 4),
            ageTextFieldInput.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ageTextFieldInput.widthAnchor.constraint(equalToConstant: 220),
            ageTextFieldInput.heightAnchor.constraint(equalToConstant: 43)
        ])
    }
    
    private func genderTextFieldInputLayout() {
        NSLayoutConstraint.activate([
            genderTextFieldInput.topAnchor.constraint(equalTo: ageTextFieldInput.bottomAnchor, constant: 4),
            genderTextFieldInput.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            genderTextFieldInput.widthAnchor.constraint(equalToConstant: 220),
            genderTextFieldInput.heightAnchor.constraint(equalToConstant: 43)
        ])
    }
    
    private func editPhotoButtonLayout() {
        NSLayoutConstraint.activate([
            editPhotoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 63),
            editPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "BG")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func configureUI() {
        let txtFields: [UITextField] = [nameTextField, ageTextField, genderTextField]
        let txtFieldInputs: [UITextField] = [nameTextFieldInput, ageTextFieldInput, genderTextFieldInput]
        for item in txtFields {
            item.translatesAutoresizingMaskIntoConstraints = false
            item.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 43))
            item.leftViewMode = .always
            item.isUserInteractionEnabled = false
            item.font = UIFont(name: "Arial", size: 20)
        }
        
        let username = "@violla"
        let userage = "20"
        let usergender = "female"
        
        nameTextFieldInput.leftView = nameTextField
        ageTextFieldInput.leftView = ageTextField
        genderTextFieldInput.leftView = genderTextField
        
        nameTextFieldInput.text = username
        ageTextFieldInput.text = userage
        genderTextFieldInput.text = usergender
        
        nameTextField.text = "Name:  "
        ageTextField.text = "Age:  "
        genderTextField.text = "Gender:  "
        
        for item in txtFieldInputs {
            item.translatesAutoresizingMaskIntoConstraints = false
            item.isUserInteractionEnabled = false
            item.font = UIFont(name: "Arial", size: 20)
            item.leftViewMode = .always
            item.layer.cornerRadius = 10
            item.backgroundColor = UIColor(red: 204/255, green: 228/255, blue: 225/255, alpha: 1)
            item.isUserInteractionEnabled = false
            item.font = UIFont(name: "Arial", size: 20)
        }
        
        editButton.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        editButton.setTitleColor(UIColor(red: 12/255, green: 38/255, blue: 36/255, alpha: 0.8), for: .normal)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.titleLabel?.font = UIFont(name: "Arial", size: 16)
        editButton.setTitle("Edit", for: .normal)
        if let editImage = UIImage(named: "pencil.png") {
            editButton.setImage(editImage, for: .normal)
        }
        editButton.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        
        editPhotoButton.frame = CGRect(x: 35, y: 153, width: 298, height: 283)
        editPhotoButton.layer.cornerRadius = 0.5 * editPhotoButton.bounds.size.width
        editPhotoButton.clipsToBounds = true
        editPhotoButton.setImage(UIImage(named:"Photo.png"), for: .disabled)
        editPhotoButton.isEnabled = false
        editPhotoButton.addTarget(self, action: #selector(editPhotoButtonClicked), for: .touchUpInside)
    }
    
    @objc func editButtonClicked() {
        nameTextFieldInput.text = ""
        ageTextFieldInput.text = ""
        genderTextFieldInput.text = ""
        nameTextField.isUserInteractionEnabled = true
        editPhotoButton.isEnabled = true
        editPhotoButton.setImage(UIImage(named:"Photo.png"), for: .normal)
    }
    
    @objc func editPhotoButtonClicked() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath)
            editPhotoButton.setImage(UIImage(data: jpegData), for: .normal)
            editPhotoButton.setImage(UIImage(data: jpegData), for: .disabled)
        }
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func setupNavigationItem () {
            self.title = "Profile"
        }
}

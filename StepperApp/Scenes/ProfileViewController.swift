//
//  ProfileViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 09.10.2021.
//

import UIKit


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private lazy var imageCircle: UIImageView = {
        var i = UIImageView(image: UIImage(named: "Photo.png"))
        if let imPath = UserDefaults.standard.data(forKey: "image") {
            i = UIImageView(image: UIImage(data: imPath))
        }
        return i
    }()
    
    private lazy var editButton: UIButton = {
        let editButton = UIButton()
        return editButton
    }()
    
    private lazy var editPhotoButton: UIButton = {
        let editPhotoButton = UIButton()
        return editPhotoButton
    }()
    
    private lazy var nameTextView: UIView = {
       let v = UIView()
        return v
    }()
    
    private lazy var nameLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    
    private lazy var nameTextField: UITextField = {
        let t = UITextField()
        return t
    }()
    
    private lazy var ageTextView: UIView = {
       let v = UIView()
        return v
    }()
    
    private lazy var ageLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    
    private lazy var ageTextField: UITextField = {
        let t = UITextField()
        return t
    }()
    
    private lazy var genderTextView: UIView = {
       let v = UIView()
        return v
    }()
    
    private lazy var genderLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    
    private lazy var genderTextField: UITextField = {
        let t = UITextField()
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupLayout()
        configureUI()
    }

    func setupLayout() {
        
        [nameTextView, ageTextView, genderTextView, editPhotoButton, imageCircle].forEach {
            view.addSubview($0)
        }
        
        nameTextView.addSubview(nameLabel)
        nameTextView.addSubview(nameTextField)
        
        ageTextView.addSubview(ageLabel)
        ageTextView.addSubview(ageTextField)
        
        genderTextView.addSubview(genderLabel)
        genderTextView.addSubview(genderTextField)
        
        imageCircleLayout()
        editPhotoButtonLayout()
        nameLayout()
        ageLayout()
        genderLayout()
    }
    
    private func imageCircleLayout() {
        imageCircle.pin.top(120).hCenter().width(220).height(220)
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
        genderTextView.pin.below(of: ageTextView).width(220).height(43).hCenter().margin(4)
        inTextViewConstraints(genderTextView, genderLabel, genderTextField)
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
    
    func configureUI() {
        let textViews: [UIView] = [nameTextView, ageTextView, genderTextView]
        let textFields: [UITextField] = [nameTextField, ageTextField, genderTextField]
        let textLabels: [UILabel] = [nameLabel, ageLabel, genderLabel]
        
        textViews.forEach {
            $0.backgroundColor = UIColor(red: 204/255, green: 228/255, blue: 225/255, alpha: 1)
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
        
        nameTextField.text = UserDefaults.standard.string(forKey: "name") ?? ""
        ageTextField.text = UserDefaults.standard.string(forKey: "age") ?? ""
        genderTextField.text = UserDefaults.standard.string(forKey: "gender") ?? ""
        
        nameLabel.text = "Name:"
        ageLabel.text = "Age:"
        genderLabel.text = "Gender:"
        
        
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
        
        imageCircle.makeRounded()
        
        if let navigationBar = self.navigationController?.navigationBar {
            let profileTitleFrame = CGRect(x: 24, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
            let profileTitleLabel = UILabel(frame: profileTitleFrame)
            profileTitleLabel.text = "Profile"
            profileTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
            navigationBar.addSubview(profileTitleLabel)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        nameTextView.layer.cornerRadius = 10
        ageTextView.layer.cornerRadius = 10
        genderTextView.layer.cornerRadius = 10
    }
    
    @objc func saveButtonClicked() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
        [nameTextField, ageTextField, genderTextField].forEach {
            $0.isUserInteractionEnabled = false
        }
        editPhotoButton.alpha = 0
        editPhotoButton.isEnabled = false
        UserDefaults.standard.set(nameTextField.text, forKey: "name")
        UserDefaults.standard.set(ageTextField.text, forKey: "age")
        UserDefaults.standard.set(genderTextField.text, forKey: "gender")
    }
    
    @objc func editButtonClicked() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonClicked))
        [nameTextField, ageTextField, genderTextField].forEach {
            $0.isUserInteractionEnabled = true
        }
        editPhotoButton.alpha = 1
        editPhotoButton.isEnabled = true
    }
    
    @objc func handleTap(tapGestureRecognizer: UITapGestureRecognizer) {
        guard tapGestureRecognizer.state == .ended else {
            return
        }
        tapGestureRecognizer.view?.becomeFirstResponder()
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
            UserDefaults.standard.set(jpegData, forKey: "image")
            imageCircle.image = UIImage(data: jpegData)
            imageCircle.makeRounded()
        }
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func setupNavigationItem () {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
    }
}

extension UIImageView {

    func makeRounded() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

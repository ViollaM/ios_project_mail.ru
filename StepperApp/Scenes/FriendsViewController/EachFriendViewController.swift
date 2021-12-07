//
//  EachFriendViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 17.11.2021.
//

import UIKit
import PinLayout

final class EachFriendViewController: UIViewController {

    var friend: User? {
        didSet {
            avatar = CircleImageView(image: UIImage(named: friend?.imageName ?? "Photo"))
            name.text = "Name: @\(friend?.login ?? "user")"
            age.text = "Age: \(ConvertBrithDayToAge(birthDate: friend?.birthDate ?? Date()) )"
            if let a = friend?.isMan {
                if a {
                    gender.text = "Gender: Male"
                } else {
                    gender.text = "Gender: Female"
                }
            }
        }
    }

    private lazy var avatar = CircleImageView()
    
    private lazy var name: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()

    private lazy var age: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        return label
    }()

    private lazy var gender: UILabel = {
        let label = UILabel()
        label.text = "Unknown"
        label.font = .systemFont(ofSize: 22)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        [avatar, name, age, gender].forEach {
            view.addSubview($0)
        }
        view.backgroundColor = StepColor.cellBackground
        avatar.pin
            .top(view.safeAreaInsets.top + 20)
            .left(20)
            .width(200)
            .height(200)

        name.pin
            .below(of: avatar)
            .marginTop(20)
            .horizontally(20)
            .height(50)
        
        age.pin
            .below(of: name)
            .marginTop(20)
            .horizontally(20)
            .height(50)
        
        gender.pin
            .below(of: age)
            .marginTop(20)
            .horizontally(20)
            .height(50)
    }
}

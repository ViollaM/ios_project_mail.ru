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
            nameTitle.text = "Hi! I'm @\(friend?.name ?? "user")"
            competitionLabel.text = "@\(friend?.name ?? "user")'s competitions:"
        }
    }
    
    private lazy var avatar = CircleImageView()
    
    private lazy var nameTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = StepColor.darkGreen
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    private lazy var competitionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = StepColor.darkGreen
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [avatar, nameTitle, competitionLabel].forEach {
            view.addSubview($0)
        }
        view.backgroundColor = StepColor.cellBackground
        nameTitle.pin
            .top(view.safeAreaInsets.top + 10)
            .horizontally()
            .height(34)
        
        avatar.pin
            .below(of: nameTitle)
            .marginTop(24)
            .width(220)
            .height(220)
            .hCenter()
        
        competitionLabel.pin
            .below(of: avatar)
            .marginTop(24)
            .horizontally(40)
            .height(24)
        
    }
}

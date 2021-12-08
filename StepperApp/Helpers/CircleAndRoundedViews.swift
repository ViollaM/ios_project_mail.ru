//
//  CircleImageView.swift
//  StepperApp
//
//  Created by Ruben Egikian on 14.11.2021.
//

import UIKit

final class CircleImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
    }
}

final class CircleView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
    }
}

final class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}

final class RoundView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}

final class RoundButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}

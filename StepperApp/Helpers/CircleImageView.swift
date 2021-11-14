//
//  CircleImageView.swift
//  StepperApp
//
//  Created by Ruben Egikian on 14.11.2021.
//

import UIKit

class CircleImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
    }
}

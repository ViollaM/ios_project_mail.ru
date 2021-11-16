//
//  EachCompetitionViewController.swift
//  StepperApp
//
//  Created by Маргарита Яковлева on 14.11.2021.
//

import Foundation
import UIKit
import PinLayout


protocol EachCompetitionViewControllerDelegate: AnyObject {
    func didTapChatButton(EachCompetitionViewController: UIViewController, productId: String)
}

final class EachCompetitionViewController: UICollectionViewController {
    
    var product: competitionData? {
        didSet {
            guard let product = product else {
                return
            }
            
            configure(with: product)
            
        }
    }
    
    private let titleLabel = UILabel()
    
    weak var delegate: EachCompetitionViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Product"
        view.backgroundColor = .systemBackground
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseButton))
        navigationItem.rightBarButtonItem = closeButton
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        view.addSubview(titleLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleLabel.pin
            .top(30)
            .horizontally(12)
            .height(32)
    }
    
    @objc
    private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func configure(with product: competitionData) {
        titleLabel.text = product.name
    }

}

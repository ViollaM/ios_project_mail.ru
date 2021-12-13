//
//  SelfGoalViewController.swift
//  StepperApp
//
//  Created by Ruben Egikian on 03.12.2021.
//

import Foundation
import UIKit

final class StepsScreenSettings: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SettingsDailyGoalCell.self, forCellWithReuseIdentifier: String(describing: SettingsDailyGoalCell.self))
        collectionView.register(SettingsUnitMeasureCell.self, forCellWithReuseIdentifier: String(describing: SettingsUnitMeasureCell.self))
        collectionView.register(SettingsIconsCell.self, forCellWithReuseIdentifier: String(describing: SettingsIconsCell.self))
        collectionView.register(SettingsThemesCell.self, forCellWithReuseIdentifier: String(describing: SettingsThemesCell.self))
        collectionView.register(SettingsHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: SettingsHeader.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let appIconNames = ["gow", "wob", "gob", "wog"]
    private let themeNames = ["BG", "BG2", "BG3"]
    private let sectionTitles = ["Daily goal", "Unit measure", "Icons", "Theme"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout () {
        view.addSubview(collectionView)
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension StepsScreenSettings: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 72, height: 35)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return appIconNames.count
        case 3: return themeNames.count
        default: return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dailyGoalCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SettingsDailyGoalCell.self), for: indexPath) as! SettingsDailyGoalCell
        let unitMeasureCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SettingsUnitMeasureCell.self), for: indexPath) as! SettingsUnitMeasureCell
        let iconsCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SettingsIconsCell.self), for: indexPath) as! SettingsIconsCell
        let themesCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SettingsThemesCell.self), for: indexPath) as! SettingsThemesCell
        switch indexPath.section {
        case 2:  iconsCell.icon = appIconNames[indexPath.row]
        case 3:  themesCell.theme = themeNames[indexPath.row]
        default: break
        }
        switch indexPath.section {
        case 0: return dailyGoalCell
        case 1: return unitMeasureCell
        case 2: return iconsCell
        case 3: return themesCell
        default: return iconsCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0: return CGSize(width: 300, height: 85)
        case 1: return CGSize(width: 300, height: 38)
        case 2: return CGSize(width: 90, height: 90)
        case 3: return CGSize(width: 90, height: 90)
        default: return CGSize(width: 90, height: 90)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 17
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 32, bottom: 4, right: 39)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: SettingsHeader.self), for: indexPath) as! SettingsHeader
        header.text = sectionTitles[indexPath.section]
        return header
    }
}


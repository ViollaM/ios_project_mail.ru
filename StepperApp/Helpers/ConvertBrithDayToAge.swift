//
//  ConvertBrithDayToAge.swift
//  StepperApp
//
//  Created by Стас Чебыкин on 07.12.2021.
//

import Foundation


func ConvertBrithDayToAge(birthDate: Date) -> Int {
    return Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year!
}

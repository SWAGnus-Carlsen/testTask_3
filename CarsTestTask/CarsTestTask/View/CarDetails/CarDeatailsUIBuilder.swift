//
//  CarDeatailsUIBuilder.swift
//  CarsTestTask
//
//  Created by Vitaliy Halai on 31.12.23.
//

import UIKit

enum CarDeatailsUIBuilder {
    static func createHeaderLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = text
        return label
    }
    
    static func createInfoLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = text
        label.isUserInteractionEnabled = false
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }
}

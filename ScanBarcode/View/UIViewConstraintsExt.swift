//
//  UIViewExtension.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 4/12/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func pin(to superView: UIView, y: Int, bottomOffset: Int) {
        translatesAutoresizingMaskIntoConstraints                                                       = false
        bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: CGFloat(bottomOffset)).isActive             = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive                             = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive   = true
        topAnchor.constraint(equalTo: superView.topAnchor, constant: CGFloat(y)).isActive             = true
    }
    
    func removeAllConstraints() {
        var _superview = self.superview

        while let superview = _superview {
            for constraint in superview.constraints {

                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }

                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }

            _superview = superview.superview
        }

        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
}

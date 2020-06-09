//
//  BarcodeTableViewCell.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 4/12/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import UIKit

class BarcodeTableViewCell: UITableViewCell {
    
    var titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.3)
        self.addSubview(titleLabel)
        self.setTitleLabelConstraints()
        self.setTitleLabel(text: "NoText")
    }
    
    private func setTitleLabel(text: String) {
        titleLabel.numberOfLines                = 0
        titleLabel.adjustsFontSizeToFitWidth    = true
//        titleLabel.text                         = text
        titleLabel.text                         = "NO BARCODE"

    }
    
    func setTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints                                                                   = false
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive                                   = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive                  = true
        titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive                                       = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive   = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

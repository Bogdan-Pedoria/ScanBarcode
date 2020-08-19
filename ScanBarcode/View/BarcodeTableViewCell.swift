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
    var ratingLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.3)
        self.addSubview(titleLabel)
        self.setTitleLabel(text: "NoText")
        self.setTitleLabelConstraints()
        self.setRatingLabel()
    }
    
    private func setRatingLabel() {
        self.addSubview(ratingLabel)
        self.setRatingLabelConstraints()
        self.ratingLabel.text = "0"
        self.ratingLabel.font = UIFont.boldSystemFont(ofSize: 12)
//        self.ratingLabel.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.3)
    }
    
    private func setTitleLabel(text: String) {
        titleLabel.numberOfLines                = 0
        titleLabel.adjustsFontSizeToFitWidth    = true
//        titleLabel.text                         = text
        titleLabel.text                         = "NO BARCODE"

    }
    
    private func setRatingLabelConstraints() {
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        ratingLabel.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
        ratingLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        ratingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func setTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

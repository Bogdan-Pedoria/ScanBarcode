//
//  SideMenu.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 8/24/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import UIKit

class SideMenu: UIView {

    
    lazy var hostingView = UIView()
    
    // CONSTANTS
    let WIDTH = CGFloat(50)
    
    //constraints
    var leftConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    init(parentView: UIView) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.hostingView = parentView
        self.create()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func create() {
        self.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)
        self.isOpaque = true
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hide)))
        self.addGestureRecognizer(UISwipeGestureRecognizer(target: <#T##Any?#>, action: <#T##Selector?#>))
    }
    
    
    func place() {
        self.hostingView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leftConstraint = self.leadingAnchor.constraint(equalTo: self.hostingView.leadingAnchor)
        self.leftConstraint?.isActive = true
        self.topAnchor.constraint(equalTo: self.hostingView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: self.hostingView.bottomAnchor).isActive = true
        self.widthConstraint = self.widthAnchor.constraint(equalToConstant: WIDTH)
        self.widthConstraint?.isActive = true
        self.hostingView.bringSubviewToFront(self)
        self.hostingView.layer.insertSublayer(self.layer, above: self.hostingView.layer.sublayers?.last)
    }
    
    func show(on parentView: UIView) {
        
    }
    
    
    @objc func hide() {
        
        self.leftConstraint?.isActive = false
        self.leadingAnchor.constraint(equalTo: self.hostingView.leadingAnchor, constant: -self.WIDTH).isActive = true
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.hostingView.layoutIfNeeded()
        }, completion: nil)
//        self.leadingAnchor.constraint(equalTo: self.hostingView.leadingAnchor, constant: -WIDTH).isActive = true
    }
    
    func showOffBeforeUser() {
        self.place()
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(hide), userInfo: nil, repeats: false)
    }

}

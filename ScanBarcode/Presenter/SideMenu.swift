//
//  SideMenu.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 8/24/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import UIKit

class SideMenu: UIView {

    // VIEWS
    lazy var hostingView = UIView()
    lazy var childView = UIView()
    
    // BUTTONS
    var buttons: [UIButton] = [UIButton]() {
        didSet {
            debug("IN DID SET")
            self.setButtons()
        }
    }
    
    // CONSTANTS
    /// SIZE CONSTANTS
    let HIDING_WIDTH = CGFloat(30)
    let SHOWING_WIDTH = UIScreen.main.bounds.width - CGFloat(30)// -30, so i can see by difference, where view ends
    let HEIGHT = CGFloat(400)
    let CHILD_VIEW_WIDTH = CGFloat(50)
    /// HAD NO CHOICE FOR THE TIME GIVEN
    let CHILD_VIEW_HEIGHT = CGFloat(215)
    let PADDING = CGFloat(50) // IT IS BUTTONS HEIGHT IN VC
    /// VIEW CONSTANTS
    let BASE_BACKGROUND_COLOR = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    let CHILD_BACKGROUND_COLOR = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0)
    
    //CONSTRAINTS
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    /// child
    var leadingChildViewConstraint: NSLayoutConstraint?
    var topChildViewConstraint: NSLayoutConstraint?
    var heightChildViewConstraint: NSLayoutConstraint?
    var widthChildViewConstraint: NSLayoutConstraint?
    
    //TOUCHES
    lazy var swipeLeftToHideChild = UISwipeGestureRecognizer(target: self, action: #selector(self.hide))
    lazy var swipeRightToShowChild = UISwipeGestureRecognizer(target: self, action: #selector(self.show))
    lazy var tap = UITapGestureRecognizer(target: self, action: #selector(self.showOrHide))
    
    // FLAGS
    var isShowing: Bool?
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
    
    private func setButtons() {
        
        debug("In SetButtons()")
        var sumHeight: CGFloat = 0
//            if let buttons = buttons {
        // REPLACING WITH
        if buttons != nil {
                for button in buttons {
                    setButton(button: button, topHeight: sumHeight)
                    sumHeight += button.bounds.height
                }
            }
    }
    
    
    private func setButton(button: UIButton, topHeight: CGFloat) {
        
        debug("In SetButton()")
        if topHeight + button.bounds.height <= self.childView.bounds.height {
        #warning("TODO: HAVE NO TIME TO IMPLEMENT CONDITION WHEN BUTTONS SUM HEIGHT IS BIGGER THAN VIEWS HEIGHT: TO EXPAND VIEW TO THE RIGHT AND STACK BUTTONS THERE")
        }
            self.childView.addSubview(button)
            self.layoutIfNeeded()
    }
    
    
    func create() {
        self.backgroundColor = self.BASE_BACKGROUND_COLOR
        self.isOpaque = true
        self.isUserInteractionEnabled = true
        self.swipeLeftToHideChild.direction = .left
        self.addGestureRecognizer(swipeLeftToHideChild)
        self.swipeRightToShowChild.direction = .right
        self.addGestureRecognizer(swipeRightToShowChild)
        
        self.tap.cancelsTouchesInView = true
        self.tap.delegate = self
        self.addGestureRecognizer(tap)
        
        self.childView.backgroundColor = self.CHILD_BACKGROUND_COLOR
        self.childView.isUserInteractionEnabled = true
//        self.childView.addGestureRecognizer(swipeLeftToHideChild)
    }
    
    func pinChildView() {
        self.addSubview(childView)
        
        //CONSTRAINTS SETUP
        self.childView.translatesAutoresizingMaskIntoConstraints = false
        self.leadingChildViewConstraint = self.childView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        self.leadingChildViewConstraint?.isActive = true
        self.topChildViewConstraint = self.childView.topAnchor.constraint(equalTo: self.topAnchor)
        self.topChildViewConstraint?.isActive = true
        self.heightChildViewConstraint = self.childView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        self.heightChildViewConstraint?.isActive = true
        self.widthChildViewConstraint = self.childView.widthAnchor.constraint(equalToConstant: CHILD_VIEW_WIDTH)
        self.widthChildViewConstraint?.isActive = true
        
        // SHOW CHILD VIEW
        self.bringSubviewToFront(self.childView)
        self.layer.insertSublayer(self.childView.layer, above: self.layer.sublayers?.last)
    }
    
    
    func pinBaseView() {
        self.hostingView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingConstraint = self.leadingAnchor.constraint(equalTo: self.hostingView.leadingAnchor)
        self.leadingConstraint?.isActive = true
        self.topAnchor.constraint(equalTo: self.hostingView.topAnchor, constant: HEIGHT).isActive = true
        self.bottomAnchor.constraint(equalTo: self.hostingView.bottomAnchor, constant: -PADDING).isActive = true
        self.widthConstraint = self.widthAnchor.constraint(equalToConstant: HIDING_WIDTH)
        self.widthConstraint?.isActive = true
        self.hostingView.bringSubviewToFront(self)
        self.hostingView.layer.insertSublayer(self.layer, above: self.hostingView.layer.sublayers?.last)
        
    }
    
    
    func place() {
        self.pinBaseView()
        self.pinChildView()
    }
    
    
    @objc func showChildView(/*on parentView: UIView*/) {
        self.leadingChildViewConstraint?.isActive = false
        self.leadingChildViewConstraint = self.childView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        self.leadingChildViewConstraint?.isActive = true
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [.allowUserInteraction, .curveEaseOut], animations: {
            self/*.hostingView*/.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    
    @objc func hideChildView() {
        print("In hideChildView()")
        self.leadingChildViewConstraint?.isActive = false
        self.leadingChildViewConstraint = self.childView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -self.CHILD_VIEW_WIDTH)
        self.leadingChildViewConstraint?.isActive = true
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self/*.hostingView*/.layoutIfNeeded()
        }, completion: nil)
//        self.leadingAnchor.constraint(equalTo: self.hostingView.leadingAnchor, constant: -WIDTH).isActive = true
        
    }
    
    @objc func hide() {
        
//        self.leadingConstraint?.isActive = false
//        self.leadingAnchor.constraint(equalTo: self.hostingView.leadingAnchor, constant: -self.HIDING_WIDTH).isActive = true
        //REPALCED WITH:
        self.changeConstraint(constraint: &(self.widthConstraint)!, newSize: HIDING_WIDTH)
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.hostingView.layoutIfNeeded()
        }, completion: nil)
//        self.leadingAnchor.constraint(equalTo: self.hostingView.leadingAnchor, constant: -WIDTH).isActive = true
        self.hideChildView()
        
        isShowing = false
    }
    
    @objc func show() {
        
        self.changeConstraint(constraint: &(self.widthConstraint)!, newSize: SHOWING_WIDTH)
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.hostingView.layoutIfNeeded()
        }, completion: nil)
        self.showChildView()
        
        isShowing = true
    }
    
    @objc func showOrHide() {
        if (isShowing ?? false) {
            self.hide()
            return
        }
        else {
            self.show()
        }
    }
    
    func showOffBeforeUser() {
        self.place()
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(hideChildView), userInfo: nil, repeats: false)
    }
    
    func changeConstraint(constraint: inout NSLayoutConstraint, newSize: CGFloat) {
        
        constraint.isActive = false
        constraint = self.widthAnchor.constraint(equalToConstant: newSize)
        constraint.isActive = true
    }

}


extension SideMenu: UIGestureRecognizerDelegate {

  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldReceive touch: UITouch) -> Bool {
    debug("TOUCHED SOMETHING")
//    self.showOrHide()
    return (touch.view === self)
  }
}

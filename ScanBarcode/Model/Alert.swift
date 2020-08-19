//
//  Alert.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 6/5/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation
import UIKit

//////////////////////////////////// struct: showAlert ////////////////////////////////
struct Alert {
    
    ///////////////////////// GENERAL ALERT WITH THREE BUTTONS ////////////////////////
    static func alert(on vc: UIViewController? = nil, title: String?=nil, message: String?=nil, accept: String?=nil, skip: String?=nil, cancel: String?=nil, acceptAction: ((UIAlertAction) -> Void )?=nil, skipAction: ((UIAlertAction) -> Void)?=nil, cancelAction: ((UIAlertAction) -> Void)?=nil, style: UIAlertController.Style = .alert) -> Void {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: style)
            if accept != nil {
                alert.addAction(UIAlertAction(title: accept, style: .cancel, handler: acceptAction))
            }
            if skip != nil {
                alert.addAction(UIAlertAction(title: skip, style: .default, handler: skipAction))
            }
            if cancel != nil {
                alert.addAction(UIAlertAction(title: cancel, style: .destructive, handler: cancelAction))
            }
            if let topVC = (vc ?? UIApplication.getTopViewController()) {
                topVC.present(alert, animated: true, completion: nil)
            }
        }
    }
    ///////////////////////////////////////////////////////////////////////////////////
    
    /////////////////////////// FUNCTION TO PRESENT GENERAL ALERT /////////////////////
    static func showAlert(on vc: UIViewController? = nil, withTitle title: String?, message: String?=nil, style: UIAlertController.Style = .alert, buttonText: String? = "OK", buttonStyle: UIAlertAction.Style = .default, completion: ((UIAlertAction)->Void)? = nil) {
        DispatchQueue.main.async {
            /// TRYING TO GET A TOP VIEW CONTROLLER IF NOTHING IS PASSED IN PARAMETER
            var topVC: UIViewController?
            if vc == nil {
                topVC = UIApplication.getTopViewController()
            }
            
            /// CONFIGURING AN ALERT
            let alert = UIAlertController(title: title, message: message, preferredStyle: style)
            alert.addAction(UIAlertAction(title: buttonText, style: buttonStyle, handler: completion))
            
            /// PRESENTING AN ALERT
            topVC?.present(alert, animated: true)
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////
    
    static func duplicateBarcodeAlert(on vc: UIViewController, barcodeText: String, acceptButtonAction: @escaping ((UIAlertAction)->Void), skipButtonAction: @escaping ((UIAlertAction)->Void)) {
        var title = "SAME LABEL?"
        var message = "Or you scanned it again?\n'\(barcodeText)' either has already been scanned or you have duplicate.\n DOUBLE CHECK, PLEASE."
        var leftButtonText = "Skip"
        var rightButtonText = "Rescan"
        Alert.alert(on: vc, title: title, message: message, accept: leftButtonText, skip: rightButtonText, acceptAction: acceptButtonAction, skipAction: skipButtonAction, style: .alert)
    }
    
    
    static func didYouFinishScanningAlert(on vc: UIViewController,  acceptAction: @escaping ((UIAlertAction)->Void), skipAction: @escaping ((UIAlertAction)->Void)) {
        var title = "Did you finish scanning?"
//        var message = "Did you finish previous transaction?"
        var leftButtonText = "YES"
        var rightButtonText = "NO"
        Alert.alert(on: vc, title: title, accept: leftButtonText, skip: rightButtonText, acceptAction: acceptAction, skipAction: skipAction, style: .alert)
    }
    
    static func didFinishTransactionAlert(on vc: UIViewController,  acceptAction: @escaping ((UIAlertAction)->Void), skipAction: @escaping ((UIAlertAction)->Void)) {
        var title = "DID YOU COMPLETE THIS TRANSACTION?"
        var message = "Did you finish transaction? Do You begin new transaction?"
        var leftButtonText = "YES"
        var rightButtonText = "NO"
        Alert.alert(on: vc, title: title, accept: leftButtonText, skip: rightButtonText, acceptAction: acceptAction, skipAction: skipAction, style: .alert)
    }
    
    //////////////////////////////// EXIT ALERT ////////////////////////////////////////
    static func showExitAlert(on vc: UIViewController?=nil, withTitle title: String = "Exiting the app", message: String, buttonText: String? = "Exit", completion: ((UIAlertAction)->Void)? = { _ in exit(0) }) {
        
        self.showAlert(on: vc, withTitle: title, message: message, buttonText: buttonText, completion: completion)
    }
    ////////////////////////////////////////////////////////////////////////////////////
    
    /////////////////////////// SERVER CONNECTION ERROR ALERT //////////////////////////
    static func showAlertForServerConnectionError(on vc: UIViewController, withTitle title: String =  "SERVER CONNECTION ERROR", message: String = "Could not connect to server.", buttonText: String? = "OK", buttonStyle: UIAlertAction.Style = .destructive, completion: ((UIAlertAction)->Void)? = nil) {
    
        self.showAlert(on: vc, withTitle: title, message: message, buttonText: buttonText, buttonStyle: buttonStyle, completion: completion)
    }
    ////////////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////// SERVER ERROR AFTER RETRIES ALERT ////////////////////////
    static func showAlertForServerErrorAfterConnectionRetries(on vc: UIViewController?=nil, buttonText: String?="OK", buttonStyle: UIAlertAction.Style = .cancel, completion: ((UIAlertAction)->Void)? = nil) {
    
        self.showAlert(on: vc, withTitle: "SERVER CONNECTION ERROR", message: "Could not connect to your register.", buttonText: buttonText, buttonStyle: buttonStyle, completion: completion)
    }
    ///////////////////////////////////////////////////////////////////////////////////
    
    static func showBarcodesSentAlert() {
        self.showAlert(withTitle: "Barcodes Sent", buttonText: "OK", buttonStyle: .default)
    }
}
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

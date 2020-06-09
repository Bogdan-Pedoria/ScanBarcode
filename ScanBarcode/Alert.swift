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
    static func alert(title: String?=nil, message: String?=nil, accept: String?=nil, skip: String?=nil, cancel: String?=nil, acceptAction: ((UIAlertAction) -> Void )?=nil, skipAction: ((UIAlertAction) -> Void)?=nil, cancelAction: ((UIAlertAction) -> Void)?=nil) -> Void {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if accept != nil {
            alert.addAction(UIAlertAction(title: accept, style: .cancel, handler: acceptAction))
        }
        if skip != nil {
            alert.addAction(UIAlertAction(title: skip, style: .default, handler: skipAction))
        }
        if cancel != nil {
            alert.addAction(UIAlertAction(title: cancel, style: .destructive, handler: cancelAction))
        }
        UIApplication.getTopViewController()?.present(alert, animated: true, completion: nil)
    }
    ///////////////////////////////////////////////////////////////////////////////////
    
    /////////////////////////// FUNCTION TO PRESENT GENERAL ALERT /////////////////////
    static func showAlert(on vc: UIViewController? = nil, withTitle title: String?, message: String?, style: UIAlertController.Style = .alert, buttonText: String? = "OK", buttonStyle: UIAlertAction.Style = .default, completion: ((UIAlertAction)->Void)? = nil) {
        
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
    ////////////////////////////////////////////////////////////////////////////////////
    
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
    static func showAlertForServerErrorAfterConnectionRetries(on vc: UIViewController?=nil, buttonText: String?="OK", buttonStyle: UIAlertAction.Style = .destructive, completion: ((UIAlertAction)->Void)? = nil) {
    
        self.showAlert(on: vc, withTitle: "SERVER CONNECTION ERROR", message: "Could not connect to your register after multiple retries.", buttonText: buttonText, buttonStyle: buttonStyle, completion: completion)
    }
    ///////////////////////////////////////////////////////////////////////////////////
}
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

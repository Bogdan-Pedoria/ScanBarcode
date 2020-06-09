//
//  UIApplicationExtension.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 6/5/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation
import UIKit
//////////////////////////////////////////////////////////////////////////////////////
////////////////////////// UIAPPLICATION EXTENSION //////////////////////////////////
/*
    UIApplication extension to get the top ViewController
 */
extension UIApplication {
    
    class func getTopViewController(viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = viewController as? UINavigationController {
            return getTopViewController(viewController: nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopViewController(viewController: selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return getTopViewController(viewController: presented)
        }
        return viewController
    }
}
//////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

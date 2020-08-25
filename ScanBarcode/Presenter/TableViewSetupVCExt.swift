//
//  TableViewSetupVCExt.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 6/1/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    ////////////////////////////// TABLE VIEW CONFIGURATION ////////////////////////////////////////
    func configureTableView() {
        self.view.addSubview(tableView)
        self.tableView.delegate         = self
        self.tableView.dataSource       = self
        self.tableView.rowHeight        = 50
        self.tableView.backgroundColor  = .clear
        if self.singleScanMode {
            self.tableView.tableFooterView  = UIView()
        }
        self.tableView.register(BarcodeTableViewCell.self, forCellReuseIdentifier: cells.barcodeCell.rawValue)
    }
    //////////////////////////////////////////////////////////////////////////////////////////////
    
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func pinTableView(y: CGFloat, height: CGFloat, bottomOffset: Int?=nil) {
//        guard let lastView = self.view.subviews.last else {return}
//        self.tableView.pin(to: lastView)
        let screen = UIScreen.main.bounds
        self.tableView.frame = CGRect(x: screen.origin.x, y: y, width: screen.width, height: height)
//        self.tableView.pin(to: self.view, y: y, bottomOffset: bottomOffset)
        self.view.addSubview(tableView)
        self.view.bringSubviewToFront(tableView)
        //tableView.superview?.bringSubviewToFront(tableView)
    }
    
    func setupSingleBarcodeDetectionModeView() {
        
        self.singleScanMode = true
        let screen = UIScreen.main.bounds
        self.tableView.backgroundColor = .init(white: .init(0.5), alpha: 0.3)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
//            self?.tableView.removeAllConstraints()
            self?.pinTableView(y: CGFloat(exactly: (self?.tableViewSingleScanModeHeight)!)!, height: screen.height - CGFloat(exactly: (self?.tableViewSingleScanModeHeight)!)!, bottomOffset: 0)
            self?.setupSendButton(x: Int((self?.counterButtonWidth)!), y: (self?.tableViewSingleScanModeHeight)! - Int((self?.sendButton.bounds.height)!))
            self?.setupCounterButton(x: 0, y: (self?.tableViewSingleScanModeHeight)! -  Int((self?.buttonsHeight)!))
            self?.setupScanButton(x: (self?.counterButtonWidth)!, y: (self?.tableViewSingleScanModeHeight)! - Int((self?.buttonsHeight)!), width: Int(screen.width) - (self?.counterButtonWidth)!)
        }, completion: nil)
        
//        self.drawActualScanningArea()
        self.drawSingeScanModeBorder()
//        self.bringButtonsToFront()
        self.updateCounterButton()
        self.reloadTableView()

        // FRAME POOR ALTERNATIVE
        //            self.tableView.pin(to: self.view, y: tableViewInitialHeight)// IF SOMETHING IS NOT WORKING ON DIFFERENT SCREEN ON EVEN TAPS WHEN THIS CONDITION EXECUTES, QUICK FIX IS TO PIN A VIEW. IN GENERAL I HAVE TO REMAKE IT TO USE ANCHORS IN STEAD OF CURRENT pin(), WHICH USES CONSTRAINTS.
//                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
//                        self?.tableView.frame = CGRect(x: 0, y: self!.tableViewInitialHeight, width: Int(screen.width), height: Int(screen.height) - self!.tableViewInitialHeight)
//
//                        // MOVING CounterButton
//                        self?.setupCounterButton(x: Int(screen.origin.x), y: Int(screen.origin.y) + 350)
//
//                        // MOVING sendButton
//                        self?.setupSendButton(x: Int(screen.width) - 100, y: Int(screen.origin.y) + 350)
//                    }, completion: nil)
    }
    
    /*
        Mode of view which will be used to by supervisors to scan many barcodes from the entire screen, not one by one
     */
    func setupFullScreenDetectionModeView() {
        
        self.singleScanMode = false
        let screen = UIScreen.main.bounds
        self.tableView.removeAllConstraints()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            
//            if let y = self?.tableViewExpandHeight {
//                self?.pinTableView(y: y, bottomOffset: -(self?.buttonsHeight)!)
//            }
//            else {
//                self?.pinTableView(y: 0, bottomOffset: -(self?.buttonsHeight)!)
//            }
            self?.tableView.backgroundColor = .clear
            self?.tableView.tableFooterView = UIView()
            self?.removeScanBorder()
            self?.pinTableView(y: CGFloat(exactly: (self?.tableViewFullScreenScanModeHeight)!)!, height: screen.height - CGFloat((self?.buttonsHeight)! + 15)/*, bottomOffset: -(self?.buttonsHeight)!*/)
            self?.setupSendButton(x: Int((self?.tableView.bounds.width)!) - (self?.sendButtonWidth)!, y: Int(screen.height) - (self?.buttonsHeight)!) //50 height of the button
            self?.setupCounterButton(x: 0, y: Int(screen.height) - (self?.buttonsHeight)!)
            self?.setupScanButton(x: (self?.counterButtonWidth)!, y: Int(screen.height) - (self?.buttonsHeight)!, width: Int((self?.scanButtonWidth)!))
            
        }, completion: nil)
        self.updateCounterButton()
        self.reloadTableView()
// FRAME ALTERNATIVE
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
//            self?.tableView.frame = CGRect(x: 0, y: self!.tableViewExpandHeight, width: Int(screen.width), height: Int(screen.height) - (Int((self?.sendButton.bounds.height)!) + self!.tableViewExpandHeight))
////            self.tableView.pin(to: self.view, y: Int(tableViewExpandHeight))
//
//            // MOVING CounterButton
////            setupCounterButton(x: Int(screen.origin.x), y: Int(screen.origin.y) + 15)
//            self?.setupCounterButton(x: Int(screen.origin.x), y: Int(screen.height) - Int((self?.sendButton.bounds.height)!))
//
//            // MOVING sendButton
//            self?.setupSendButton(x: Int(screen.width) - 100, y: Int(screen.height) - Int((self?.sendButton.bounds.height)!))
//        }, completion: nil)
    }
}

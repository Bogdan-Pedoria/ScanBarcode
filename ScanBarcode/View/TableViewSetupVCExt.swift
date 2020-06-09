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
    
    func configureTableView() {
        self.view.addSubview(tableView)
        self.tableView.delegate         = self
        self.tableView.dataSource       = self
        self.tableView.rowHeight        = 50
        self.tableView.register(BarcodeTableViewCell.self, forCellReuseIdentifier: cells.barcodeCell.rawValue)
        self.tableView.backgroundColor  = .clear
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func pinTableView(y: Int, bottomOffset: Int) {
//        guard let lastView = self.view.subviews.last else {return}
//        self.tableView.pin(to: lastView)
        let screen = UIScreen.main.bounds
        self.tableView.frame = CGRect(x: screen.origin.x, y: screen.origin.y, width: screen.width, height: screen.height)
        self.tableView.pin(to: self.view, y: y, bottomOffset: bottomOffset)
        self.view.addSubview(tableView)
        self.view.bringSubviewToFront(tableView)
        //tableView.superview?.bringSubviewToFront(tableView)
    }
    
    func setupSingleBarcodeDetectionModeView() {
        
        let screen = UIScreen.main.bounds
        
        self.tableView.removeAllConstraints()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            if let y = self?.tableViewInitialHeight {
                self?.pinTableView(y: y, bottomOffset: 0)
            }
            else {
                self?.pinTableView(y: 400, bottomOffset: 0)
            }
                self?.setupSendButton(x: Int((self?.tableView.bounds.width)!) - 100, y: 350)
                self?.setupCounterButton(x: Int((self?.tableView.bounds.origin.x)!), y: 350)
        }, completion: nil)

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
        
        let screen = UIScreen.main.bounds
        
        self.tableView.removeAllConstraints()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            
            if let y = self?.tableViewExpandHeight {
                self?.pinTableView(y: y, bottomOffset: -(self?.buttonsHeight)!)
            }
            else {
                self?.pinTableView(y: 0, bottomOffset: -(self?.buttonsHeight)!)
            }
            self?.setupSendButton(x: Int((self?.tableView.bounds.width)!) - 100, y: Int(screen.height) - (self?.buttonsHeight)!) //50 height of the button
            self?.setupCounterButton(x: Int((self?.tableView.bounds.origin.x)!), y: Int(screen.height) - (self?.buttonsHeight)!) //50 height of the sendbutton
            
        }, completion: nil)

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

//
//  ButtonSetup.swift
//  ScanBarcode
//
//  Created by Bohdan Pedoria on 6/3/20.
//  Copyright © 2020 Bohdan Pedoria. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    

    // TODO: EVERYTHING IS WRONG, USE ANCHORS OR CONSTARINTS (UIVIEWAUTOLAYOUT), NOT FRAMES
    func setupStartStopButton(x: Int, y: Int) {
        self.startStopButton.frame = CGRect(x: x, y: y, width: 100, height: 50)
//        sendButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 10).isActive = true
        self.startStopButton.layer.cornerRadius = 10
        self.startStopButton.clipsToBounds = true
//        sendButton.setImage(UIImage(named: "NAME"), for: .normal)
        self.startStopButton.addTarget(self, action: #selector(startScanning), for: .touchDown)
        self.startStopButton.addTarget(self, action: #selector(stopScanning), for: .touchUpInside)
        self.startStopButton.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.7)
        self.startStopButton.setTitleColor(.black, for: .normal)
        self.startStopButton.setTitle("HOLD", for: .normal)
        self.view.addSubview(startStopButton)
        self.view.bringSubviewToFront(startStopButton)
    }
    
    
//    @objc func startStopButtonTapped() {
//
//        print("StartStopBtnTapped")
//
//        if self.isScanning {
//            self.isScanning = false
////            self.stopCamera()
//            self.startStopButton.setTitle("START", for: .normal)
//            self.startStopButton.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.7)
//        }
//        else if !self.isScanning {
//            self.isScanning = true
////            self.startCamera()
//            self.startStopButton.setTitle("STOP", for: .normal)
//            self.startStopButton.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.7)
////            self.startStopButton.setTitleColor(.white, for: .normal)
//        }
//    }

    
    // EVERYTHING IS WRONG, USE ANCHORS OR CONSTARINTS (UIVIEWAUTOLAYOUT), NOT FRAMES
    func setupSendButton(x: Int, y: Int) {
        sendButton.frame = CGRect(x: x, y: y, width: 100, height: 50)
//        sendButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 10).isActive = true
        sendButton.layer.cornerRadius = 10
        sendButton.clipsToBounds = true
//        sendButton.setImage(UIImage(named: "NAME"), for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        sendButton.backgroundColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7)
        sendButton.setTitle("SEND", for: .normal)
        self.view.addSubview(sendButton)
        self.view.bringSubviewToFront(sendButton)
    }
    
    
    @objc func sendButtonTapped() {
        
        print("Send BUtton Tapped")
        guard let connection = socketClient.connectionIsEstablished, connection else { return }
        guard MLBarcodes.count != 0 else { return }
        
        // TODO: REMOVE DO CATCH OR ALERT BECAUSE IF JSONEncoder FAILS IT MEANS IT IS THE CODE IS WRONG. OTHERWISE IT WONT HAPPEN.
        do {
            let encodedBarcodes = try JSONEncoder().encode(MLBarcodes)
            socketClient.sendData(encodedBarcodes)
        }
        catch {
            Alert.showAlert(withTitle: "ERROR", message: "COULD NOT ENCODE BARCODE DATA")
            print(error.localizedDescription)
            return
        }
        
        /// STOPPING SCANNER
        if self.isScanning {
            self.startStopButton.sendActions(for: .touchUpInside)
        }
        /// UPDATING TABLE VIEW
        MLBarcodes.removeAll()
        updateCounterButton(number: MLBarcodes.count)
        self.tableView.reloadData()
        
        /// SHOWING BARCODES SENT ALERT
        DispatchQueue.global(qos: .background).async {
            Alert.showBarcodesSentAlert()
        }
        
    }
    
    
    // EVERYTHING IS WRONG, USE ANCHORS OR CONSTARINTS (UIVIEWAUTOLAYOUT), NOT FRAMES
    func setupCounterButton(x: Int=0, y: Int=0) {
        
//        counterButton.frame = CGRect(x: 0, y: 350, width: 50, height: 50)
        counterButton.frame = CGRect(x: x, y: y, width: 50, height: 50)
        counterButton.layer.cornerRadius = 0.5 * counterButton.bounds.size.width
        counterButton.clipsToBounds = true
        counterButton.addTarget(self, action: #selector(counterButtonTapped), for: .touchUpInside)
        counterButton.backgroundColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7)
        counterButton.setTitle(String(MLBarcodes.count), for: .normal)
        counterButton.setTitleColor(.red, for: .normal)
        self.view.addSubview(counterButton)
        self.view.bringSubviewToFront(counterButton)
    }
    
    
    func updateCounterButton(number: Int) {
        let stringNumber = String(number)
        counterButton.setTitle(stringNumber, for: .normal)
    }
    
    
    /*
     FUNCTION TO LIFT UP TABLE VIEW TO THE TOP OF THE SCREEN
     */
    @objc func counterButtonTapped() {
        
        print("CounterButton tapped")
        
        if self.tableView.frame.origin.y == CGFloat(tableViewSingleScanModeHeight) {
            self.setupFullScreenDetectionModeView()
        }
            
        // EVEN TAPS OF THE BUTTON TO FOLD TABLEVIEW DOWN, BACK TO INITIAL POSITION
        else if self.tableView.frame.origin.y == CGFloat(tableViewFullScreenScanModeHeight) {
            
            self.setupSingleBarcodeDetectionModeView()

        }
        
    }
}

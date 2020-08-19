//
//  SocketServer.swift
//  Restaurant
//
//  Created by Bohdan Pedoria on 1/24/19.
//  Copyright © 2019 Bohdan Pedoria. All rights reserved.
//


import Foundation
import UIKit

class SocketClient: NSObject, StreamDelegate{
    private var inputStream: InputStream!
    private var outputStream: OutputStream!
    var MAX_READ_LENGTH = 2048
    var PORT = 8018
    var IP = "192.168.137.1"
    private var reconnect_tries = 1 // CHANGE TO FIVE
    private var lastSentData: Data?
    var connectionIsEstablished: Bool?
    
    init(ip: String?=nil) {
//        self.ip = ip
//        self.ip = self.ip
    }
    
//    init(ip: String, port: Int, maxReadLength: Int, appName: String){
//        self.ip = ip
//        self.port = port
//        self.maxReadLength = maxReadLength
//        self.appName = appName
//        self.socketURL = URL(string: "\(ip):\(port)")!
//        print("DEBUG: SOCKET url = \(self.socketURL)")
//        debug(String(describing: socketURL))
//    }
    
    func setupNetworkCommunication() {
        // 1
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        // 2
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           IP as CFString,
                                           UInt32(PORT),
                                           &readStream,
                                           &writeStream)
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.delegate = self
        
        inputStream.schedule(in: .current, forMode: .common)
        outputStream.schedule(in: .current, forMode: .common)
        inputStream.open()
        outputStream.open()
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.hasBytesAvailable:
            print("new message received")
            readAvailableBytes(inputStream: aStream as! InputStream)
        case Stream.Event.endEncountered:
            print("new message received")
        case Stream.Event.errorOccurred:
            print("\nCONNECTION ERROR OCCURED\n PROBABLY SERVER IS DOWN")
            self.tryToReconnect()
        case Stream.Event.hasSpaceAvailable:
            print("has space available")
        default:
            print("CONNECTION IS ESTABLISHED")
            self.connectionIsEstablished = true
            self.reconnect_tries = 1
            break
        }
    }
    
    private func readAvailableBytes(inputStream: InputStream) {
        //1
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: MAX_READ_LENGTH)
        //2
        while inputStream.hasBytesAvailable {
            //3
            let numberOfBytesRead = inputStream.read(buffer, maxLength: MAX_READ_LENGTH)
            
            //4
            if numberOfBytesRead < 0 {
                if let _ = inputStream.streamError {
                    break
                }
            }
            
            //Construct the Message object
            guard let stringArray = String(bytesNoCopy: buffer,
                                           length: numberOfBytesRead,
                                           encoding: .utf8,
                                           freeWhenDone: true)?.components(separatedBy: "&")
                else {
                    break
            }
            
//remove
print("\nstringArray = \(stringArray[0])")
            
            // 503 service unavailable
            // The server cannot handle the request (because it is overloaded or down for maintenance) (Wikipedia)
            if stringArray[0] == "503" { // LENGTH OF DATA GOT MESSED UP and got decoded as MORE THAN 9.99 MB
                Alert.showAlert(withTitle: "DATA DID NOT SEND", message: "Internal Server Error. Try rescanning")
                self.tryToReconnect()
            }
            
            // 500 Internal Server Error
            //A generic error message, given when an unexpected condition was encountered and no more specific message is suitable (WIKIPEDIA)
            if stringArray[0] == "500" { //SERVER COULD NOT DECODE JSON
                // TODO: REVIEW AND ADD TRY CATCH OR THROW ERROR OR MAKE SERVER SENT BETTER ERROR MESSAGES OR DO ANYTHING TO MAKE IT BETTER
                // RESEND ON YOUR OWN -- BECAUSE IT HAPPENS SOMETIMES, AND AFTER RESENDING, ASK USER TO RESAND OR RESCAN
                if let sentData = lastSentData {
                    self.sendData(sentData)
                    lastSentData = nil
                }
                else {
                    //TODO: SHOW ALERT -- update Alert to have relative to this case alert
                    Alert.showAlert(withTitle: "DATA DID NOT SEND", message: "Try rescanning")
                }
            }
        }
    }
  
    func sendData(_ data: Data) {
        
        lastSentData = data
        ///////////// SENDING  WITH LENGTH /////////////
        ////////////////////
print("DEBUG: SENDING SIZE.\nDEBUG: in Socket.sendData(): data weight = \(data.count)\n data = \(data)")
        /////////////////////
        let dataSize: Int = data.count
        var size = withUnsafeBytes(of: dataSize.bigEndian, Array.init)//MAC AND WINDOWS HAS LITTLE ENDIAN. JUST NOTICE. SENDING AND RECEIVING BIG ENDIAN JUST BECAUSE.
        let Size = Data(bytes: &size, count: MemoryLayout.size(ofValue: dataSize))

        let lengthDataArray = [UInt8](Size)
//        outputStream.write(lengthDataArray, maxLength: lengthDataArray.count)

        let dataArray = [UInt8](data)
        let altogether = lengthDataArray + dataArray
//        outputStream.write(altogether, maxLength: dataArray.count) //SUCH A COVARD ERROR. LEFT FOR MEMORY.
        outputStream.write(altogether, maxLength: altogether.count)

        //SIMPLE WAY no length is being sent -- unreliable
//        let dataArray = [UInt8](data)
//        outputStream.write(dataArray, maxLength: dataArray.count)
    }
    
    
    func closeSocket() {
        let closingKey = "\0\0\0\0".data(using: .utf8)!
        self.sendData(closingKey)
        inputStream.close()
        outputStream.close()
        inputStream.remove(from: .current, forMode: .common)
        outputStream.remove(from: .current, forMode: .common)
        if !((outputStream?.streamStatus) != nil) && !((inputStream?.streamStatus) != nil) {

print("DEBUG: outputStream \(outputStream?.streamStatus),\n inputStream \(inputStream?.streamStatus)")
        }
print("DEBUG: outputStream \(outputStream?.streamStatus.rawValue),\n inputStream \(inputStream?.streamStatus.rawValue)")
    }
    
    func tryToReconnect() {
        
        self.connectionIsEstablished = false
        if self.reconnect_tries > 0 {
            print("TRYING TO RECONNECT...")
            print("Reconnect tries left: \(socketClient.reconnect_tries)\n")
            self.closeSocket()
            self.setupNetworkCommunication()
            self.reconnect_tries -= 1
        }
        else {
//            shutAppDown(reason: ShutDownReason.serverErrorAfterConnectionRetries)
            Alert.alert(title: "Connection Error", message: "Could Not Connect To Your Register", accept: "Retry", cancel: "EXIT") { [weak self](UIAlertAction) in
                self?.reconnect_tries = 1
                self?.tryToReconnect()
            } cancelAction: { (UIAlertAction) in
                exit(SYS_exit)
            }

        }
    }
}



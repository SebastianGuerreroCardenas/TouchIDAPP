//
//  SocketIOManager.swift
//  URLAdding
//
//  Created by Sebastian Guerrero on 11/22/16.
//  Copyright © 2016 Sebastian Guerrero. All rights reserved.
//

import UIKit
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    var socket = SocketIOClient(socketURL: URL(string: "https://your-ngrok-url.ngrok.io")!, config: [.log(false), .forcePolling(true)])
    
    override init() {
        super.init()
        
        socket.on("test") { dataArray, ack in
            print(dataArray)
        }
        
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func changeClient(url: String) -> Bool {
        closeConnection()
        socket = SocketIOClient(socketURL: URL(string: url)!, config: [.log(false), .forcePolling(true)])
        return true
    }
    
    //It should url, username, token, (locaiton)
    func startHandshake(parameters: [String: AnyObject]) -> Bool {
        socket.emit("handshake", parameters)
        return true
    }
    
    func handShakeResponse() -> Bool {
        socket.on("handShake") {data, ack in
            print(data)
        }
        return true
    }
    
    func login(parameters: [String: AnyObject]) -> Bool {
        socket.emit("login", parameters)
        return true
    }
    
    func loginResponse() -> Bool {
        socket.on("login") {data, ack in
            print(data)
        }
        return true
    }
    
    
    
}

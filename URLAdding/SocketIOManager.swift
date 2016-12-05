//
//  SocketIOManager.swift
//  URLAdding
//
//  Created by Sebastian Guerrero on 11/22/16.
//  Copyright © 2016 Sebastian Guerrero. All rights reserved.
//

import UIKit
import SocketIO

let serverPath = "http://127.0.0.1:8080/"

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    let saltHash = saltHashManager()
    
    var socket = SocketIOClient(socketURL: URL(string: serverPath)!, config: [.log(false), .forcePolling(true)])
    override init() {
        super.init()
//        socket.connect()
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
//        socket.connect()
        return true
    }
    
    //It should url, username, token, (locaiton)
    /**
     Pings the server to start the handshake
     - parameter parameters: List of credentials to establish handshake
    */
    func startHandshake(parameters: [String: AnyObject]) -> Bool {
        socket.emit("init_connect", parameters)//parameters)
        return true
    }
    
    /**
    Provides the handlers the socket should be acting upon
     - parameter inst: The instance of the SocketConnectionViewController so we know how to move next in certain cases
    */
    func loadHandlers(inst: SocketConnectionViewController) -> Bool {
        //Running handlers method allows these to be stored in socket
        socket.on("handShake") {data, ack in
            print("Here")
            print(data)
        }
        
        socket.on("init_token") {data, ack in
            print("Here")
            print(data)
            inst.handleHandshake(data: data)
        }
        
        socket.on("connection") {data, ack in
            print(data)
            print("WOOOOOO")
        }
        
        socket.on("login") {data, ack in
            print(data)
        }
        
        self.socket.onAny {
            print("Got event: \($0.event), with items: \($0.items!)")
        }
        return true
    }
    
    func loadLoginHandlers(inst: LoginViewController) -> Bool {
        socket.on("connect") {data, ack in
            print(data)
            print("WOOOOOO")
            inst.handleConnection()
        }
        
        socket.on("backFromLogin") {data, ack in
            print(data)
            inst.transitionBackToMenu()
        }
        
        socket.on("login") {data, ack in
            print(data)
        }
        
        socket.on("loginRN") {data, ack in
            print(data)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.loginHash(parameters: appDelegate.credentials, randomElt: data[0] as! String)
        }
        
        socket.on("loginResult"){ data, ack in
            print("loginResult")
            print(data)
            inst.handleLoginResult(result: data[0] as! String)
        }
        
        self.socket.onAny {
            print("Got event: \($0.event), with items: \($0.items!)")
        }
        return true
    }
    
    /**
     Pings the server to perform a login
     - parameter parameters: The user's credentials to sign in
    */
    func loginHash(parameters: [String: Any], randomElt: String) -> Bool {

        //parameters["hash"] = "16" //actually this is the hashed value
        var newParams: [String : Any] = parameters
        newParams["hash"] = self.saltHash.createHash(handshakeString: "taco", rngString: randomElt)
        socket.emit("loginHash", newParams)
        return true
    }
    
    func startLogin(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        socket.emit("startLogin", appDelegate.credentials)
    }
    
//  Below function deprecated to be moved to above
//    func loginResponse() -> Bool {
//        
//        return true
//    }
    
    
    
    
    
}

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
    //Create instances of the Socket Manager and HashManager classes
    static let sharedInstance = SocketIOManager()
    let saltHash = saltHashManager()
    
    //Open an initial socket
    var socket = SocketIOClient(socketURL: URL(string: serverPath)!, config: [.log(false), .forcePolling(true)])
    override init() {
        super.init()
        //Testing connection
        socket.on("test") { dataArray, ack in
            print(dataArray)
        }
        
    }
    
    //Establish a connection to the defined socket
    func establishConnection() {
        socket.connect()
    }
    
    //Close the connection to the defined socket
    func closeConnection() {
        socket.disconnect()
    }
    
    //Change the managed socket to a new URL
    func changeClient(url: String) -> Bool {
        closeConnection()
        socket = SocketIOClient(socketURL: URL(string: url)!, config: [.log(false), .forcePolling(true)])
        return true
    }
    
    //It should url, username, token, (locaiton)
    /**
     Pings the server to start the handshake
     - parameter parameters: List of credentials to establish handshake
    */
    func startHandshake(parameters: [String: AnyObject]) -> Bool {
        socket.emit("init_connect", parameters["username"] as! SocketData)//parameters)
        return true
    }
    
    /**
    Provides the handlers the socket should be acting upon
     - parameter inst: The instance of the SocketConnectionViewController so we know how to move next in certain cases
    */
    func loadHandlers(inst: SocketConnectionViewController) -> Bool {
        //Running handlers method allows these to be stored in socket
        socket.on("handShake") {data, ack in
            print(data)
        }
        
        //Handle the initial handshake coming back from the server
        socket.on("init_token") {data, ack in
            print(data)
            inst.handleHandshake(data: data)
        }
        
        socket.on("connection") {data, ack in
            print(data)
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
        //Handle a connection coming back from the server
        socket.on("connect") {data, ack in
            print(data)
            inst.handleConnection()
        }
        
        //Handle a successful connection from the server
        socket.on("backFromLogin") {data, ack in
            print(data)
            inst.transitionBackToMenu()
        }
        
        socket.on("login") {data, ack in
            print(data)
        }
        
        //Send a salted hash code over when requested
        socket.on("loginRN") {data, ack in
            print(data)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.loginHash(parameters: appDelegate.credentials, randomElt: data[0] as! String)
        }
        
        //Handle the result of the login check from the server
        socket.on("loginResult"){ data, ack in
            print(data)
            inst.handleLoginResult(result: data[0] as! String)
        }
        
        self.socket.onAny {
            print("Got event: \($0.event), with items: \($0.items!)")
        }
        return true
    }
    
    /**
     Pings the server to perform a login after creating a hashed value of the credentials
     - parameter parameters: The user's credentials to sign in
    */
    func loginHash(parameters: [String: Any], randomElt: String) -> Bool {

        var newParams: [String : Any] = parameters
        //Hash created below
        newParams["hash"] = self.saltHash.createHash(handshakeString: newParams["token"] as! String, rngString: randomElt)
        //Emit hash on server
        socket.emit("loginHash", newParams)
        return true
    }
    
    /**
     Begins the login procedure by emitting socket to server connection
    */
    func startLogin(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        socket.emit("startLogin", appDelegate.credentials)
    }
    
    
    
    
    
}

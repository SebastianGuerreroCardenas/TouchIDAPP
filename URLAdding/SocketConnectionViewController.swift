//
//  SocketConnectionViewController.swift
//  URLAdding
//
//  Created by Jordan Stapinski on 11/28/16.
//  Copyright © 2016 Sebastian Guerrero. All rights reserved.
//

import UIKit

class SocketConnectionViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let IOManager = SocketIOManager.sharedInstance
    var url: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.url == "" {
            print("Empty URL")
            return
        }
        /**
         1. Overwrite Socket to be the new connection
         2. Try to establish connection
         3. Load things to listen to
         4. Send out verification
        */
        // Do any additional setup after loading the view.
        let didOverwrite = self.overwriteSocket()
        //self.newSocketConnection() taken care of in overwriteSocket
        if didOverwrite {
            self.IOManager.establishConnection()
            self.loadHandlers()
            print("Loaded Handlers")
        } else {
            print("Could not connect to new url: \(self.url)")
        }
    }
    
    func overwriteSocket() -> Bool{
        let result = self.IOManager.changeClient(url: self.url)
        //self.IOManager.establishConnection()
        if result {
            print("Able to change client successfully")
        } else {
            print("Failed to change client")
        }
        return result
    }
    
    func loadHandlers(){
        IOManager.handShakeResponse()
    }
    
    @IBAction func sendVerification(sender: AnyObject){
        //Cannot connect back
        //IOManager.establishConnection()
        IOManager.startHandshake(parameters: [:])
        print("Seding out handshake, see server output")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

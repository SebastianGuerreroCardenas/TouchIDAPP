//
//  LoginViewController.swift
//  URLAdding
//
//  Created by Jordan Stapinski on 12/3/16.
//  Copyright © 2016 Sebastian Guerrero. All rights reserved.
//

import UIKit
import RNCryptor

class LoginViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let IOManager = SocketIOManager.sharedInstance
    var url: String = ""
    var name: String = ""
    var username: String = ""
    var token: String = ""
    
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo.png")
        imageView.image = image
        navigationItem.titleView = imageView
        
        //Set display text as needed
        self.urlLabel.text = self.url
        self.usernameLabel.text = self.username
        //Try logging in
        self.sendLoginAttempt()
    }
    
    /**
     Prepares new socket connection for login and loads handlers
    */
    func sendLoginAttempt(){
        //Close the current connection
        self.IOManager.closeConnection()
        //Open a new connection to the new URL
        self.overwriteSocket()
        //Load login actions
        IOManager.loadLoginHandlers(inst: self)
     }
    
    /**
     Callback called after it receives something on the connect message from the server
    */
    func handleConnection(){
        var params: [String : String] = [:]
        params["name"] = self.name
        params["username"] = self.username
        params["token"] = self.token
        //Get params and start logging in
        IOManager.startLogin()
    }
    
    func transitionBackToMenu(){
        performSegue(withIdentifier: "loginConfirm", sender: "")
    }
    
    func transitionToFailed(){
        performSegue(withIdentifier: "failedLogin", sender: "")
    }
    
    func handleLoginResult(result: String){
        print(result)
        if (result == "True"){
            //Successful login
            transitionBackToMenu()
        } else {
            //Login failed
            transitionToFailed()
        }
    }
    
    //Change socket connection
    func overwriteSocket() -> Bool{
        //Need to make sure self.url is of form http:\\url\
        let result = self.IOManager.changeClient(url: self.url)
        if result {
            self.IOManager.establishConnection()
            print("Able to change client successfully")
        } else {
            print("Failed to change client")
        }
        return result
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "loginConfirm"){
            let finalDestination = segue.destination as? LoginConfirmationViewController
            finalDestination?.url = self.url
            finalDestination?.username = self.username
        }
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

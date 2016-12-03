//
//  LoginViewController.swift
//  URLAdding
//
//  Created by Jordan Stapinski on 12/3/16.
//  Copyright © 2016 Sebastian Guerrero. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let IOManager = SocketIOManager.sharedInstance
    var url: String = ""
    var name: String = ""
    var username: String = ""
    
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        // 4
        let image = UIImage(named: "logo.png")
        imageView.image = image
        // 5
        navigationItem.titleView = imageView

        self.urlLabel.text = self.url
        self.usernameLabel.text = self.username
        self.sendLoginAttempt()
        // Do any additional setup after loading the view.
    }
    
    /**
     Prepares new socket connection for login and loads handlers
    */
    func sendLoginAttempt(){
        self.IOManager.closeConnection()
        self.overwriteSocket()
        IOManager.loadLoginHandlers(inst: self)
    }
    
    /**
     Callback called after it receives something on the connect message from the server
    */
    func handleConnection(){
        var params: [String : String] = [:]
        params["name"] = self.name
        params["username"] = self.username
        IOManager.login(parameters: params)
    }
    
    func transitionBackToMenu(){
        sleep(1)
        performSegue(withIdentifier: "loginConfirm", sender: "")
    }
    
    func overwriteSocket() -> Bool{
        //Need to make sure self.url is of form http:\\url\
        let result = self.IOManager.changeClient(url: self.url)
        //self.IOManager.establishConnection()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

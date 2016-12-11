//
//  ViewController.swift
//  URLAdding
//
//  Created by Sebastian Guerrero on 10/25/16.
//  Copyright © 2016 Sebastian Guerrero. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    //NOTE: Most of this code has been moved into FristViewController.swift, we updated it so the user does not have to access this page to improve usability. We kept it anyway.
    
    var url = ""
    var name = ""
    var username = ""
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    //Load the salt hash manager
    let shm = saltHashManager()
    
    // Set up view display
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo.png")
        imageView.image = image
        navigationItem.titleView = imageView
        titleLabel.text = url
        nameLabel.text = name
        usernameLabel.text = username
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func startTouchIDAction(_ sender: Any) {
        touckID(true)    }
    
    @IBAction func startLoginAction(_ sender: AnyObject) {
        touckID(false)    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AuthenticationSegue") {
            let finalDestination = segue.destination as? SocketConnectionViewController
            finalDestination?.url = self.url
        }
    }
    
    //Performs authentication using TouchID, only continues if authentication is met
    func touckID(_ handshake: Bool) {
        let authentificationContext = LAContext()
        var error: NSError?
        
        if authentificationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error ) {
            //touch id
            authentificationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "ONLY HUMANS", reply: { (success, error) in
                if success {
                    //Authentication was successful
                    self.navigateToAuthenticatedVC(handshake)
                } else {
                    //Authentication failed
                    if let error = error as? NSError {
                        let message = self.errorMessageForLAErrorCode(errorCode: error.code)
                        self.showAlertViewAfterEvaluation(message: message)
                    }
                }
            })
        }else {
            showAlertViewForNoBiometrics()
            return
        }
    }
    
    //Shows an error if some authentication error is encountered
    func showAlertViewAfterEvaluation(message: String) {
        showAlertWithTitle(title: "Error", message: message)
    }
    
    //Categorizes possible errors from TouchID
    func errorMessageForLAErrorCode(errorCode: Int) -> String {
        var message = ""
        switch errorCode {
        case LAError.appCancel.rawValue:
            message = "fail"
        case LAError.authenticationFailed.rawValue:
            message = "fail"
        case LAError.invalidContext.rawValue:
            message = "fail"
        case LAError.passcodeNotSet.rawValue:
            message = "fail"
        case LAError.systemCancel.rawValue:
            message = "fail"
        case LAError.touchIDLockout.rawValue:
            message = "fail"
        case LAError.touchIDNotAvailable.rawValue:
            message = "fail"
        case LAError.userCancel.rawValue:
            message = "fail"
        case LAError.userFallback.rawValue:
            message = "fail"
            
        default:
            message = "fail"
        }
        return message
        
    }
    
    //Distinguish first time setup from normal login attempt and move to appropriate screen
    func navigateToAuthenticatedVC(_ handshake: Bool) {
        if handshake{
            //First time logging in
            if let loggedInVC = self.storyboard?.instantiateViewController(withIdentifier: "socketConnectionC") as? SocketConnectionViewController {
                DispatchQueue.main.async {
                    loggedInVC.url = self.url
                    loggedInVC.name = self.name
                    loggedInVC.username = self.username
                    self.navigationController?.pushViewController(loggedInVC, animated: true)
                }
                }
        } else {
            //Normal login procedures
            if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "SocketLogin") as? LoginViewController {
                DispatchQueue.main.async {
                    loginVC.url = self.url
                    loginVC.name = self.name
                    loginVC.username = self.username
                    self.navigationController?.pushViewController(loginVC, animated: true)
                }
            }
        }
    }
    
    //In the event the device does not have TouchID, display an error
    func showAlertViewForNoBiometrics() {
        showAlertWithTitle(title: "Error", message: "This device does not have a touch ID sensor.")
    }
    
    //Present alerts as needed
    func showAlertWithTitle(title: String, message:String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertVC.addAction(okAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
}


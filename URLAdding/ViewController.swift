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
    
    var url = ""
    var name = ""
    var username = ""
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    let shm = saltHashManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shm.createHash(handshakeString: "a", rngString: "b")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        // 4
        let image = UIImage(named: "logo.png")
        imageView.image = image
        // 5
        navigationItem.titleView = imageView
        titleLabel.text = url
        nameLabel.text = name
        usernameLabel.text = username
        var website = URLCoreDataManager(url: url)
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
    
    func touckID(_ handshake: Bool) {
        let authentificationContext = LAContext()
        var error: NSError?
        
        if authentificationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error ) {
            //touch id
            authentificationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "ONLY HUMANS", reply: { (success, error) in
                if success {
                    self.navigateToAuthenticatedVC(handshake)
                } else {
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
    
    func showAlertViewAfterEvaluation(message: String) {
        showAlertWithTitle(title: "Error", message: message)
    }
    
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
    
    func navigateToAuthenticatedVC(_ handshake: Bool) {
        if handshake{
            if let loggedInVC = self.storyboard?.instantiateViewController(withIdentifier: "socketConnectionC") as? SocketConnectionViewController {
                DispatchQueue.main.async {
                    loggedInVC.url = self.url
                    loggedInVC.name = self.name
                    loggedInVC.username = self.username
                    self.navigationController?.pushViewController(loggedInVC, animated: true)
                }
                }
        } else {
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
    
    func showAlertViewForNoBiometrics() {
        showAlertWithTitle(title: "Error", message: "This device does not have a touch ID sensor.")
    }
    
    func showAlertWithTitle(title: String, message:String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertVC.addAction(okAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
}


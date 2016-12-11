//
//  FirstViewController.swift
//  fs
//
//  Created by Sebastian Guerrero on 10/25/16.
//  Copyright © 2016 Sebastian Guerrero. All rights reserved.
//

import UIKit
import CoreData
import LocalAuthentication


class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var urlSelected = ""
    let shm = saltHashManager()
    var credentials: [String : Any] = [:]
    
    var webList = [String]()
    var displayTitles = [String]()
    
    
    @IBOutlet weak var webTable: UITableView!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = displayTitles[indexPath.row]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        urlSelected = webList[indexPath.row]
        let username = displayTitles[indexPath.row].components(separatedBy: "as ")[1]
        let storedCreds = findCredentials(url: urlSelected, username: username)
        //Either the token after the handshake is set, or randomToken if it has not been set below
        let token = storedCreds["token"] as! String
        //Save credentials
        appDelegate.credentials = storedCreds
        if (token == "randomToken") {
            //run handshake
            self.touckID(true)
        } else {
            //Run login
            self.touckID(false)
        }
        print(urlSelected)
    }
    
    //Perform move to the handshake page if authenticated and this is a first-time setup
    func moveToHandshakePage(){
        let storedCreds = self.credentials
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "socketConnectionC") as! SocketConnectionViewController
        destination.url = urlSelected
        destination.name = storedCreds["name"] as! String
        destination.username = storedCreds["username"] as! String
        navigationController?.pushViewController(destination, animated: true)
    }
    
    //Perform move to the login page if authenticated and this is not a first time setup (normal login)
    func moveToLoginPage(){
        let storedCreds = self.credentials
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "SocketLogin") as! LoginViewController
        destination.url = urlSelected
        destination.name = storedCreds["name"] as! String
        destination.username = storedCreds["username"] as! String
        let token = storedCreds["token"] as! String
        destination.token = token
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func authedWithTID(){
        return touckID(true)
    }
    
    //Again perform TouchID to authenticate user before moving on
    func touckID(_ handshake: Bool) {
        let authentificationContext = LAContext()
        var error: NSError?
        
        if authentificationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error ) {
            //touch id
            authentificationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "ONLY HUMANS", reply:  { (success, error) in DispatchQueue.main.async {
                if success {
                    //TouchID Authentication Successful
                    if handshake {
                        //If this is the first time setting up, go to handshake
                    self.moveToHandshakePage()
                        return
                    } else {
                        //This is a login attempt so we should simply login
                        self.moveToLoginPage()
                        return
                    }
                } else {
                    //TouchID authentication was not successful
                    if let error = error as? NSError {
                        let message = self.errorMessageForLAErrorCode(errorCode: error.code)
                        self.showAlertViewAfterEvaluation(message: message)
                    }
                }
                }})
        }else {
            showAlertViewForNoBiometrics()
            return
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
    
    func showAlertViewAfterEvaluation(message: String) {
        //showAlertWithTitle(title: "Error", message: message)
    }
    
    //Decodes errors coming back from TouchID
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Function runs after view is shown to improve display UI
    override func viewDidAppear(_ animated: Bool) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        // 4
        let image = UIImage(named: "logo.png")
        imageView.image = image
        // 5
        navigationItem.titleView = imageView
        generateWebList()
        webTable.reloadData()

    }
    
    //Function to add some parameters before shifting pages
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailView" ,
            let nextScene = segue.destination as? ViewController ,
            let indexPath = self.webTable.indexPathForSelectedRow {
            let selectedURL = webList[indexPath.row]
            nextScene.url = selectedURL
        }
        
    }
    
    //Get the user's credentials from NSCoreData so they only have to enter URL and username once
    func findCredentials(url: String, username: String) -> [String: Any]{
        //Assuming using internal data
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Websites")
        request.returnsObjectsAsFaults = false
        
        var urls = [String]()
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let urlGotBack = result.value(forKey: "url") as? String,
                        let nameGotBack = result.value(forKey: "username") as? String{
                        if (urlGotBack == url) && (nameGotBack == username) {
                            let finalName = result.value(forKey: "name")
                            let finalUsername = result.value(forKey: "username")
                            let finalToken = result.value(forKey: "token")
                            var finalDict: [String: Any] = [:]
                            finalDict["name"] = finalName
                            finalDict["username"] = finalUsername
                            finalDict["token"] = finalToken
                            self.credentials = finalDict
                            return finalDict
                        }
                    }
                }
                webList = urls
            }
            else {
                webList = ["no data"]
            }
        }
        catch {
            //process errors
        }
        return ["error" : "Internal Error"]
    }
    
    //Get list of all websties and usernames to display on table view to improve UX
    func generateWebList() {
        webList = ["wow", "yes"]
        displayTitles = ["wow", "yes"]
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Websites")
        request.returnsObjectsAsFaults = false
        
        var urls = [String]()
        var displayNames = [String]()
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let url = result.value(forKey: "url") as? String,
                        let name = result.value(forKey: "username") as? String{
                        urls.append(url)
                        displayNames.append(url + " as " + name)
                    }
                }
                webList = urls
                displayTitles = displayNames
            }
            else {
                webList = ["no data"]
                displayNames = ["no data"]
            }
        }
        catch {
            //process errors
        }
    }
    
}


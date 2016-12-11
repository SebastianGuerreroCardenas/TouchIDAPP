//
//  SecondViewController.swift
//  fs
//
//  Created by Sebastian Guerrero on 10/25/16.
//  Copyright © 2016 Sebastian Guerrero. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let IOManager = SocketIOManager.sharedInstance
   


    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var URLInput: UITextField!
    @IBOutlet weak var usernameInput: UITextField!
    
    //NOTE: This ViewController lets users add URLs and usernames into the system
    
    //Called upon submitting information from the form. This saves info into NSCoreData to be used in the future without having to repeat entering in user info.
    @IBAction func addURLDataAction(_ sender: AnyObject) {
        let context = appDelegate.persistentContainer.viewContext
        
        let newWebsite = NSEntityDescription.insertNewObject(forEntityName: "Websites", into: context)
        
        newWebsite.setValue(nameInput.text, forKey: "name")
        newWebsite.setValue(URLInput.text, forKey: "url")
        newWebsite.setValue(usernameInput.text, forKey: "username")
        newWebsite.setValue(generateToken(), forKey: "token")
        
        do {
            try context.save()
            print("Saved")
            showAlert(message: "data was saved")
        }
        catch {
            //process error
            print("failed to save")
            showAlert(message: "failed to save data")
        }
        
    }
    
    //Initial random token, overwritten after performing initial setup with server.
    func generateToken() -> String {
        return "randomToken"
    }
    
    //Show the user some feedback
    @IBAction func showDataAction(_ sender: AnyObject) {
        showAlert(message: generateMessage())
    }
    
    //Helper function to show user feedback
    func showAlert(message: String) {
        let title = "Data"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default,
                                   handler: { action in
                                    self.alertAction()})
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //Generate the message to be displayed on the table view. If none are available, we want to handle that y simply displaying "no data"
    func generateMessage() -> String {
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Websites")
        request.returnsObjectsAsFaults = false
        
        var urls = ""
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let url = result.value(forKey: "url") as? String {
                        urls += url + " "
                    }
                }
            }
            else {
                //No URLs have been saved yet
                return "no data"
            }
        }
        catch {
            //process erros
        }

        return urls
    }
    
    //Deprecated
    func alertAction() {
        print("Alerting")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


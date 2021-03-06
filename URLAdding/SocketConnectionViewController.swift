//
//  SocketConnectionViewController.swift
//  URLAdding
//
//  Created by Jordan Stapinski on 11/28/16.
//  Copyright © 2016 Sebastian Guerrero. All rights reserved.
//

import UIKit
import CoreData

class SocketConnectionViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let IOManager = SocketIOManager.sharedInstance
    var url: String = ""
    var name: String = ""
    var username: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo.png")
        imageView.image = image
        navigationItem.titleView = imageView

        if self.url == "" {
            print("Empty URL")
            return
        }
        /*
         1. Overwrite Socket to be the new connection
         2. Try to establish connection
         3. Load things to listen to
         4. Send out verification
        */
        
        // Overwrite the socket
        let didOverwrite = self.overwriteSocket()
        if didOverwrite {
            //If we were able to overwrite, establish the connection and load handlers
            self.IOManager.establishConnection()
            self.loadHandlers()
            print("Loaded Handlers")
        } else {
            print("Could not connect to new url: \(self.url)")
        }
    }
    
    /**
     Overwrites socket by connecting to new URL as passed
    */
    func overwriteSocket() -> Bool{
        //Need to make sure self.url is of form http:\\url\
        let result = self.IOManager.changeClient(url: self.url)
        //self.IOManager.establishConnection()
        if result {
            print("Able to change client successfully")
        } else {
            print("Failed to change client")
        }
        return result
    }
    
    /**
     Loads the handlers for the given socket
    */
    func loadHandlers(){
        IOManager.loadHandlers(inst: self)
    }
    
    /**
     Called when the server emits to a specific channel
     - parameter data: The data returned by the server emission
     */
    func handleHandshake(data: [Any]){
        //data will be random string, need to store in core data
        print(data)
        print("Handling info from server now")
        let context = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Websites")
        request.returnsObjectsAsFaults = false
        
        var urls = [String]()
        
        do {
            let results = try context.fetch(request)
            //Set the token in NSCoreData to be the token we got back from the server
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let urlGotBack = result.value(forKey: "url") as? String,
                        let nameGotBack = result.value(forKey: "username") as? String{
                        if (urlGotBack == url) && (nameGotBack == username) {
                            result.setValue(data[0] as! String, forKey: "token")
                        }
                    }
                }

                    try context.save()
                    print("Saved")
            }
            else {
                print("No results")
            }
        }
        catch {
            //process erros
            print("Error")
        }
        //Move on, because we were able to establish the handshake with the server
        performSegue(withIdentifier: "established", sender: data)
    }
    
    //Prepare some fields before swapping screens
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "established") {
            let finalDestination = segue.destination as? EstablishedHandshakeViewController
            finalDestination?.data = sender as! [Any]
            finalDestination?.url = self.url
            finalDestination?.username = self.username
        }
    }
    
    /**
     Pings certain parameters to the server, which should then get a response
    */
    @IBAction func sendVerification(sender: AnyObject){
        //Need to find out now if we are sending a setup or a request to sign-in
        IOManager.startHandshake(parameters: appDelegate.credentials as [String : AnyObject])
        
        //Info coming back from here is to be handled in some handler from before
        print("Seding out handshake, see server output")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

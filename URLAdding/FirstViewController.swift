//
//  FirstViewController.swift
//  fs
//
//  Created by Sebastian Guerrero on 10/25/16.
//  Copyright © 2016 Sebastian Guerrero. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var urlSelected = ""
    //let IOManager = SocketIOManager.sharedInstance

    
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
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let storedCreds = findCredentials(url: urlSelected)
        let token = storedCreds["token"] as! String
        if (token == "randomToken") {
            //run handshake
            let destination = storyboard.instantiateViewController(withIdentifier: "socketConnectionC") as! SocketConnectionViewController
            destination.url = urlSelected
            destination.name = storedCreds["name"] as! String
            destination.username = storedCreds["username"] as! String
            //destination.token = token
            navigationController?.pushViewController(destination, animated: true)
        } else {
            //Run login
            let destination = storyboard.instantiateViewController(withIdentifier: "SocketLogin") as! LoginViewController
            destination.url = urlSelected
            destination.name = storedCreds["name"] as! String
            destination.username = storedCreds["username"] as! String
            destination.token = token
            navigationController?.pushViewController(destination, animated: true)
        }
//        let destination = storyboard.instantiateViewController(withIdentifier: "socketLogin") as! LoginViewController
//        destination.url = urlSelected
//        destination.name = storedCreds["name"] as! String
//        destination.username = storedCreds["username"] as! String
//        destination.token = token
//        navigationController?.pushViewController(destination, animated: true)
//        urlSelected = webList[indexPath.row]
//        let storyBoard = storyboard?.instantiateViewController(withIdentifier: "websiteDetails")
        //viewController.url = urlSelected
//       rself.navigationController?.pushViewController(viewController!, animated: true)
//        print(findCredentials(url: urlSelected))
        print(urlSelected)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load event handlers and finish establishing connection
        //IOManager.handShakeResponse()
//        IOManager.establishConnection()
        
        //Emitting here did not work since connection had not been fully established
//        IOManager.startHandshake(parameters: [:])
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailView" ,
            let nextScene = segue.destination as? ViewController ,
            let indexPath = self.webTable.indexPathForSelectedRow {
            let selectedURL = webList[indexPath.row]
            print(findCredentials(url: selectedURL))
            //HERE
            nextScene.url = selectedURL
            //IOManager.startHandshake(parameters: [:])

        }
        
    }
    
    func findCredentials(url: String) -> [String: Any]{
        //Either do an API call or use internals?
        //Assuming using internal data
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Websites")
        request.returnsObjectsAsFaults = false
        
        var urls = [String]()
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let urlGotBack = result.value(forKey: "url") as? String {
                        if urlGotBack == url {
                            let finalName = result.value(forKey: "name")
                            let finalUsername = result.value(forKey: "username")
                            let finalToken = result.value(forKey: "token")
                            var finalDict: [String: Any] = [:]
                            finalDict["name"] = finalName
                            finalDict["username"] = finalUsername
                            finalDict["token"] = finalToken
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
            //process erros
        }
        return ["error" : "Internal Error"]
    }
    
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
            //process erros
        }
    }
    
}


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
    
    
    @IBOutlet weak var webTable: UITableView!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = webList[indexPath.row]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        urlSelected = webList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "websiteDetails") as! ViewController
        destination.url = urlSelected
        navigationController?.pushViewController(destination, animated: true)
//        urlSelected = webList[indexPath.row]
//        let storyBoard = storyboard?.instantiateViewController(withIdentifier: "websiteDetails")
        //viewController.url = urlSelected
//       rself.navigationController?.pushViewController(viewController!, animated: true)
        
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
        generateWebList()
        webTable.reloadData()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailView" ,
            let nextScene = segue.destination as? ViewController ,
            let indexPath = self.webTable.indexPathForSelectedRow {
            let selectedURL = webList[indexPath.row]
            nextScene.url = selectedURL
            //IOManager.startHandshake(parameters: [:])

        }
        
    }
        
    func generateWebList() {
        webList = ["wow", "yes"]
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Websites")
        request.returnsObjectsAsFaults = false
        
        var urls = [String]()
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let url = result.value(forKey: "url") as? String {
                        urls.append(url)
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
    }
    
}


//
//  URLCoreDataManager.swift
//  URLAdding
//
//  Created by Sebastian Guerrero on 11/22/16.
//  Copyright © 2016 Sebastian Guerrero. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class URLCoreDataManager: NSObject {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var name: String = ""
    var url: String = ""
    var username: String = ""
    var token: String = ""
    
    init(url: String) {
        super.init()
        fetchWebsite(urlToGet: url)
    }
    
    //Iterates through all the urls, and when it matches with the initilizer it sets all the varibles.
    func fetchWebsite(urlToGet: String) {
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Websites")
        request.returnsObjectsAsFaults = false
        
        var urls = [String]()
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    
                    if let durl = result.value(forKey: "url") as? String {
                        if durl == urlToGet {
                            self.url = durl
                            
                            if let dname = result.value(forKey: "name") as? String {
                                self.name = dname
                            }
                            if let dusername = result.value(forKey: "username") as? String {
                                self.username = dusername
                            }
                            if let dtoken = result.value(forKey: "token") as? String {
                                self.token = dtoken
                            }
                            
                        }
                    }
                }
            }
            else {
                print("Does not exists")
            }
        }
        catch {
            //process erros
        }

    }
}

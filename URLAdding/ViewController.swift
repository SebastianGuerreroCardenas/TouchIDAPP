//
//  ViewController.swift
//  URLAdding
//
//  Created by Sebastian Guerrero on 10/25/16.
//  Copyright © 2016 Sebastian Guerrero. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    var url = ""
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = url
        var website = URLCoreDataManager(url: url)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AuthenticationSegue") {
            let finalDestination = segue.destination as? SocketConnectionViewController
            finalDestination?.url = self.url
        }
    }


}


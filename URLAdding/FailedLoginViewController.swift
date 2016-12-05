//
//  FailedLoginViewController.swift
//  URLAdding
//
//  Created by Jordan Stapinski on 12/5/16.
//  Copyright © 2016 Sebastian Guerrero. All rights reserved.
//

import UIKit

class FailedLoginViewController: UIViewController {
    
    var timeLeft: Int = 0
    var timer: Timer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        timeLeft = 3
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(FailedLoginViewController.countDownTick), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    func countDownTick(){
        //if timeLeft = 0
        print(timeLeft)
        if (timeLeft == 0) {
            timer!.invalidate()
            timer=nil
            performSegue(withIdentifier: "loginBackToMenu", sender: "")
        } else {
            timeLeft = timeLeft - 1
            //label.text = String(timeLeft)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "loginBackToMenu") {
            let finalDestination = segue.destination as? FirstViewController
            //finalDestination?.data = sender as! [Any]
            finalDestination?.navigationItem.hidesBackButton = true
            
        }
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

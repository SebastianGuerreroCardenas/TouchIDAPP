//
//  LoginConfirmationViewController.swift
//  URLAdding
//
//  Created by Jordan Stapinski on 12/3/16.
//  Copyright © 2016 Sebastian Guerrero. All rights reserved.
//

import UIKit

class LoginConfirmationViewController: UIViewController {
    
    var url: String = ""
    var username: String = ""

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var successMsg: UILabel!
    var timeLeft: Int = 0
    var timer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set display text as needed
        successMsg.text = "Successfully logged into \(url) as \(username)"
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo.png")
        imageView.image = image
        navigationItem.titleView = imageView

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timeLeft = 3
        //Automatically redirect home after 3 seconds
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(EstablishedHandshakeViewController.countDownTick), userInfo: nil, repeats: true)
        label.text = String(timeLeft)
    }
    
    //Check if 3 seconds have passed, if so move back to the home page
    func countDownTick(){
        if (timeLeft == 0) {
            timer!.invalidate()
            timer=nil
            performSegue(withIdentifier: "loginToMenu", sender: "")
        } else {
            timeLeft = timeLeft - 1
            label.text = String(timeLeft)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "loginToMenu") {
            let finalDestination = segue.destination as? FirstViewController
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

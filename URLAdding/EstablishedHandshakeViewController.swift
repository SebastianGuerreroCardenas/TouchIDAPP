//
//  EstablishedHandshakeViewController.swift
//  URLAdding
//
//  Created by Jordan Stapinski on 11/28/16.
//  Copyright © 2016 Sebastian Guerrero. All rights reserved.
//

import UIKit

class EstablishedHandshakeViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var successMsg: UILabel!
    var data: [Any] = []
    var timeLeft: Int = 0
    var timer: Timer? = nil
    
    var url: String = ""
    var username: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.successMsg.text = "Successfully performed setup with \(url) as \(username)"
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo.png")
        imageView.image = image
        navigationItem.titleView = imageView

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timeLeft = 3
        //Automatically redirect user back to home screen
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(EstablishedHandshakeViewController.countDownTick), userInfo: nil, repeats: true)
        label.text = String(timeLeft)
    }
    
    //Move back home after 3 seconds
    func countDownTick(){
        if (timeLeft == 0) {
            timer!.invalidate()
            timer=nil
            //Actually move back to menu when out of time
            performSegue(withIdentifier: "backToMenu", sender: "")
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
        if (segue.identifier == "backToMenu") {
            let finalDestination = segue.destination as? FirstViewController
            //Ensure user cannot try to re-access login without first authenticating
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

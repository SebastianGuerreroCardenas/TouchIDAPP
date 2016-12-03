//
//  LoginConfirmationViewController.swift
//  URLAdding
//
//  Created by Jordan Stapinski on 12/3/16.
//  Copyright © 2016 Sebastian Guerrero. All rights reserved.
//

import UIKit

class LoginConfirmationViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
//    var data: [Any] = []
    var timeLeft: Int = 0
    var timer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        // 4
        let image = UIImage(named: "logo.png")
        imageView.image = image
        // 5
        navigationItem.titleView = imageView

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timeLeft = 3
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(EstablishedHandshakeViewController.countDownTick), userInfo: nil, repeats: true)
        //        while (x > 0) {
        //            label.text = String(x)
        //            label.reloadInputViews()
        //            sleep(1)
        //            x = x - 1
        //        }
        label.text = String(timeLeft)
    }
    
    func countDownTick(){
        //if timeLeft = 0
        print(timeLeft)
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

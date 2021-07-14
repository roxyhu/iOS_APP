//
//  SimBotViewController.swift
//  iOS13OnDeviceSpeechRecognition
//
//  Created by 魏廷昇 on 2020/8/15.
//  Copyright © 2020 iowncode. All rights reserved.
//

import UIKit

class SimBotViewController: UIViewController {

    @IBOutlet weak var simbot1: UIButton!
    @IBOutlet weak var sendtextfield: UITextField!
    
    
    
    @IBAction func backsimbot(_ sender:UIStoryboardSegue){
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backbutton(_ sender:UIStoryboardSegue){
        
    }
    
    
    @IBAction func simoneclick(_ sender: Any) {
        print("2121")
        self.performSegue(withIdentifier: "to", sender: nil)
               
        sendtextfield.text = ""

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "to" {
            let finalsimVC = segue.destination as! finalsimViewController
            finalsimVC.receivedText = sendtextfield.text!

//            let secondVC = segue.destination as! SecondViewController
//
//            secondVC.receivedText = inputTextfield.text!

        }
    }
    
    @IBAction func logoutbtn(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginIDVC = storyBoard.instantiateViewController(withIdentifier: "loginID")
        present(loginIDVC, animated: true, completion: nil)
    }
    

}

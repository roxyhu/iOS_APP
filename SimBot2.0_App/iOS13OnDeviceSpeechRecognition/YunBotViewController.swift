//
//  YunBotViewController.swift
//  iOS13OnDeviceSpeechRecognition
//
//  Created by 魏廷昇 on 2020/8/15.
//  Copyright © 2020 iowncode. All rights reserved.
//

import UIKit

class YunBotViewController: UIViewController {
    
    
//    var label:String?

    @IBOutlet weak var yunbot1: UIButton!
    @IBOutlet weak var inputfield: UITextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    @IBAction func backbutton(_ sender:UIStoryboardSegue){
        
    }
    
    
    
    @IBAction func botoneclick(_ sender: Any) {
        print("11111")
        self.performSegue(withIdentifier: "send", sender: nil)
        inputfield.text = ""
//        if let label = label{
//            print(label)
            
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){

        if segue.identifier == "send"{
            let yunoneVC = segue.destination as! yunoneViewController
            yunoneVC.receivedText = inputfield.text!
        }
    }
    
    
    @IBAction func logoutbtn(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginIDVC = storyBoard.instantiateViewController(withIdentifier: "loginID")
        present(loginIDVC, animated: true, completion: nil)
        
    }
    
    

}

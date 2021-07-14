//
//  initialViewController.swift
//  iOS13OnDeviceSpeechRecognition
//
//  Created by 魏廷昇 on 2020/8/13.
//  Copyright © 2020 iowncode. All rights reserved.
//

import UIKit

class initialViewController: UIViewController {

    @IBOutlet weak var nameview: UITextView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameview.text = school + "\n" + student
        // Do any additional setup after loading the view.
    }
    @IBAction func initialbutton(_ sender:UIStoryboardSegue){
        
    }
    @IBAction func logoutbtn(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginIDVC = storyBoard.instantiateViewController(withIdentifier: "loginID")
        present(loginIDVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
//        let vc = segue.destination as? YunBotViewController
//        vc?.label = "yunbot_1"
    }
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

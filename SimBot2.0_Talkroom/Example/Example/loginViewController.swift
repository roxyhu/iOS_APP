//
//  loginViewController.swift
//  Example
//
//  Created by 魏廷昇 on 2021/2/3.
//  Copyright © 2021 little2s. All rights reserved.
//

import UIKit

var school = ""
var student = ""
var bot = ""
class loginViewController: UIViewController {

    
    @IBOutlet weak var school_field: UITextField!
    @IBOutlet weak var name_field: UITextField!
    @IBOutlet weak var botfield: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func login_clock(_ sender: Any) {
        school = self.school_field.text!
        student = self.name_field.text!
        bot = self.botfield.text!
        print(school)
        print(student)
        print(bot)
        
        
    }
    

}

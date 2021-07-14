//
//  loginViewController.swift
//  iOS13OnDeviceSpeechRecognition
//
//  Created by 魏廷昇 on 2020/8/25.
//  Copyright © 2020 iowncode. All rights reserved.
//

import UIKit

var school = ""
var student = ""


class loginViewController: UIViewController {
    
    
    
    @IBOutlet weak var accountfield: UITextField!
    @IBOutlet weak var passwordfield: UITextField!
    @IBOutlet weak var loginbtn: UIButton!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    func enablebtn(){
        loginbtn.isEnabled = true
    }
    
    
    @IBAction func loginclick(_ sender: Any) {
        
        school = self.accountfield.text!
        student = self.passwordfield.text!
        print(school)
        print(student)
        
        if school.isEmpty || student.isEmpty ?? true {
            loginbtn.isEnabled = false
            print("textField is empty")
            return enablebtn()
        } else {
            loginbtn.isEnabled = true
            print("textField has some text")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let initialIDVC = storyBoard.instantiateViewController(withIdentifier: "initial_ID")
            present(initialIDVC, animated: true, completion: nil)
        }

        let dic = "sender=user" + "&message=" + school + "\n" + student
        let url = URL(string: "http://140.125.32.128:5000/ScoreBot")!
        var request = URLRequest(url: url) //request一個網路對象
         request.httpMethod = "POST" //方法為：ＰＯＳＴ
         request.httpBody = dic.data(using: .utf8, allowLossyConversion: true)!//請求內容為 dic.data
         let task = URLSession.shared.dataTask(with: request) { data, response, error in//發送出去
         guard let data = data, error == nil else {
         print(error?.localizedDescription ?? "No data")
         return
         }
         let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
         if let responseJSON = responseJSON as? [String: String] {
        //                                   print(responseJSON["guess"]!,type(of: responseJSON["guess"]!))
          DispatchQueue.main.async { //
                   //                            self.historyview.insertText(ret)
                   //                            self.historyview.insertText("\n")
                   //                            self.historyview.insertText(responseJSON["guess"]!)
                   //                            self.historyview.insertText("\n")
                   //                            print(responseJSON["guess"]!)
                                               
                                }
                            }
                        }
                    task.resume()
                 
            }
    
    
func textFieldlock(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
   if string == "#" || string == " " {
       return false //disallow # and a space
   }
   return true

}

    
    
    
    
    
}


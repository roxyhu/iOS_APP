//
//  nlpViewController.swift
//  iOS13OnDeviceSpeechRecognition
//
//  Created by 魏廷昇 on 2020/9/21.
//  Copyright © 2020 iowncode. All rights reserved.
//

import UIKit
import Speech



class nlpViewController: UIViewController {
    
    
    @IBOutlet weak var history: UITextView!
    @IBOutlet weak var robothistory: UITextView!
    @IBOutlet weak var abtn: UIButton!
    @IBOutlet weak var bbtn: UIButton!
    @IBOutlet weak var aview: UITextView!
    @IBOutlet weak var bview: UITextView!
    @IBOutlet weak var correctbtn: UIButton!
    
    
    
    
        private let audioEngine = AVAudioEngine()
        private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
        private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
        private var recognitionTask: SFSpeechRecognitionTask?

        var arr: Array<String> = []
        var brr: Array<String> = []
        var crr: Array<String> = []
        var drr: Array<String> = []
        var receivedText:String = ""
        
         let transcribedText:UITextView = {
            let view = UITextView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 15
            view.layer.masksToBounds = true
            view.textColor = .white
            view.font = UIFont.systemFont(ofSize: 25)
            view.backgroundColor = .gray
            return view
        }()
        
        let button:UIImageView = {
            let view = UIImageView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.image = UIImage(systemName: "mic.slash.fill")
            
            return view
        }()
        
        var micOn : Bool = false{
            didSet{
                if micOn{
                    button.image = UIImage(systemName: "mic.fill")
                            do{
                                self.transcribedText.text = ""
                                try self.startRecording()
                            }catch(let error){
                                print("error is \(error.localizedDescription)")
                            }
                }
                else{
                    let word = self.transcribedText.text
                    print("否")
                    if (word!.contains("I guess")){
                                print(word!.contains("I guess"))
                    }
                        
                    else if(word != ""){
                        post(transcribedText.text)
                        print(word!.contains("I guess"))
                    }
                    
                    if audioEngine.isRunning {
                        recognitionRequest?.endAudio()
                        audioEngine.stop()
                    }
                    button.image = UIImage(systemName: "mic.slash.fill")
                }
            }
        }
        

        override func viewDidLoad() {
            super.viewDidLoad()
            buildUI()
            getPermissions()
            guard SFSpeechRecognizer.authorizationStatus() == .authorized
            else {
                print("guard failed...")
                return
            }
            // Do any additional setup after loading the view.
        }
        
        
        

        @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
            let tappedImage = tapGestureRecognizer.view as! UIImageView
            tappedImage.image = UIImage(systemName: "mic.fill")
            micOn = !micOn
        }
        
        func buildUI()
        {
            self.view.addSubview(button)
            self.view.addSubview(transcribedText)

            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            button.isUserInteractionEnabled = true
            button.addGestureRecognizer(tapGestureRecognizer)
            
            
            NSLayoutConstraint.activate(
                [
                button.heightAnchor.constraint(equalToConstant: 150),
                button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
                button.widthAnchor.constraint(equalToConstant: 150)
                ]
            )
            

            NSLayoutConstraint.activate(
                [transcribedText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
                 transcribedText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                 transcribedText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                 transcribedText.heightAnchor.constraint(equalToConstant: 100),
                 transcribedText.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                ]
            )
        }
        
        func startRecording() throws {

            recognitionTask?.cancel()
            self.recognitionTask = nil

            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            let inputNode = audioEngine.inputNode
            inputNode.removeTap(onBus: 0)
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                self.recognitionRequest?.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
            recognitionRequest.shouldReportPartialResults = true

            if #available(iOS 13, *) {
                if speechRecognizer?.supportsOnDeviceRecognition ?? false{
                    recognitionRequest.requiresOnDeviceRecognition = true
                }
            }

            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
                if let result = result {
                    DispatchQueue.main.async {
                            let transcribedString = result.bestTranscription.formattedString
                            self.transcribedText.text = (transcribedString)
                    }
                }
                
                if error != nil {
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                }
            }
            
        }
        
        func getPermissions(){
            SFSpeechRecognizer.requestAuthorization{authStatus in
                OperationQueue.main.addOperation {
                   switch authStatus {
                        case .authorized:
                            print("authorised..")
                        default:
                            print("none")
                   }
                }
            }
        }
        func post(_ ret : String){
                    
                        var ret = self.transcribedText.text!
            
                    
                        let dic = "sender=user" + "&message=" + ret + "&bot=" + "1" + "&school=" + school + "&student=" +  student
                        let url = URL(string: "http://140.125.32.128:5000/NLPBot")!
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
        //                        print(responseJSON["score"]!)
                                print(responseJSON["similar_words_1"]!)
                                print(responseJSON["similar_words_2"]!)
                                print(responseJSON["similar_words_3"]!)
                                
                                DispatchQueue.main.async() {
                                    
                                    self.arr.insert(ret,at:0)
                                    var count = 0
                                    for num in self.arr{
                                        if(count==0){
                                            self.history.text=""
                                        }
                                        count+=1
                                        print(num)
                                        self.history.insertText(num)
                                        self.history.insertText("\n")
                                    }
                                    self.brr.insert(responseJSON["similar_words_1"]!,at:0)
                                    
                                    var a = 0
                                    for numb in self.brr{
                                        if(a==0){
                                            self.robothistory.text=""
                                        }
                                        a+=1
                                        print(numb)
                                        self.robothistory.insertText(numb)
                                        self.robothistory.insertText("\n")
                                    }
                                    self.crr.insert(responseJSON["similar_words_2"]!,at:0)
                                    
                                    var b = 0
                                    for numb in self.crr{
                                        if(b==0){
                                            self.aview.text=""
                                        }
                                        a+=1
                                        print(numb)
                                        self.aview.insertText(numb)
                                        self.aview.insertText("\n")
                                    }
                                    self.drr.insert(responseJSON["similar_words_3"]!,at:0)
                                    
                                    var c = 0
                                    for numb in self.drr{
                                        if(c==0){
                                            self.bview.text=""
                                        }
                                        a+=1
                                        print(numb)
                                        self.bview.insertText(numb)
                                        self.bview.insertText("\n")
                                    }
    //                                self.rotbotview.text = responseJSON["similar_words"]!
    //    //                            self.history.insertText(ret)
    //    //                            self.history.insertText("\n")
    //                                self.rotbothistory.insertText(responseJSON["similar_words"]!)
    //                                self.rotbothistory.insertText("\n")
                                }
                                
                            }
                            
                            
                            
                        }
                        task.resume()
                    }
    
    
    
    @IBAction func correctclick(_ sender: Any) {
        var ret = self.transcribedText.text!
                
                        
        let dic = "sender=user" + "&message=" + ret + "&status=" + "1" + "&data=" + "" + "&label=" +  ""
        let url = URL(string: "http://140.125.32.128:5000/new_train_data")!
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
//                        print(responseJSON["score"]!)
                print(responseJSON["return"]!)
                DispatchQueue.main.async() {
                    
                    
                }
                
            }
                                
                                
                                
            }
            task.resume()
        }
        
    
    @IBAction func aclick(_ sender: Any) {
          var ret = self.transcribedText.text!
                var dataText = self.aview.text!
                var labelText = self.bview.text!
                                        
                        let dic = "sender=user" + "&message=" + ret + "&status=" + "0" + "&label=" +  dataText                              
                        let url = URL(string: "http://140.125.32.128:5000/new_train_data")!
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
                //                        print(responseJSON["score"]!)
                                print(responseJSON["return"]!)
                                DispatchQueue.main.async() {
                                    
                                    
                                    
                                }
                                
                            }
                                                
                                                
                                    
                }
                task.resume()
            
            }
    
    
    @IBAction func bclick(_ sender: Any) {
        var ret = self.transcribedText.text!
        var dataText = self.aview.text!
        var labelText = self.bview.text!
                                
                let dic = "sender=user" + "&message=" + ret + "&status=" + "0" +  "&label=" +  labelText
                let url = URL(string: "http://140.125.32.128:5000/new_train_data")!
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
        //                        print(responseJSON["score"]!)
                        print(responseJSON["return"]!)
                        DispatchQueue.main.async() {
                        
                        }
                        
                    }
                                 
            }
            task.resume()
        
    }
    
    

}

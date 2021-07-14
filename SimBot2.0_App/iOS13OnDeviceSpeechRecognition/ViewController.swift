//
//  ViewController.swift
//  iOS13OnDeviceSpeechRecognition
//
//  Created by Anupam Chugh on 01/11/19.
//  Copyright © 2019 iowncode. All rights reserved.
//

import UIKit
import Speech
import AVFoundation
import Combine
import Foundation

class ViewController: UIViewController, UITextViewDelegate, AVAudioRecorderDelegate {
    
    
    @IBOutlet weak var historyview: UITextView!
    @IBOutlet weak var pythonview: UIImageView!
    @IBOutlet weak var clearbutton: UIButton!
    @IBOutlet weak var robotview: UITextView!
    @IBOutlet weak var scoreview: UITextView!
    @IBOutlet weak var robothistory: UITextView!
    @IBOutlet weak var scorehistory: UITextView!
    @IBOutlet weak var testbutton: UIButton!
    
    var player: AVAudioPlayer?
    var recorder: AVAudioRecorder?
    var recognizedText : String = ""
    var ret : String = ""
    var resAns = ""
    var resType = ""
    var history : Array<String> = []
    var arr: Array<String> = []
    var brr: Array<String> = []
    var crr: Array<String> = []
//    var nativeAudioFormat: AVAudioFormat { get }
    
    

    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    
    
    @IBAction func testbtn(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "good job")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(Discourse)
        print("12334234")
        
    }
    
    
    
    
    
    
     let transcribedText:UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 30)
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
            print(micOn)
            if micOn{
                print("是")
                button.image = UIImage(systemName: "mic.fill")
                        do{
                            self.transcribedText.text = ""
                            try self.startRecording()
                            beginRecord()
                        }catch(let error){
                            print("error is \(error.localizedDescription)")
                        }
                
            }
            else{
                let word = self.transcribedText.text
                print("否")
                if (word!.contains("I guess")){
                            guessanimal(transcribedText.text)
                            print(word!.contains("I guess"))
                }
                    
                else if(word != ""){
                    post(transcribedText.text)
                    print(word!.contains("I guess"))
                }
                
                if audioEngine.isRunning {
                    recognitionRequest?.endAudio()
                    audioEngine.stop()
                    recognitionTask = nil
                    audioEngine.inputNode.removeTap(onBus:0)
                    audioEngine.reset()
                    stopRecord()
                    do {
                        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
                        try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                    } catch {
                        print("audioSession properties weren't set because of an error.")
                    }
                    
                    delay(by:1){
                    let Discourse = AVSpeechUtterance (string: self.robotview.text)
                    let synthesizer = AVSpeechSynthesizer()
                    Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
                    synthesizer.speak(Discourse)
                    print("12334234")
                    }
                    
                }
                finishRecording(success: true)
                
                
                button.image = UIImage(systemName: "mic.slash.fill")
                
            }
        }
    }
    
    
    public func delay(by delayTime: TimeInterval, qosClass: DispatchQoS.QoSClass? = nil,
                      _ closure: @escaping () -> Void) {
        let dispatchQueue = qosClass != nil ? DispatchQueue.global(qos: qosClass!) : .main
        dispatchQueue.asyncAfter(deadline: DispatchTime.now() + delayTime, execute: closure)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pythonview.image = CommonDefine().getwhiteImage()
        transcribedText.delegate = self
        buildUI()
        getPermissions()
        guard SFSpeechRecognizer.authorizationStatus() == .authorized
        else {
            print("guard failed...")
            return
        }
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        tappedImage.image = UIImage(systemName: "mic.fill")
        micOn = !micOn
//        guessanimal(ret)
        
        
    }
    
    @IBAction func changeanimal(_ sender: Any) {
        
//        let Discourse = AVSpeechUtterance (string: "good job")
//        let synthesizer = AVSpeechSynthesizer()
//        synthesizer.speak(Discourse)
        
        
//        self.pythonview.image = CommonDefine().getwhiteImage()
//        let dic = "sender=user" + "&message=" + "9"
//            let url = URL(string: "http://140.125.32.128:5000/change")!
//            var request = URLRequest(url: url) //request一個網路對象
//            request.httpMethod = "POST" //方法為：ＰＯＳＴ
//            request.httpBody = dic.data(using: .utf8, allowLossyConversion: true)!//請求內容為 dic.data
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in//發送出去
//                guard let data = data, error == nil else {
//                    print(error?.localizedDescription ?? "No data")
//                    return
//                }
//                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//                if let responseJSON = responseJSON as? [String: String] {
//                    print(responseJSON["test"]!,type(of: responseJSON["test"]!))
                    DispatchQueue.main.async { // Correct
                       
                        self.historyview.text = ""
                        self.transcribedText.text = ""
                        self.robotview.text = ""
                        self.robothistory.text = ""
                        self.scoreview.text = ""
                        self.scorehistory.text = ""
                       self.clearbutton.setTitle("successful", for: .normal)
                    }
//                }
//            }
//            task.resume()
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
             button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 300),
//             button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
             button.widthAnchor.constraint(equalToConstant: 150)
            ]
        )
        

        NSLayoutConstraint.activate(
            [transcribedText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
             transcribedText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
             transcribedText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
             transcribedText.heightAnchor.constraint(equalToConstant: 100),
             transcribedText.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ]
        )
    }
    
    func startRecording() throws {
        if recognitionTask != nil{
            recognitionTask?.cancel()
            self.recognitionTask = nil
        }
        //save file
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        let audioSession = AVAudioSession.sharedInstance()
//        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
//        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
//
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
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
            if let result = result{
                DispatchQueue.main.async {
                        let transcribedString = result.bestTranscription.formattedString
//                        self.x = ""
                        
                        self.transcribedText.text = (transcribedString)
                        
                        //print("123 \(isFinal)")
//                        self.historyview.insertText(transcribedString)
//                        self.historyview.insertText("\n")
                    
                    if transcribedString.contains("I guess"){
//                                self.guessanimal(self.ret)
//                                self.testview.text = ""
//                                self.robotidentify.text = ""
                            }
//                            else if transcribedString.contains("right"){
//                    //            self.testview.text = ""
//                    //            self.robotidentify.text = ""
//                                self.historyview.text = "answer"
//                            }
                    else {
                                    
                            //self.post(self.ret)

                            }
                    
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
    
    
    
//   ================================
    //save mp4
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            print("success")
        } else {
            print("error")
            // recording failed :(
        }
    }
    
    
    
    
    open func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishRecognition recognitionResult: SFSpeechRecognitionResult) {
        self.recognizedText = recognitionResult.bestTranscription.formattedString
        print(self.recognizedText)
    }
    
    
    func guessanimal( _ ret: String){
        var ret = self.transcribedText.text!
        print("111 \(ret)")
        
        
        
        
        let dic = "sender=user" + "&message=" + ret
        let url = URL(string: "http://140.125.32.128:5000/guess")!
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
                print(responseJSON["guess"]!,type(of: responseJSON["guess"]!))
                DispatchQueue.main.async { // Correct
                    //let ans = "ans:" + responseJSON["ans"] + "type:" + !responseJSON["type"]
//                    self.answerview.text = responseJSON["guess"]
                    self.historyview.insertText(ret)
                    self.historyview.insertText("\n")
                    self.historyview.insertText(responseJSON["guess"]!)
                    self.historyview.insertText("\n")
                    print(responseJSON["guess"]!)
                    
                }
            }
        }
        task.resume()
    }
    
    
    
    
    
    func post(_ ret : String){
        
            var ret = self.transcribedText.text!
            
            let dic = "sender=user" + "&message=" + ret
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
                    print(responseJSON["score"]!)
                    print(responseJSON["similar_words"]!)
                    DispatchQueue.main.async() {
                        self.arr.insert(ret,at:0)
                        var count = 0
                        for num in self.arr{
                            if(count==0){
                                self.historyview.text=""
                            }
                            count+=1
                            print(num)
                            self.historyview.insertText(num)
                            self.historyview.insertText("\n")
                        }
                        self.brr.insert(responseJSON["similar_words"]!,at:0)
                        
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

                        self.crr.insert(responseJSON["score"]!,at:0)
                        var b = 0
                        for numc in self.crr{
                            if(b==0){
                                self.scorehistory.text=""
                            }
                            b+=1
                            print(numc)
                            self.scorehistory.insertText(numc)
                            self.scorehistory.insertText("\n")
                        }
                        
                        self.robotview.text = responseJSON["similar_words"]!
                        self.scoreview.text = responseJSON["score"]!
//                        self.historyview.insertText(ret)
//                        self.historyview.insertText("\n")
//                        self.scorehistory.insertText(responseJSON["score"]!)
//                        self.scorehistory.insertText("\n")
//                        self.robothistory.insertText(responseJSON["similar_words"]!)
//                        self.robothistory.insertText("\n")
                    }
                    
                    
//                    print(responseJSON["type"]!,type(of: responseJSON["type"]!))
//                    print(responseJSON["ans"]!,type(of: responseJSON["ans"]!))
//                    self.history.append(ret)
//                    self.history.append(responseJSON["type"]!)
//                    self.history.append(responseJSON["ans"]!)
//                    print(self.history)
//                    print(self.history[(self.history.count)-3])
//                    print("123123123")
//                    DispatchQueue.main.async() { // Correct
//                        //let ans = "ans:" + responseJSON["ans"] + "type:" + !responseJSON["type"]
////                        self.testview.text = responseJSON["type"]
////                        self.robotidentify.text = responseJSON["ans"]
//                        self.resAns = responseJSON["ans"]!
//                        self.resType = responseJSON["type"]!
//                        self.historyview.insertText(ret)
//                        self.historyview.insertText("\n")
//                        self.historyview.insertText(responseJSON["type"]!)
//                        self.historyview.insertText("\n")
//                        self.historyview.insertText(responseJSON["ans"]!)
//                        self.historyview.insertText("\n")
////                        self.historyview.insertText(self.history[(self.history.count)-3])
////                        self.historyview.insertText("\n")
////                        self.historyview.insertText(self.history[(self.history.count)-2])
////                        self.historyview.insertText("\n")
////                        self.historyview.insertText(self.history[(self.history.count)-1])
////                        self.historyview.insertText("\n")
//
//                    }
                }
                
                
                
                DispatchQueue.main.async { // Make sure you're on the main thread here
                    if (self.resAns.contains("Yes") && self.resType.contains("wings")){
                                self.pythonview.image = CommonDefine().getpythonImage()

                        }else if(self.resAns.contains("Yes") && self.resType.contains("lay_eggs")){
                                self.pythonview.image = CommonDefine().getlayEggsImage()

                        }else if(self.resAns.contains("Yes") && self.resType.contains("webbed_feet")){
                                self.pythonview.image = CommonDefine().getwebbed_feetImage()

                        }else if(self.resAns.contains("Yes") && self.resType.contains("carnivorous")){
                                self.pythonview.image = CommonDefine().getcarnivorousImage()

                        }else if(self.resAns.contains("Yes") && self.resType.contains("long_nose")){
                                self.pythonview.image = CommonDefine().getlongnoseImage()

                        }else if(self.resAns.contains("Yes") && self.resType.contains("fur")){
                                self.pythonview.image = CommonDefine().getfurImage()

                        }else if(self.resAns.contains("Yes") && self.resType.contains("tame")){
                                self.pythonview.image = CommonDefine().gettameImage()

                        }else if(self.resAns.contains("Yes") && self.resType.contains("fierce")){
                                self.pythonview.image = CommonDefine().getfierceImage()

                        }else if(self.resAns.contains("2") && self.resType.contains("any_feet")){
                                self.pythonview.image = CommonDefine().gettwoImage()

                        }else if(self.resAns.contains("4") && self.resType.contains("any_feet")){
                                self.pythonview.image = CommonDefine().getfourImage()

                        }else if(self.resAns.contains("0") && self.resType.contains("any_feet")){
                                self.pythonview.image = CommonDefine().getzeroImage()

                        }else if(self.resAns.contains("Yes") && self.resType.contains("herbivore")){
                                self.pythonview.image = CommonDefine().getherbivoreImage()

                        }else if(self.resAns.contains("Yes") && self.resType.contains("omnivores")){
                                self.pythonview.image = CommonDefine().getomnivoresImage()

                        }else if(self.resAns.contains("Yes") && self.resType.contains("fly")){
                                self.pythonview.image = CommonDefine().getflyImage()

                        }
                    else{
                        self.pythonview.image = CommonDefine().getwhiteImage()
                        }
                    }
                
            }
            task.resume()
        }
    //开始录音

     func beginRecord() {
        
         let session = AVAudioSession.sharedInstance()

         //设置session类型

         do {

            try session.setCategory(AVAudioSession.Category.playAndRecord)

         } catch let err{

             print("设置类型失败:\(err.localizedDescription)")

         }

         //设置session动作

         do {

             try session.setActive(true)

         } catch let err {

             print("初始化动作失败:\(err.localizedDescription)")

         }

         //录音设置，注意，后面需要转换成NSNumber，如果不转换，你会发现，无法录制音频文件，我猜测是因为底层还是用OC写的原因

         let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 16000),//采样率

                                             AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),//音频格式

                                             AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数

                                             AVNumberOfChannelsKey: NSNumber(value: 1),//通道数

                                             AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.high.rawValue)//录音质量

         ];

         //开始录音

         do {
            let file_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/\(school.description)\(student.description)\(Date()).wav")

             let url = URL(fileURLWithPath: file_path!)

             recorder = try AVAudioRecorder(url: url, settings: recordSetting)

             recorder!.prepareToRecord()

             recorder!.record()

             print("开始录音")
            

         } catch let err {

             print("录音失败:\(err.localizedDescription)")

         }

     }
    //结束录音

    func stopRecord() {
        let file_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/\(school.description)\(student.description)\(Date()).wav")

        if let recorder = self.recorder {

            if recorder.isRecording {

                print("正在录音，马上结束它，文件保存到了：\(file_path!)")

            }else {

                print("没有录音，但是依然结束它")

            }

            recorder.stop()

            self.recorder = nil

        }else {

            print("没有初始化")

        }

    }
    //播放

     func play() {

         do {
            let file_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/\(school.description)\(student.description)\(Date()).wav")
             player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: file_path!))

             print("歌曲长度：\(player!.duration)")

             player!.play()

         } catch let err {

             print("播放失败:\(err.localizedDescription)")

         }

     }
    
    @IBAction func logoutbtn(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginIDVC = storyBoard.instantiateViewController(withIdentifier: "loginID")
        present(loginIDVC, animated: true, completion: nil)
        
    }
    
    
    
    
}


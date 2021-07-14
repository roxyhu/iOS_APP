//
//  googlewavViewController.swift
//  iOS13OnDeviceSpeechRecognition
//
//  Created by 魏廷昇 on 2020/11/6.
//  Copyright © 2020 iowncode. All rights reserved.
//

import UIKit
import Speech

class googlewavViewController: UIViewController {

    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
    private var recognitionTask: SFSpeechRecognitionTask?
    var arr: Array<String> = []
    var receivedText:String = ""
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    
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
                            beginRecord()
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
                    stopRecord()
                    do {
                        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
                        try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                    } catch {
                        print("audioSession properties weren't set because of an error.")
                    }
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
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 300),
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
                    let url = URL(string: "http://140.125.32.128:5000/armbot")!
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
                            print(responseJSON["similar_words"]!)
                            DispatchQueue.main.async() {
                                
                                self.arr.insert(ret,at:0)
                                var count = 0
                                for num in self.arr{
                                    if(count==0){
//                                        self.history.text=""
                                    }
                                    count+=1
                                    print(num)
//                                    self.history.insertText(num)
//                                    self.history.insertText("\n")
                                }
                            }
                        }
                    }
                    task.resume()
                }
    func postwav(_ ret : String){
                
                    var ret = self.transcribedText.text!
        
                
                    let dic = "sender=user" + "&message=" + ret + "&bot=" + "1" + "&school=" + school + "&student=" +  student
                    let url = URL(string: "http://140.125.32.128:5000/armbot")!
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
                            print(responseJSON["similar_words"]!)
                            DispatchQueue.main.async() {
                                
                                self.arr.insert(ret,at:0)
                                var count = 0
                                for num in self.arr{
                                    if(count==0){
//                                        self.history.text=""
                                    }
                                    count+=1
                                    print(num)
//                                    self.history.insertText(num)
//                                    self.history.insertText("\n")
                                }
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
    
    
}

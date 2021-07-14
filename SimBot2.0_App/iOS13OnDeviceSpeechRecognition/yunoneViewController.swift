//
//  yunoneViewController.swift
//  iOS13OnDeviceSpeechRecognition
//
//  Created by 魏廷昇 on 2020/8/17.
//  Copyright © 2020 iowncode. All rights reserved.
//

import UIKit
import Speech
import Foundation



class yunoneViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    
    var tag:String?
    var receivedText:String = ""
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    var numOfRecorder: Int = 0
    var audioPlayer: AVAudioPlayer!
    var arr: Array<String> = []
    var brr: Array<String> = []
    var crr: Array<String> = []

//    let file_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/record.wav")
    

    @IBOutlet weak var tagview: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rotbotview: UITextView!
    @IBOutlet weak var history: UITextView!
    @IBOutlet weak var savebtn: UIButton!
    @IBOutlet weak var robothistory: UITextView!
    @IBOutlet weak var yunbotlogo: UIImageView!
    @IBOutlet weak var scorehistory: UITextView!
    
    
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_IN"))
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioSession: AVAudioSession!
    
    
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
                    finishRecording(success: true)
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
    
    public func delay(by delayTime: TimeInterval, qosClass: DispatchQoS.QoSClass? = nil,
                      _ closure: @escaping () -> Void) {
        let dispatchQueue = qosClass != nil ? DispatchQueue.global(qos: qosClass!) : .main
        dispatchQueue.asyncAfter(deadline: DispatchTime.now() + delayTime, execute: closure)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yunbotlogo.image = CommonDefine().getyunbotImage()
        buildUI()
        getPermissions()
        tagview.text = receivedText
        guard SFSpeechRecognizer.authorizationStatus() == .authorized
        else {
            print("guard failed...")
            return
    }
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.button
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
        
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
//                   button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                   button.widthAnchor.constraint(equalToConstant: 150)
               ]
           )
           

           NSLayoutConstraint.activate(
               [transcribedText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
                transcribedText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                transcribedText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                transcribedText.heightAnchor.constraint(equalToConstant: 100),
                transcribedText.centerXAnchor.constraint(equalTo: view.centerXAnchor)
               ]
           )
       }
    
    
    @IBAction func saverecord(_ sender: Any) {
        
        
    }
    
       func getDocumentsDirectory() -> URL {
           let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//            print(paths)
            
           return paths[0]
       }
        func finishRecording(success: Bool) {
            audioRecorder.stop()
            audioRecorder = nil

            if success {
//                recordButton.setTitle("Tap to Re-record", for: .normal)
                print("great")
            } else {
//                recordButton.setTitle("Tap to Record", for: .normal)
                // recording failed :(
                print("NOOOOOOOOO")
            }
        }
        func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
            if !flag {
                finishRecording(success: false)
            }
        }
       func startRecording() throws {

           recognitionTask?.cancel()
           self.recognitionTask = nil
            let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.mp4")
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            do {
                audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()

            } catch {
                finishRecording(success: false)
            }
           let audioSession = AVAudioSession.sharedInstance()
           try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
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
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return numOfRecorder
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
      
      cell.textLabel?.text = String(indexPath.row + 1)
      cell.detailTextLabel?.text = String("aaa")
      
      return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let recordFilePath = getDirectoryPath().appendingPathComponent("/record.wav")
      do {
        audioPlayer = try AVAudioPlayer(contentsOf: recordFilePath)
        audioPlayer.volume = 1.0
        play()
      } catch {
        print("Play error:", error.localizedDescription)
      }
    }
    func getDirectoryPath() -> URL {
      // create document folder url
      let fileDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
      return fileDirectoryURL
    }
    
    
    func post(_ ret : String){
            
                var ret = self.transcribedText.text!
    
            
                let dic = "sender=user" + "&message=" + ret + "&bot=" + receivedText + "&school=" + school + "&student=" +  student
                let url = URL(string: "http://140.125.32.128:5000/YunBot")!
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
                                    self.history.text=""
                                }
                                count+=1
                                print(num)
                                self.history.insertText(num)
                                self.history.insertText("\n")
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
                            
                            self.rotbotview.text = responseJSON["similar_words"]!
//                            self.history.insertText(ret)
//                            self.history.insertText("\n")
//                            self.robothistory.insertText(responseJSON["similar_words"]!)
//                            self.robothistory.insertText("\n")
//                            self.scorehistory.insertText(responseJSON["score"]!)
//                            self.scorehistory.insertText("\n")
                        }
                        
                    }
                    
                    
                    
                }
                task.resume()
            }
    
    
    
    func postFile(){
        let file_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/\(school.description)\(student.description)\(Date()).wav")
                    print("postFile>>>>>>>>>>>>")
                    print(file_path)
                    let url = URL(string: "http://140.125.32.128:5000/YunBot")!
                    var request = URLRequest(url: url) //request一個網路對象
                    request.httpMethod = "POST" //方法為：ＰＯＳＴ
//                    var boundary = generateBoundaryString();
//                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                    request.httpBodyStream = InputStream(fileAtPath: file_path!)
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in//發送出去
                        guard let data = data, error == nil else {
                            print(error?.localizedDescription ?? "No data")
                            return
                        }
                        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                        if let responseJSON = responseJSON as? [String: String] {
    //                        print(responseJSON["score"]!)
                            print(responseJSON["similar_words"]!)
//                            DispatchQueue.main.async() {
//                                self.rotbotview.text = responseJSON["similar_words"]!
//                                self.history.insertText(ret)
//                                self.history.insertText("\n")
//                                self.rotbothistory.insertText(responseJSON["similar_words"]!)
//                                self.rotbothistory.insertText("\n")
//                            }
                            
                        }
                        
                    }
                    task.resume()
                }
    
   func sessionUpload(){
       //上传地址
       let url = URL(string: "http://140.125.32.128:5000/YunBot")
       //请求
       var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData)
       request.httpMethod = "POST"
        
       let session = URLSession.shared
        
       //上传数据流
       let documents =  NSHomeDirectory() + "/Documents/1.png"
       let imgData = try! Data(contentsOf: URL(fileURLWithPath: documents))
        
        
       let uploadTask = session.uploadTask(with: request, from: imgData) {
           (data:Data?, response:URLResponse?, error:Error?) -> Void in
           //上传完毕后
           if error != nil{
               print(error)
           }else{
               let str = String(data: data!, encoding: String.Encoding.utf8)
               print("上传完毕：\(str)")
           }
       }
        
       //使用resume方法启动任务
       uploadTask.resume()
   }
    
    
    @IBAction func logoutbtn(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginIDVC = storyBoard.instantiateViewController(withIdentifier: "loginID")
        present(loginIDVC, animated: true, completion: nil)
    }
    
    
    
}


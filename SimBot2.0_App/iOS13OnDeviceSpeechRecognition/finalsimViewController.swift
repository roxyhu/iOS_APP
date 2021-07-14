//
//  finalsimViewController.swift
//  iOS13OnDeviceSpeechRecognition
//
//  Created by 魏廷昇 on 2020/8/19.
//  Copyright © 2020 iowncode. All rights reserved.
//

import UIKit
import Speech
import WebKit
//ＳＩＭＢＯＴ
class finalsimViewController: UIViewController {

    @IBOutlet weak var wordarray_text: UITextView!
    var player: AVAudioPlayer?
    var recorder: AVAudioRecorder?
    var receivedText:String = ""
    var audioPlayer:AVAudioPlayer!
    var arr: Array<String> = []
    var brr: Array<String> = []
    var crr: Array<String> = []
//    var drr: Array<String> = []
//    var frr: Array<String> = []
    var red_word: Array<String> = []
    var Me_red_word_array: Array<String> = []
    


    
    @IBOutlet weak var history: UITextView!
    @IBOutlet weak var robotview: UITextView!
    @IBOutlet weak var tagview: UITextView!
    @IBOutlet weak var savebtn: UIButton!
    @IBOutlet weak var simbotlogo: UIImageView!
    @IBOutlet weak var robothistory: UITextView!
    @IBOutlet weak var scorehistory: UITextView!
    
    @IBOutlet weak var robotlabel: UILabel!
    
    
    private let audioEngine = AVAudioEngine()
       private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
       private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_IN"))
       private var recognitionTask: SFSpeechRecognitionTask?
       
//       辨識區
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
//    麥克風按鈕
       
       let button:UIImageView = {
           let view = UIImageView()
           view.translatesAutoresizingMaskIntoConstraints = false
           view.image = UIImage(systemName: "mic.slash.fill")
           
           return view
       }()
//       麥克風開啟跟關閉
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
    
    func number(){
        var a = 0
        a += 1
        print(a)
    }
//    初始畫面只執行一次
    override func viewDidLoad() {
        super.viewDidLoad()
        simbotlogo.image = CommonDefine().getsimbotImage()
        let urlStr = "http://140.125.32.141:3000/master.html"
        if let url = URL(string: urlStr){
            let request = URLRequest(url: url)
           
        }
        tagview.text = receivedText
        buildUI()
        guard SFSpeechRecognizer.authorizationStatus() == .authorized
        else {
            print("guard failed...")
            return
        }
     
        
    }
//    圖片設定
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        tappedImage.image = UIImage(systemName: "mic.fill")
        micOn = !micOn
    }
//    用程式寫ＵＩ介面
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
//                button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
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
    
//    開始錄音副程式
  
    func startRecording() throws {

        recognitionTask?.cancel()
        self.recognitionTask = nil
        
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
//                呈現出來前端的地方
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
//    獲取麥克風權限
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
    
    
    
//    比對字串錯字用紅色attrs1錯字 attributedString1 2是正確語句歷史紀錄那邊  5 6使用者說過的紀錄
    
    let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor.red]
  
    let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor.black]
    var attributedString1 = NSMutableAttributedString(string:"")
    var attributedString2 = NSMutableAttributedString(string:"")
    var attributedString5 = NSMutableAttributedString(string:"")
    var attributedString6 = NSMutableAttributedString(string:"")
    func post(_ ret : String){
//        ＲＥＴ灰色辨識區塊
                    var ret = self.transcribedText.text!
                    
//                    3是正確語句重組12陣列  7為使用者紀錄重組56陣列
                    var attributedString3 = NSMutableAttributedString(string:"")
                    var attributedString7 = NSMutableAttributedString(string:"")
                    let dic = "sender=user" + "&message=" + ret + "&bot=" + receivedText + "&school=" + school + "&student=" +  student
                    let url = URL(string: "http://140.125.32.128:5000/rasaBotTest")!
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
//                            print(responseJSON["similar_words"]!)
//                            a為辨識語句 array斷詞存進陣列
                            var a = ret
                            var a_array = a.components(separatedBy: " ")
                            var a_array_set : Set = Set(a_array)
                            var b = responseJSON["similar_words"]!
                            var b_array = b.components(separatedBy: " ")
//                            兩個ＬＩＳＴ中的差異字
                            let eitherNeighborsOrEmployees = a_array_set.symmetricDifference(b_array)
//                            列出兩個ＬＩＳＴ中的差異字詞
                            print(eitherNeighborsOrEmployees)
                            print("typeres",type(of: responseJSON["similar_words"]!))
                            
                            for i in b_array{
                                for error_word in eitherNeighborsOrEmployees{
                                    //print(".......",j)
                                    if(i==error_word){
//                                        print(error_word)
                                        self.red_word.append(error_word)
//                                        print(type(of: self.red_word))
                                    }
                                }
                                    
                            }
                            for j in a_array{
                                for error_word in eitherNeighborsOrEmployees{
                                    //print(".......",j)
                                    if(j==error_word){
//                                        print(error_word)
                                        self.Me_red_word_array.append(error_word)
//                                        print(type(of: self.red_word))
                                        print("Me",self.Me_red_word_array)
                                    }
                                }
                                    
                            }
                            
//                            print(responseJSON["word_array"]!)
//                            print(responseJSON["word_array_num"]!)
                            
                            
                            print("red_word",self.red_word)
                            DispatchQueue.main.async() {
//                                self.arr.insert(ret,at:0)
//                                var count = 0
//                                for num in self.arr{
//                                    if(count==0){
//                                        self.history.text=""
//                                    }
//                                    count+=1
//                                    self.history.insertText(num)
//                                    self.history.insertText("\n")
//                                }
//                                您說過的紀錄紅字顯示部分
                                var isred_A = false
                                for p in a_array{
                                    for o in self.Me_red_word_array{
                                        if(p == o){
                                            isred_A = true
                                            break
                                        }else{
                                            isred_A = false
                                            
                                        }
                                    }
                                if(isred_A){
                                    self.attributedString5.append(NSMutableAttributedString(string:p, attributes:self.attrs1))
                                    self.attributedString5.append(NSMutableAttributedString(string:" ", attributes:self.attrs1))
                                    
                                }
                                else{
                                    self.attributedString5.append(NSMutableAttributedString(string:p, attributes:self.attrs2))
                                    self.attributedString5.append(NSMutableAttributedString(string:" ", attributes:self.attrs2))

                                }
                                print("i",p)
                                    
                                }
                                
                                self.attributedString5.append(NSMutableAttributedString(string:"\n", attributes:self.attrs2))
                                print("---------type", type(of: self.attributedString5))
                                self.history.attributedText = attributedString7
                                
                              
                                
                                self.Me_red_word_array.removeAll()
                                self.arr.insert(ret,at:0)
                                self.attributedString6.insert(self.attributedString5, at: 0)
                                attributedString7.insert(self.attributedString6, at: 0)
                                
                                
                                self.history.attributedText = attributedString7
                                self.attributedString5 = NSMutableAttributedString(string:"")
                                
                                print("9999", self.attributedString5)
                                print("7777",self.attributedString2)
                                print(attributedString7)
                                
                                
                                
                                
                                
                                
                                
//                                正確語句組合紅字顯示 初始值為沒有紅字 b_array為伺服器正確語句
                                
                                var isred = false
                                for i in b_array{
                                    for j in self.red_word{
                                        if(i == j){
                                            isred = true
                                            break
                                        }else{
                                            isred = false
                                            
                                        }
                                    }
                                if(isred){
                                    self.attributedString1.append(NSMutableAttributedString(string:i, attributes:self.attrs1))
                                    self.attributedString1.append(NSMutableAttributedString(string:" ", attributes:self.attrs1))
                                    
                                }
                                else{
                                    self.attributedString1.append(NSMutableAttributedString(string:i, attributes:self.attrs2))
                                    self.attributedString1.append(NSMutableAttributedString(string:" ", attributes:self.attrs2))

                                }
                                print("i",i)
                                    
                                }
                                
                                self.attributedString1.append(NSMutableAttributedString(string:"\n", attributes:self.attrs2))
                                print("---------type", type(of: self.attributedString1))
//                                    self.robothistory.insertText(numb)
                                self.robotlabel.attributedText = attributedString3
                                
                              
                                
                                self.red_word.removeAll()
//                                    self.brr.removeAll()
//                                    b_array.removeAll()
//                                print("redword",self.red_word)
//                                print("numb",numb)
//                                print("brr",self.brr)
                                self.brr.insert(responseJSON["similar_words"]!,at:0)
                                self.attributedString2.insert(self.attributedString1, at: 0)
//                                attributedString2.append(self.attributedString1)
                                attributedString3.insert(self.attributedString2, at: 0)
                                
                                
                                self.robothistory.attributedText = attributedString3
                                self.attributedString1 = NSMutableAttributedString(string:"")
                                
                                print("---------00", self.attributedString1)
                                print("2",self.attributedString2)
                                
                                var a = 0
                                for numb in self.brr{
                                    if(a==0){
//                                        self.robothistory.text=""
                                    }
                                    a+=1
                                    
                                }
                                
                  

                                self.crr.insert(responseJSON["score"]!,at:0)
                                var b = 0
                                for numc in self.crr{
                                    if(b==0){
                                        self.scorehistory.text=""
                                    }
                                    b+=1
//                                    print(numc)
                                    self.scorehistory.insertText(numc)
                                    self.scorehistory.insertText("\n")
                                }
//                                    let attributedString1 = NSMutableAttributedString(string:ret, attributes:attrs1)

                                    
                                
                                self.robotview.text = responseJSON["similar_words"]!

                                
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
    
    @IBAction func logout(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginIDVC = storyBoard.instantiateViewController(withIdentifier: "loginID")
        present(loginIDVC, animated: true, completion: nil)
    }
    
    
    
    
}

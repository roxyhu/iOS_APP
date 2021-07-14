//
//  SimpleChatViewController.swift
//  NoChatExample
//
//  Created by yinglun on 2020/8/15.
//  Copyright © 2020 little2s. All rights reserved.
//

import UIKit
import NoChat
import Speech
var post_res = ""
var text_input = ""
var mic_input = ""
var wordd = ""
class SimpleChatViewController: ChatViewController, UITextViewDelegate {
    
    private let dataSource = SimpleChatDataSource()
    
    private var inputCoordinator: SimpleInputCoordinator!
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
    private var recognitionTask: SFSpeechRecognitionTask?
    let button:UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "mic.slash.fill")
        
        return view
    }()
    var transcribedText:UITextView = {
       let view = UITextView()
       view.translatesAutoresizingMaskIntoConstraints = false
       view.layer.cornerRadius = 15
       view.layer.masksToBounds = true
       view.textColor = .black
       view.font = UIFont.systemFont(ofSize: 25)
       view.backgroundColor = .lightGray
       return view
   }()
    var rect: CGRect?
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            /* 開始輸入時，將輸入框實體儲存 */
            transcribedText = textView
        }
    
    
    
    var micOn : Bool = false{
        didSet{
            if micOn{
                button.image = UIImage(systemName: "mic.fill")
                        do{
                            self.transcribedText.text = ""
                            try self.startRecording()
//                            SimpleInputPanel().inputField.text = self.transcribedText.text
                            
                            
                        }catch(let error){
                            print("error is \(error.localizedDescription)")
                        }
            }
            else{
                if audioEngine.isRunning {
                    recognitionRequest?.endAudio()
                    audioEngine.stop()
                    
                    do {
                        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
                        try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                    } catch {
                        print("audioSession properties weren't set because of an error.")
                    }
                    
                }
                mic_input = self.transcribedText.text
                
            
//                let msg = Message.text(from: "me", content: self.transcribedText.text)
//                print("mic",msg)
//                dataSource.send(message: msg)
                
                
                button.image = UIImage(systemName: "mic.slash.fill")
            }
        }
    }
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.inputPanel = SimpleInputPanel()
        self.inputPanelDefaultHeight = SimpleInputPanel.Layout.baseHeight
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "YunTech AI715Bot"
        inputCoordinator = SimpleInputCoordinator(chatViewController: self)
        dataSource.chatViewController = self
        buildUI()
        getPermissions()
        guard SFSpeechRecognizer.authorizationStatus() == .authorized
        else {
            print("guard failed...")
            return
        }
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
        /* 將 View 原始範圍儲存 */
        rect = view.bounds
        
        
    }
    
    
    @objc func keyboardWillShow(note: NSNotification) {
        if transcribedText == nil {
            return
        }
        
        let userInfo = note.userInfo!
        /* 取得鍵盤尺寸 */
        let keyboard = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        /* 取得焦點輸入框的位置 */
        let origin = (transcribedText.frame.origin)
        /* 取得焦點輸入框的高度 */
        let height = (transcribedText.frame.size.height)
        /* 計算輸入框最底部Y座標，原Y座標為上方位置，需要加上高度 */
        let targetY = origin.y + height
        /* 計算扣除鍵盤高度後的可視高度 */
        let visibleRectWithoutKeyboard = self.view.bounds.size.height - keyboard.height
        
        /* 如果輸入框Y座標在可視高度外，表示鍵盤已擋住輸入框 */
        if targetY >= visibleRectWithoutKeyboard {
            var rect = self.rect!
            /* 計算上移距離，若想要鍵盤貼齊輸入框底部，可將 + 5 部分移除 */
            rect.origin.y -= (targetY - visibleRectWithoutKeyboard) + 5
            
            UIView.animate(
                withDuration: duration,
                animations: { () -> Void in
                    self.view.frame = rect
                }
            )
        }
    }
     
    @objc func keyboardWillHide(note: NSNotification) {
        /* 鍵盤隱藏時將畫面下移回原樣 */
        let keyboardAnimationDetail = note.userInfo as! [String: AnyObject]
        let duration = TimeInterval(truncating: keyboardAnimationDetail[UIResponder.keyboardAnimationDurationUserInfoKey]! as! NSNumber)
        
        UIView.animate(
            withDuration: duration,
            animations: { () -> Void in
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -self.view.frame.origin.y)
            }
        )
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
             button.heightAnchor.constraint(equalToConstant: 50),
             button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 830),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 50)
            ]
        )
        

        NSLayoutConstraint.activate(
            [transcribedText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 890),
//             transcribedText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//             transcribedText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
             transcribedText.heightAnchor.constraint(equalToConstant: 60),
//             transcribedText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             transcribedText.widthAnchor.constraint(equalToConstant: 700)
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
                        var lastString: String = ""
                        for segment in result.bestTranscription.segments {
                            let indexTo = transcribedString.index(transcribedString.startIndex, offsetBy: segment.substringRange.location)
                            lastString = transcribedString.substring(from: indexTo)
                            print("segmen",segment)
                        }
                        
//                    SimpleInputPanel().inputField.internalTextView.text = (transcribedString)
                    
                        
                    
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

    
}

extension SimpleChatViewController: SimpleInputPanelDelegate {

    
    func didInputTextPanelStartInputting(_ inputTextPanel: SimpleInputPanel) {
        if !collectionView.isScrolledAtBottom {
            collectionView.scrollToBottom(animated: true)
        }
    }
    func isBlank(_ string: String) ->Bool{
        for character in string{
            if !character.isWhitespace{
                return false
            }
        }
        return true
    }
    
    
//    func inputTextPanel(_ inputTextPanel: SimpleInputPanel, requestSendText text: String) {
//        let msg = Message.text(from: "me", content: mic_input )
//        text_input = text
//        print("mic",mic_input)
//        if transcribedText.text != ""{
//            dataSource.send(message: msg)
//        }
//
//    }
    
    
    func inputTextPanel(_ inputTextPanel: SimpleInputPanel, requestSendText text: String) {
        wordd = transcribedText.text
        let msg = Message.text(from: "me", content: wordd )
        text_input = text
        print("mic",mic_input)

        print(type(of: wordd))
        print("count: ", wordd.count)
        if wordd != "" && wordd != " " {
            dataSource.send(message: msg)
        }
        
    }
}


class SimpleChatDataSource {
    var arr: Array<String> = []
    var crr: Array<String> = []
    
    weak var chatViewController: SimpleChatViewController?
    
    private let layoutQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        queue.name = "simple-chat-layout"
        return queue
    }()
    
    func loadMessages(_ post_res : String) {
        
        let messages: [Message] = [
            Message.text(from: "bot", content: post_res)
        ]
        appendMessages(messages, scrollToBottom: true, animated: false, isLoad: true)
    }
    
    func send(message: Message) {
//        var post_res = ""
        let ret = wordd
//        let dic = "sender=user" + "&message=" + ret
        let dic = "sender=user" + "&message=" + ret + "&bot=" + bot + "&school=" + school + "&student=" +  student
        let url = URL(string: "http://140.125.32.128:5000/rasaBot")!
        var request = URLRequest(url: url) //request一個網路對象
        request.httpMethod = "POST" //方法為：ＰＯＳＴ
        request.httpBody = dic.data(using: .utf8, allowLossyConversion: true)!//請求內容為 dic.data
        print(dic)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in //發送出去
           
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let responseJSON = responseJSON as? [String: String] {
//                        print(responseJSON["score"]!)
                
                post_res = responseJSON["type"]!
                
            }
        }
        task.resume()
        while true{
            if(post_res != ""){
                appendMessages([message], scrollToBottom: true, animated: true)
                
                loadMessages(post_res)
                
                print("post", post_res)
                
                let Discourse = AVSpeechUtterance (string: post_res)
                let synthesizer = AVSpeechSynthesizer()
                Discourse.rate = 0.4
                Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
                synthesizer.speak(Discourse)
                print("12334234")
                
                post_res = ""
                
                break;
                
                
                
            }
            
        }
        
    }
    public func delay(by delayTime: TimeInterval, qosClass: DispatchQoS.QoSClass? = nil,
                      _ closure: @escaping () -> Void) {
        let dispatchQueue = qosClass != nil ? DispatchQueue.global(qos: qosClass!) : .main
        dispatchQueue.asyncAfter(deadline: DispatchTime.now() + delayTime, execute: closure)
    }
    private func appendMessages(_ messages: [Message], scrollToBottom: Bool, animated: Bool, isLoad: Bool = false) {
        guard let vc = self.chatViewController else { return }
        let width = vc.cellWidth
        layoutQueue.addOperation { [weak vc] in
            guard let strongVC = vc else { return }
            let count = strongVC.layouts.count
            var insertLayouts = [AnyItemLayout]()
            for message in messages {
                var layout = TextMessageLayout(item: message)
                layout.calculate(preferredWidth: width)
                insertLayouts.append(layout.toAny())
            }
            let insertIndexPathes: [IndexPath] = (count ..< (count + insertLayouts.count)).map { IndexPath(item: $0, section: 0) }
            OperationQueue.main.addOperation {
                strongVC.layouts.append(contentsOf: insertLayouts)
                strongVC.collectionView.performChange(.init(insertIndexPathes: insertIndexPathes), animated: animated)
                if scrollToBottom {
                    strongVC.collectionView.scrollToBottom(animated: animated)
                }
            }
        }
    }
    
    
    
    
    
    
   
    
}

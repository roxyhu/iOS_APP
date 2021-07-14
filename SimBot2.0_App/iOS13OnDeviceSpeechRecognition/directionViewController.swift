//
//  directionViewController.swift
//  iOS13OnDeviceSpeechRecognition
//
//  Created by 魏廷昇 on 2020/9/17.
//  Copyright © 2020 iowncode. All rights reserved.
//

import UIKit
import Speech

class directionViewController: UIViewController {
    
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    
    
    @IBOutlet weak var forwardimg: UIImageView!
    @IBOutlet weak var leftimg: UIImageView!
    @IBOutlet weak var rightimg: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forwardimg.image = CommonDefine().getgoforwardImage()
        leftimg.image = CommonDefine().getturnleftImage()
        rightimg.image = CommonDefine().getturnrightImage()
        
        recognitionRequest?.endAudio()
        audioEngine.stop()
        recognitionTask = nil
        audioEngine.inputNode.removeTap(onBus:0)
        audioEngine.reset()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func forward(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Go forward")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
    }
    
    @IBAction func ahead(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Go ahead")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
    }
    
    @IBAction func straight(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Go straight")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
    }
    
    @IBAction func left(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Turn left")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
        
    }
    
    @IBAction func right(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Turn right")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
    }
    
}

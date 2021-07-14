//
//  listenarmbotViewController.swift
//  iOS13OnDeviceSpeechRecognition
//
//  Created by 魏廷昇 on 2020/9/17.
//  Copyright © 2020 iowncode. All rights reserved.
//

import UIKit
import Speech

class listenarmbotViewController: UIViewController {
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    
    @IBOutlet weak var forwardimg: UIImageView!
    @IBOutlet weak var backwardimg: UIImageView!
    @IBOutlet weak var m_leftimg: UIImageView!
    @IBOutlet weak var m_rightimg: UIImageView!
    @IBOutlet weak var t_leftimg: UIImageView!
    @IBOutlet weak var t_rightimg: UIImageView!
    @IBOutlet weak var getimg: UIImageView!
    @IBOutlet weak var putimg: UIImageView!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forwardimg.image = CommonDefine().getgoforwardImage()
        backwardimg.image = CommonDefine().getbackwardImage()
        m_leftimg.image = CommonDefine().getmoveleftImage()
        m_rightimg.image = CommonDefine().getmoverightImage()
        t_leftimg.image = CommonDefine().getturnleftImage()
        t_rightimg.image = CommonDefine().getturnrightImage()
        getimg.image = CommonDefine().getget_blockImage()
        putimg.image = CommonDefine().getput_blockImage()
        // Do any additional setup after loading the view.
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
    }
    

    @IBAction func forwardclick(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Move forward")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
    }
    
    @IBAction func backwardclick(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Move backward")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
    }
    
    @IBAction func mleftclick(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Move left")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
    }
    
    @IBAction func mrightclick(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Move right")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
    }
    
    @IBAction func tleftclick(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Turn left")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
    }
    @IBAction func trightimg(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Turn right")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
    }
    
    @IBAction func getclick(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Get the block")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
    }
    @IBAction func putclick(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Put down the block")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
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

//
//  locationViewController.swift
//  iOS13OnDeviceSpeechRecognition
//
//  Created by 魏廷昇 on 2020/9/17.
//  Copyright © 2020 iowncode. All rights reserved.
//

import UIKit
import Speech
class locationViewController: UIViewController {
    private let audioEngine = AVAudioEngine()
       private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
       private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
       private var recognitionTask: SFSpeechRecognitionTask?
       private var audioSession: AVAudioSession!
       var audioRecorder: AVAudioRecorder!
    
    
    @IBOutlet weak var libraryimg: UIImageView!
    @IBOutlet weak var parkimg: UIImageView!
    @IBOutlet weak var supermarketimg: UIImageView!
    @IBOutlet weak var poolimg: UIImageView!
    @IBOutlet weak var schoolimg: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        libraryimg.image = CommonDefine().getlibraryImage()
        parkimg.image = CommonDefine().getparkImage()
        supermarketimg.image = CommonDefine().getsupermarketImage()
        poolimg.image = CommonDefine().getpoolImage()
        schoolimg.image = CommonDefine().getschoolImage() 
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
    
    @IBAction func library(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Go to the library")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
    }
    
    @IBAction func park(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Go to the park")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
    }
    
    @IBAction func pool(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Go to the pool")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
    }
    
    @IBAction func supermarket(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Go to the supermarket")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
    }
    
    @IBAction func school(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Go to the school")
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

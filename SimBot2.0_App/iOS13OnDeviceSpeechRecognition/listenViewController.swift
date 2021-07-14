//
//  listenViewController.swift
//  iOS13OnDeviceSpeechRecognition
//
//  Created by 魏廷昇 on 2020/9/8.
//  Copyright © 2020 iowncode. All rights reserved.
//

import UIKit
import Speech

class listenViewController: UIViewController {
    
    
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var logoutbtn: UIButton!
    @IBOutlet weak var go_forward: UIButton!
    @IBOutlet weak var go_ahead: UIButton!
    @IBOutlet weak var go_straight: UIButton!
    @IBOutlet weak var turn_left: UIButton!
    @IBOutlet weak var Turn_right: UIButton!
    @IBOutlet weak var supermarket: UIButton!
    @IBOutlet weak var park: UIButton!
    @IBOutlet weak var school: UIButton!
    @IBOutlet weak var library: UIButton!
    @IBOutlet weak var pool: UIButton!
    @IBOutlet weak var move_forward: UIButton!
    @IBOutlet weak var move_backward: UIButton!
    @IBOutlet weak var move_left: UIButton!
    @IBOutlet weak var move_right: UIButton!
    @IBOutlet weak var getblock: UIButton!
    @IBOutlet weak var putblock: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func go_forward_btn(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Go forward")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
        print("12334234")
        
    }
    
    @IBAction func go_ahead_btn(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Go ahead")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
        print("12334234")
    }
    
    @IBAction func go_straight_btn(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Go straight")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
        print("12334234")
    }
    
    @IBAction func turn_left_btn(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Turn left")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
        print("12334234")
    }
    
    @IBAction func turn_right(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Turn right")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
        print("12334234")
    }
    @IBAction func supermarket_btn(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Go to the supermarket")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
        print("12334234")
    }
    @IBAction func park_btn(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Go to the park")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
        print("12334234")
    }
    @IBAction func school_btn(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Go to the school")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
        print("12334234")
    }
    @IBAction func library_btn(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Go to the library")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
        print("12334234")
    }
    @IBAction func pool_btn(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Go to the pool")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
        print("12334234")
    }
    @IBAction func move_forward_btn(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Move forward")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
        print("12334234")
    }
    @IBAction func move_backward_btn(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Move backward")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
        print("12334234")
    }
    @IBAction func move_left_btn(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Move left")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
        print("12334234")
    }
    @IBAction func move_right_btn(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Move right")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
        print("12334234")
    }
    @IBAction func get_the_block(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Get the block")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
        print("12334234")
    }
    @IBAction func put_down_the_block(_ sender: Any) {
        let Discourse = AVSpeechUtterance (string: "Put down the block")
        let synthesizer = AVSpeechSynthesizer()
        Discourse.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(Discourse)
        print("12334234")
    }
    
    
    
    
    
    
    
    @IBAction func logoutclick(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginIDVC = storyBoard.instantiateViewController(withIdentifier: "loginID")
            present(loginIDVC, animated: true, completion: nil)
        
    }
    
}

//
//  PlaySoundsViewController.swift
//  Pitch Perfect 
//
//  Created by Shanmathi Mayuram Krithivasan on 11/20/15.
//  Copyright © 2015 Shanmathi Mayuram Krithivasan. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var receivedAudio:RecordedAudio!
    var player = AVAudioPlayer()
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        audioFile = try? AVAudioFile(forReading: receivedAudio.filePathUrl)
        do {
            player = try AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
            player.enableRate = true
        } catch _ {
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func play(){
        audioEngine.stop()
        player.stop()
        player.currentTime = 0
         player.play()
        
    }
    
       @IBAction func playFast(sender: AnyObject) {
        player.rate = 2 //Play twice as fast
        play();
    }
   
    @IBAction func playSlow(sender: AnyObject) {
        player.rate = 0.5 //Play twice as slow
        play();
    }
   
    @IBAction func stopPlay(sender: AnyObject) {
        stopPlayerAndEngine()
    }
   
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        stopPlayerAndEngine()
        playAudioWithVariablePitch(1000)
    }

    @IBAction func playDarthvaderAudio(sender: AnyObject) {
        stopPlayerAndEngine()
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playReverbAudio(sender: AnyObject) {
        stopPlayerAndEngine()
        playAudioWithReverb()
    }
    
    @IBAction func playEchoAudio(sender: AnyObject) {
        stopPlayerAndEngine()
        playAudioWithEcho()
        
    }
    
 
    func stopPlayerAndEngine(){
        player.stop()
        audioEngine.stop()
    }
    

    func playAudioWithVariablePitch(pitch: Float){
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        playWithEffect(changePitchEffect)
    }
    
       func playAudioWithReverb(){
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(.LargeHall)
        playWithEffect(reverbEffect)
    }
    
       func playAudioWithEcho(){
        let echoEffect = AVAudioUnitDistortion()
        echoEffect.loadFactoryPreset(.MultiEcho1)
        playWithEffect(echoEffect)
    }
    
   
    func playWithEffect( effect:AVAudioUnit){
        player.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(effect)
        
        
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch _ {
        }
        
        audioPlayerNode.play()
    }
    
}
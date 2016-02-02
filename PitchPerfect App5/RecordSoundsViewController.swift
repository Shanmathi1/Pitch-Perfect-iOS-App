//
//  ViewController.swift
//  Pitch Perfect 
//
//  Created by Shanmathi Mayuram Krithivasan on 11/20/15.
//  Copyright © 2015 Shanmathi Mayuram Krithivasan. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    
    @IBAction func recordAUdio(sender: UIButton) {
        
        if (pauseButton.enabled){
            recordButton.enabled = false
            pauseButton.enabled = true
            recordingInProgress.text = "Recording in Progress"
            recordingInProgress.hidden = false
            stopButton.hidden = false
            pauseButton.hidden = false
            print("in record audio")
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String 
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            
            let session = AVAudioSession.sharedInstance()
            
            
            do {
                try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            } catch _ {
            } 
            let s = [String:AnyObject]()
            audioRecorder = try? AVAudioRecorder(URL: filePath!, settings: s)
            
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }else{
            recordingInProgress.text = "Recording"
            pauseButton.enabled = true
            audioRecorder.record()
        }
    }

    @IBAction func pauseRecording(sender: UIButton) {
        if(audioRecorder.recording){
            audioRecorder.pause()
            recordingInProgress.text = "Tap to Resume Recording"
            recordButton.enabled = true
            pauseButton.enabled = false
        }else{
            recordingInProgress.text = "Recording"
            pauseButton.enabled = true
            audioRecorder.record()
        }
    }
    
    
    func audioRecorderBeginInterruption(recorder: AVAudioRecorder) {
        print(audioRecorder.recording, terminator: "")
    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            //Save Recording Audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url,title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    

    @IBAction func stopRecording(sender: AnyObject) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        recordingInProgress.text = "Tap icon to Record"
        recordingInProgress.hidden = false
        recordButton.enabled = true
        stopButton.hidden = true
        pauseButton.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}



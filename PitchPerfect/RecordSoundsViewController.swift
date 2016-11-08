//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Yang Gao on 10/13/16.
//  Copyright © 2016 Yang Gao. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecording: UIButton!
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecording.isEnabled = false
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func configureUI(recording: Bool){
        recordingLabel.text = recording ? "Recording in progress" : "Tap to Record"
        recordButton.isEnabled = !recording
        stopRecording.isEnabled = recording
    }
   
    @IBAction func stopRecording(_ sender: AnyObject) {
        configureUI(recording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    @IBAction func recordAudio(_ sender: AnyObject) {
        configureUI(recording: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AVAudioRecorder finished saving recording")
        if(flag){
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("Saving of recording failed")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}


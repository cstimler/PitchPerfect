//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by June2020 on 3/21/21.
//

import UIKit
import AVFoundation

/**
 RecordSoundsViewController manages the Screen #1 (opening screen)
 which contains a record button, stop button, and a record label.
 */

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    // here are the 3 elements that will have to change their values or properties dynamically:
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // when the view has loaded we must be sure that the stop recording button is not enabled
        stopRecordingButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /**
     recordAudio( ) sets up the audioRecorder, defines the .wav file destination, and starts the recorder running.
     */
    
    @IBAction func recordAudio(_ sender: Any) {
        setUpButtons(recording: true);
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true
        )[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        setUpButtons(recording: false);
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func setUpButtons(recording: Bool) {
        stopRecordingButton.isEnabled = recording
        recordButton.isEnabled = !recording
        recordingLabel.text = recording ? "Recording in Progress" : "Tap to Record"
        }

    
    
    /**
     * audioRecorderDidFinishRecording passes the reference of the recording url to the next screen via
     * a "performSegue" method.
     *
     */
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    /**
     *func prepare( ) identifies the next destination as "PlaySoundsViewController" and informs the next view that the audioRecorder passed is as a URL.
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"  {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    

}

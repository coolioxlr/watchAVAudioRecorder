//
//  InterfaceController.swift
//  WatchAVAudioRecorder WatchKit Extension
//
//  Created by Ethan Fan on 3/7/18.
//  Copyright © 2018 Vimo Labs. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation

class InterfaceController: WKInterfaceController{
    
    @IBOutlet var statusLabel: WKInterfaceLabel!
    @IBOutlet var recordingBtn: WKInterfaceButton!
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    @IBAction func recordingClicked() {
        if audioRecorder == nil {

            
            let recordingName = "fx1.m4a"
            let dirPath = getDirectory()
            let pathArray = [dirPath, recordingName]
            let filePath = URL(string: pathArray.joined(separator: "/"))
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                            AVSampleRateKey:12000,
                            AVNumberOfChannelsKey:1,
                            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            //start recording
            
            do {
                audioRecorder = try AVAudioRecorder(url: filePath!, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                recordingBtn.setTitle("Stop Recording")
                statusLabel.setText("Start Recording")

                
                
            } catch {
                displayAlert(title: "Recording Failed", message: error.localizedDescription)
            }
            
        }
        else {
            //if audio is in session
            audioRecorder.stop()
            audioRecorder = nil
            recordingBtn.setTitle("Start Recording")
        }
    }
    
    @IBAction func playLastRecording() {
        let dirPathAsFileURL = URL(fileURLWithPath: getDirectory())
        let path = dirPathAsFileURL.appendingPathComponent("fx1.m4a")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.delegate = self
            audioPlayer.play()
            self.statusLabel.setText("Start playing")
        } catch {
            displayAlert(title: "Play Failed", message: error.localizedDescription)
        }
    }
    
    
    func displayAlert(title: String, message: String){
        let action = WKAlertAction.init(title: "Cancel", style:.cancel) {
            print("cancel action")
        }
        
        presentAlert(withTitle: title, message: message, preferredStyle:.alert, actions: [action])
    }
    
    func getDirectory()-> String {
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] //as String
        
        return dirPath
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

extension InterfaceController : AVAudioRecorderDelegate{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        statusLabel.setText("Finished Recording")
    }
}

extension InterfaceController : AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        statusLabel.setText("Finished playing")
    }
}

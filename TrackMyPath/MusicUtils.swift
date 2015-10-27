//
//  MusicUtils.swift
//  TrackMyPath
//
//  Created by Sridhar Murali on 10/27/15.
//  Copyright © 2015 Sridhar Murali. All rights reserved.
//

import Foundation
import AVFoundation

class MusicUtils{
    
    static var filePath:String?
    static private var audioPlayer:AVAudioPlayer?
    static private var isInitilized = false
    static var audioEngine:AVAudioEngine!
    static var audioFile:AVAudioFile!
    
    static let maxRate = 2.0
    static let minRate = 0.1
    static let normalRate = 1.0
    
    static func initialize(){
      filePath = NSBundle.mainBundle().pathForResource("mohanam", ofType: "mp3")
      let filePathUrl = NSURL.fileURLWithPath(filePath!)
        audioPlayer = try!
            AVAudioPlayer(contentsOfURL: filePathUrl)
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: filePathUrl)
        
        isInitilized = true
        audioPlayer!.enableRate = true
        audioPlayer!.numberOfLoops = 100
        isInitilized = true
    }
    
    static func ChangeSong(id:Int = 0)-> Bool{
        return false
    }
    
    static func play()-> Bool{
        if !isInitilized{
            initialize()
        }
        audioPlayer!.rate = 3.0
        if audioPlayer!.playing{
            return true
        }else{
            return audioPlayer!.play()
        }
    }
    
    static func pause(){
        if !isInitilized{
            initialize()
        }
        audioPlayer!.pause()
    }
    
    static func speedUp(speedRate:Double){
        if !isInitilized{
            initialize()
        }
        audioPlayer!.rate =  (Double(audioPlayer!.rate ) + (0.1 * speedRate)) > maxRate ? 2.0 :  (audioPlayer!.rate + Float(0.1 * speedRate))
        print("Speed up to \(audioPlayer!.rate)")
    }
    
    static func slowDown(speedRate:Double){
        if !isInitilized{
            initialize()
        }
        audioPlayer!.rate =  (Double(audioPlayer!.rate ) - (0.1 * speedRate)) <= minRate ? 0.1 :  (audioPlayer!.rate - Float(0.1 * speedRate))
        print("Speed down to \(audioPlayer!.rate)")
    }
    

    static func pitchUp(){
        if !isInitilized{
            initialize()
        }
        playAudioWithVariablePitch(1000)
    }
    
    static func pitchDown(){
        playAudioWithVariablePitch(-1000)
    }
    
    static func stop(){
        if !isInitilized{
            initialize()
        }
        audioPlayer!.stop()
    }
    static func playNormal() -> Bool{
        if !isInitilized{
            initialize()
        }
        audioPlayer!.rate = 1.0
        print("Speed @ \(audioPlayer!.rate)")
        if audioPlayer!.playing{
            
            return true
        }else{
            return audioPlayer!.play()
        }
    }
    
    static func playAudioWithVariablePitch(pitch: Float){
        audioPlayer!.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
}

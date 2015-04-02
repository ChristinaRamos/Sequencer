//
//  ViewController.swift
//  Sequencer
//
//  Created by Christina Ramos on 3/31/15.
//  Copyright (c) 2015 Christina Ramos. All rights reserved.
//

import AVFoundation
import SpriteKit
import UIKit

class ViewController: UIKit.UIViewController {

    @IBOutlet var totalTextField : UITextField!
    var drums : Drums = Drums()
    var playing : Bool = false
    
    var snare = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("snare-808", ofType: "wav")!)!
    var kick = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("kick-808", ofType: "wav")!)!
    var hat = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("hihat-808", ofType: "wav")!)!
    var cymbal = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("crash-808", ofType: "wav")!)!

    var audioPlayer = AVAudioPlayer()
    
    // Trigger the sound effect when the player grabs the coin
    func playBeat(drumType: NSURL) {
        audioPlayer = AVAudioPlayer(contentsOfURL: drumType, error: nil)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func playSequence() {
        var pos = 0
        while playing {
            if(drums.kick[pos]) {playBeat(kick)}
            if(drums.snare[pos]) {playBeat(snare)}
            if(drums.hat[pos]) {playBeat(hat)}
            if(drums.cymbal[pos]) {playBeat(cymbal)}
            
            pos = (pos + 1) % 16
            
            println(pos)
            
            usleep(100000)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func noteTapped(sender : AnyObject) {
        let i = sender.tag!
        switch i {
            case 0...15: drums.snare[i] = !sender.isOn
            case 16...31: drums.kick[i % 16] = !sender.isOn
            case 32...47: drums.hat[i % 16] = !sender.isOn
            default: drums.cymbal[i % 16] = !sender.isOn
        }
    }
    
    @IBAction func playTapped(sender : AnyObject) {
        playing = !sender.isOn
        if playing {
            let thread = NSThread(target: self, selector: "playSequence", object: nil)
            thread.start()
        }
    }
    
    struct Drums {
        var snare : [Bool]
        var kick : [Bool]
        var hat : [Bool]
        var cymbal : [Bool]
        
        init() {
            snare  = [Bool] (count: 16, repeatedValue: false)
            kick   = [Bool] (count: 16, repeatedValue: false)
            hat    = [Bool] (count: 16, repeatedValue: false)
            cymbal = [Bool] (count: 16, repeatedValue: false)
        }
    }
}


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

class ViewController: UIKit.UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet var totalTextField : UITextField!
    @IBOutlet var collectionOfSnares: Array<CheckBox>!
    @IBOutlet var collectionOfKicks: Array<CheckBox>!
    @IBOutlet var collectionOfHats: Array<CheckBox>!
    @IBOutlet var collectionOfCymbals: Array<CheckBox>!
    @IBOutlet weak var pickerView : UIPickerView!
    
    var pd : [String] = ["apple","pie"]
    
    var drums : Drums = Drums()
    var playing : Bool = false
    
    var snare = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("snare-808", ofType: "wav")!)!
    var kick = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("kick-808", ofType: "wav")!)!
    var hat = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("hihat-808", ofType: "wav")!)!
    var cymbal = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("crash-808", ofType: "wav")!)!

    var snarePlayer = AVAudioPlayer()
    var kickPlayer = AVAudioPlayer()
    var hatPlayer = AVAudioPlayer()
    var cymbalPlayer = AVAudioPlayer()
    
    var sequenceDict : [String : Drums] = [:]
    
    let file = "sequencer_saves.txt"
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sequenceDict.keys.array.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return sequenceDict.keys.array[row]
    }
    
    // Trigger the sound effect when the player grabs the coin
    func playSnare() {
        snarePlayer = AVAudioPlayer(contentsOfURL: snare, error: nil)
        snarePlayer.prepareToPlay()
        snarePlayer.play()
    }
    
    func playKick() {
        kickPlayer = AVAudioPlayer(contentsOfURL: kick, error: nil)
        kickPlayer.prepareToPlay()
        kickPlayer.play()
    }
    
    func playHat() {
        hatPlayer = AVAudioPlayer(contentsOfURL: hat, error: nil)
        hatPlayer.prepareToPlay()
        hatPlayer.play()
    }
    
    func playCymbal() {
        cymbalPlayer = AVAudioPlayer(contentsOfURL: cymbal, error: nil)
        cymbalPlayer.prepareToPlay()
        cymbalPlayer.play()
    }
    
    func playSequence() {
        var pos = 0
        while playing {
            if(drums.kick[pos]) {playKick()}
            if(drums.snare[pos]) {playSnare()}
            if(drums.hat[pos]) {playHat()}
            if(drums.cymbal[pos]) {playCymbal()}
            
            pos = (pos + 1) % 16
            
            usleep(100000)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let documentDirectoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        let fileDestinationUrl = documentDirectoryURL.URLByAppendingPathComponent("file.txt")

        if let mytext = String(contentsOfURL: fileDestinationUrl, encoding: NSUTF8StringEncoding, error: nil) {
            sequenceDict = parseFileString(mytext)
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func parseFileString(fileStr : String) -> [String : Drums] {
        var lines = [[String]]()
        var dict : [String : Drums] = [:]
        for line in fileStr.componentsSeparatedByString(";") {
            lines += [line.componentsSeparatedByString(":")]
        }
        
        for lineSplit in lines {
            var drum = Drums()
            func chrToBool(ch : Character) -> Bool {if ch == "1" { return true } else { return false }}
            
            var convertedChars : [Bool] = Array(lineSplit[1]).map(chrToBool)
            
            for i in 0...15 {
                drum.snare[i] = convertedChars[i]
                drum.kick[i] = convertedChars[i+16]
                drum.hat[i] = convertedChars[i+32]
                drum.cymbal[i] = convertedChars[i+48]
            }
            
            dict[lineSplit[0]] = drum
        }
        
        return dict
        
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
    
    @IBAction func newTapped(sender : AnyObject) {
        totalTextField.text = "Untitled Beat"
        
        for i in 0...15 {
            collectionOfCymbals[i].isOn = false
            collectionOfHats[i].isOn = false
            collectionOfKicks[i].isOn = false
            collectionOfSnares[i].isOn = false
            
            drums.snare[i] = false
            drums.kick[i] = false
            drums.hat[i] = false
            drums.cymbal[i] = false
        }
    }
    
    @IBAction func loadTapped(sender : AnyObject) {
        if !sequenceDict.isEmpty {
            let thingToLoad = sequenceDict.keys.array[pickerView.selectedRowInComponent(0)]
            drums = sequenceDict[thingToLoad]!
            totalTextField.text = thingToLoad
            for i in 0...15 {
                collectionOfCymbals[i].isOn = drums.cymbal[i]
                collectionOfHats[i].isOn = drums.hat[i]
                collectionOfKicks[i].isOn = drums.kick[i]
                collectionOfSnares[i].isOn = drums.snare[i]
            }
        }
        
    }
    
    
    
    @IBAction func saveTapped(sender : AnyObject) {
        let documentDirectoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        let fileDestinationUrl = documentDirectoryURL.URLByAppendingPathComponent("file.txt")
        
        sequenceDict[totalTextField.text] = drums
        
        var saveTxt = ""
        
        for (key, beat) in sequenceDict {
            if(saveTxt != "") {
                saveTxt += ";"
            }
            
            saveTxt += key + ":" + writeSequence(beat.snare) +  writeSequence(beat.kick) + writeSequence(beat.hat) +  writeSequence(beat.cymbal)
        }
        
        pickerView.reloadAllComponents()
        
        //writing
        
        saveTxt.writeToURL(fileDestinationUrl, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        
        
    }
    
    func writeSequence (drumType : [Bool]) -> String{
        var str = ""
        for a in drumType {
            str += String(Int(a))
        }
        return str
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


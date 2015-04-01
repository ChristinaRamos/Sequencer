//
//  ViewController.swift
//  Sequencer
//
//  Created by Christina Ramos on 3/31/15.
//  Copyright (c) 2015 Christina Ramos. All rights reserved.
//

import UIKit

class ViewController: UIKit.UIViewController {

    @IBOutlet var totalTextField : UITextField!
    var drums : Drums = Drums()
    
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


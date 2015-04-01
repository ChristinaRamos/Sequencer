//
//  CheckBox.swift
//  Sequencer
//
//  Created by Christina Ramos on 3/31/15.
//  Copyright (c) 2015 Christina Ramos. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    
    let onImage = UIImage(named: "button_on")
    let offImage = UIImage(named: "button_off")
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setTitle("", forState: UIControlState.Normal)
    }
    
    var isOn: Bool = false {
        didSet {
            if isOn {
                self.setImage(onImage, forState: .Normal)
            } else {
                self.setImage(offImage, forState: .Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.isOn = false
    }
    
    func buttonClicked(sender: UIButton) {
        if(sender == self) {
            if isOn {
                isOn = false
            } else {
                isOn = true
            }
        }
    }
}

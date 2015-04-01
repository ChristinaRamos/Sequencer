//
//  CancelSegue.swift
//  Sequencer
//
//  Created by Christina Ramos on 4/1/15.
//  Copyright (c) 2015 Christina Ramos. All rights reserved.
//

import UIKit

class DismissSegue: UIStoryboardSegue {
    func segue() ->  {
        //UIViewController sourceViewController = self.sourceViewController;
        //[sourceViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    self.dismissViewControllerAnimated(true, completion: nil)
    }
}
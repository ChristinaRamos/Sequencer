//
//  TableViewController.swift
//  Sequencer
//
//  Created by Christina Ramos on 3/31/15.
//  Copyright (c) 2015 Christina Ramos. All rights reserved.
//

import UIKit

class TableViewController: UIKit.UIViewController, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var items: [(String,String)] = [("test1", "An example saved sequence."), ("anotherone", "Another save file..."), ("the last", "last save file in the list")]
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: nil)
        cell.textLabel!.text = self.items[indexPath.row].0
        cell.detailTextLabel!.text = self.items[indexPath.row].1
        return cell
    }
    
    
}
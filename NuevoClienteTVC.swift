//
//  NuevoClienteTVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 15/02/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

class NuevoClienteTVC: UITableViewController {

    var rowCount:Int = 0
    var rowAdded:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            //Perform action
            let newRowIndexPath = NSIndexPath(index: self.rowCount)
            self.rowCount += 1
            self.rowAdded = true
            
            self.tableView.insertRowsAtIndexPaths([newRowIndexPath], withRowAnimation: .Fade)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

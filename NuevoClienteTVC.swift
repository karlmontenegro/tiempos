//
//  NuevoClienteTVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 15/02/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

class NuevoClienteTVC: UITableViewController {

    var rowCountPhones:Int = 0
    var rowCountAddresses:Int = 0
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
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 1 {
            return self.rowCountPhones + 1
        }
        if section == 2 {
            return self.rowCountAddresses + 1
        }
        return 3
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ClientesCell", forIndexPath: indexPath)
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

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

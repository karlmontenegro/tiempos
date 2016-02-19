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
        if section == 0 {
            return 3
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Información del Cliente"
        }
        if section == 1 {
            return "Contactos"
        }
        if section == 2 {
            return "Direcciones"
        }
        return ""
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as! TextInputTableViewCell
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.configure(text: "", placeholder: "Nombre")
            }
            if indexPath.row == 1 {
                cell.configure(text: "", placeholder: "Razón Social")
            }
            if indexPath.row == 2 {
                cell.configure(text: "", placeholder: "RUC")
            }
        }else {

        }
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

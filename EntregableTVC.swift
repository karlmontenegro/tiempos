//
//  EntregableTVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 7/01/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

protocol entOperations{
    func returnNumEntregablesToContract(num:Int)
}

class EntregableTVC: UITableViewController, entregableEditionOperations {

    var contrato:Contrato? = nil
    var entregables:Array<Entregable>? = nil
    var delegateAddress:entOperations? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.entregables = daoEntregable().getEntregablesByContract(self.contrato!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func doneTapped(sender: AnyObject) {
        self.delegateAddress?.returnNumEntregablesToContract(self.entregables!.count)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refreshTableViewForEntregables() {
        self.entregables = daoEntregable().getEntregablesByContract(self.contrato!)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.entregables == nil {
            return 0
        } else {
            return self.entregables!.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("entregableCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = "Entregable " + (indexPath.row + 1).description

        if self.entregables != nil {
            cell.detailTextLabel!.text = self.entregables![indexPath.row].nombreEntreg!
        }
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            daoEntregable().deleteEntregableAt(self.entregables![indexPath.row])
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "newEntregableSegue" {
            let vc:EntregableVC = segue.destinationViewController as! EntregableVC
            let nuevoEntregable = daoEntregable().genericEntregable()
            self.contrato?.addEntregable(nuevoEntregable)
            vc.data = nuevoEntregable
            vc.delegateAddress = self
            vc.mode = "NEW"
        }
    }
}

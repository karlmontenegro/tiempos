//
//  ContactosPorClienteTableViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 25/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import AddressBook
import AddressBookUI

protocol showContact{
    func showContactInterface(contacto:AnyObject)
}

class ContactosPorClienteTableViewController: UITableViewController, ABPeoplePickerNavigationControllerDelegate{
    
    var contactData:AnyObject = []
    let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    var delegateContact:showContact? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if(contactData as! Cliente).contacto!.count > 0 {
            return (self.contactData as! Cliente).contacto!.count
        }else{
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactCell", forIndexPath: indexPath)
        
        let listaContacto = (contactData as! Cliente).contacto!.allObjects as! Array<Contacto>
        
        if listaContacto.count > 0 {
            
            cell.textLabel!.text = listaContacto[indexPath.row].firstName! as String + " " + listaContacto[indexPath.row].lastName! as String
            
        }


        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Borrar" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // Alerts before the delete just in case it wasn't meant to be
            let alertController = UIAlertController(title: "Atención", message:
                "¿Estás seguro que quieres borrar este contacto?", preferredStyle: UIAlertControllerStyle.Alert)
            
            // Delete action
            alertController.addAction(UIAlertAction(title: "Borrar", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
                // Deletes the row from the DAO
                
                daoContacto().deleteContactAt((self.contactData as! Cliente).contacto!.allObjects[indexPath.row] as! Contacto)
                // Deletes the element from the array
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }))
            
            // Cancel action
            alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default,handler: { (alertController) -> Void in
                self.tableView.reloadData()
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        })
        delete.backgroundColor = UIColor.redColor()
        
        //Edit action
        let edit = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Editar" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            //self.delegateAddress!.editAddressDelegate(((self.addressData as! Cliente).direccion.allObjects as! Array<Direccion>)[indexPath.row])
            self.tableView.reloadData()
        })
        edit.backgroundColor = UIColor.orangeColor()
        
        return [delete]
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let listaContacto = (contactData as! Cliente).contacto!.allObjects as! Array<Contacto>
        
        if listaContacto.count > 0 {
            self.delegateContact!.showContactInterface(listaContacto[indexPath.row])
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

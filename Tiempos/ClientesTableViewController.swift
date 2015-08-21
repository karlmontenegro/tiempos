//
//  ClientesTableViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 5/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import CoreData

class ClientesTableViewController: UITableViewController {
    
    var arreglo = daoCliente().getAllClients()
    let swipeRec = UISwipeGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeRec.addTarget(self, action: "swipedView")
        self.tableView.addGestureRecognizer(swipeRec)
    }
    
    override func viewWillAppear(animated: Bool) {
        arreglo = daoCliente().getAllClients()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func swipedView(){
        
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
        if(arreglo.count > 0){
            return self.arreglo.count
        }else{
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ClientesCell", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel!.text = self.arreglo[indexPath.row].valueForKey("nombre") as! String?
            cell.detailTextLabel!.text = self.arreglo[indexPath.row].valueForKey("razonSocial") as! String?
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "sendClient"){
            let vc: DetalleClienteViewController = segue.destinationViewController as! DetalleClienteViewController
            
            let indexpath:NSIndexPath = self.tableView.indexPathForSelectedRow()!
            
            vc.data = self.arreglo[indexpath.row]
        }
        if(segue.identifier == "editClientSegue"){
            //let indexpath:NSIndexPath = self.tableView.
            //let navController = segue.destinationViewController as! UINavigationController
            //let detailController = navController.topViewController as! EditarCliente
            //detailController.data = self.arreglo[indexpath.row]
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    */


    // Override to support editing the table view.
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        
        var delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Borrar" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // Alerts before the delete just in case it wasn't meant to be
            let alertController = UIAlertController(title: "Atención", message:
                "¿Estás seguro que quieres borrar este cliente? Esto borrará toda la información relacionada con el cliente.", preferredStyle: UIAlertControllerStyle.Alert)
            
            // Delete action
            alertController.addAction(UIAlertAction(title: "Borrar", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
                // Deletes the row from the DAO
                daoCliente().deleteClientAt(self.arreglo[indexPath.row])
                
                // Deletes the element from the array
                self.arreglo.removeAtIndex(indexPath.row)
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }))
            
            // Cancel action
            alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default,handler: { (alertController) -> Void in
                self.tableView.reloadData()
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)

        })
        delete.backgroundColor = UIColor.redColor()
        
       
        var edit = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Editar" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.performSegueWithIdentifier("editClientSegue", sender: self)
        })
        edit.backgroundColor = UIColor.orangeColor()
        
        
        return [delete,edit]
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

}

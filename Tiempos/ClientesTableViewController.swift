//
//  ClientesTableViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 5/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet

class ClientesTableViewController: UITableViewController, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    var arreglo = daoCliente().getAllClients()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Empty Data Set Lib
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self
        
        
        self.tableView.tableFooterView = UIView()
        
        
        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        arreglo = daoCliente().getAllClients()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Empty State for tableView
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty-client-100")
    }
    
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return UIColor.whiteColor()
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No tienes clientes aún"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Haz click en el botón superior derecho para añadir tu primer cliente"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return -(self.navigationController?.navigationBar.frame.height)!
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
        let cell = tableView.dequeueReusableCellWithIdentifier("ClientesCell", forIndexPath: indexPath) 
            cell.textLabel!.text = self.arreglo[indexPath.row].valueForKey("nombre") as! String?
            cell.detailTextLabel!.text = self.arreglo[indexPath.row].valueForKey("razonSocial") as! String?
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newClient" {
            let navVC = segue.destinationViewController as! UINavigationController
            let clientVC = navVC.viewControllers.first as! NuevoClienteTVC
            clientVC.source = "NEW"
        }
        
        if segue.identifier == "sendClient" {
            let navVC = segue.destinationViewController as! UINavigationController
            let clientVC = navVC.viewControllers.first as! NuevoClienteTVC
            let indexpath:NSIndexPath = self.tableView.indexPathForSelectedRow!
            clientVC.cliente = self.arreglo[indexpath.row]
            clientVC.source = "EDIT"
        }
    }

    // Override to support editing the table view.
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("sendClient", sender: self)
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Borrar" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // Alerts before the delete just in case it wasn't meant to be
            let alertController = UIAlertController(title: "Atención", message:
                "¿Estás seguro que quieres borrar este cliente? Esto borrará toda la información relacionada con el cliente.", preferredStyle: UIAlertControllerStyle.Alert)
            
            // Delete action
            alertController.addAction(UIAlertAction(title: "Borrar", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
                
                //Checks for associated information
                
                let cliente = self.arreglo[indexPath.row]
                
                if cliente.hasContracts() || cliente.hasCitas() || cliente.hasRecibos() || cliente.hasTiempos() {
                    self.alertMessage("El cliente no se puede borrar, tiene mucha información asociada.", winTitle: "Error")
                } else {
                    // Deletes the row from the DAO
                    daoCliente().deleteClientAt(self.arreglo[indexPath.row])
                    // Deletes the element from the array
                    self.arreglo.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            }))
            
            // Cancel action
            alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default,handler: { (alertController) -> Void in
                self.tableView.reloadData()
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)

        })
        delete.backgroundColor = UIColor.redColor()
       
        return [delete]
    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
    func alertMessage(winMessage: String, winTitle: String){
        let alertController = UIAlertController(title: winTitle, message: winMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

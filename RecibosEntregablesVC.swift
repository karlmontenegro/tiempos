//
//  RecibosEntregablesVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 11/01/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import Foundation

class RecibosEntregablesVC: UIViewController, invoiceOp{

    var origin = "ClassifierItem"
    var classifier = "Clientes"
    var client:Cliente? = nil
    
    var entregablesDictionary:Dictionary<Cliente,Array<Entregable>> = daoEntregable().getAllEntregables()!
    var entregablesKeys:Array<Cliente> = []
    
    var selectedEntregable:Entregable? = nil
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var classifierItemsTable: UITableView!
    @IBOutlet weak var generateInvoiceButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.entregablesKeys = Array(self.entregablesDictionary.keys)
        
        self.generateInvoiceButton.enabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadEntregablesList() {
        
    }
    
    func reloadTimesList() {
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        return self.entregablesKeys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entregablesDictionary[self.entregablesKeys[section]]!.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.entregablesKeys[section].nombre
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("classifierItemCell", forIndexPath: indexPath)
        let cliente = self.entregablesKeys[indexPath.section]
        let entregable = self.entregablesDictionary[cliente]![indexPath.row]
        
    
        cell.textLabel?.text = entregable.nombreEntreg
        
        if entregable.contrato != nil {
            cell.detailTextLabel?.text = "Contrato: " + (entregable.contrato?.nombreContrato)!
        } else {
            cell.detailTextLabel?.text = "(Sin Contrato)"
        }

        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath:
        NSIndexPath) -> [UITableViewRowAction]?  {
        
        let cliente = self.entregablesKeys[indexPath.section]
        let entregable = self.entregablesDictionary[cliente]![indexPath.row]
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Borrar" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // Alerts before the delete just in case it wasn't meant to be
            let alertController = UIAlertController(title: "Atención", message:
                "¿Estás seguro que quieres borrar este tiempo? Esto borrará toda la información relacionada con el tiempo.", preferredStyle: UIAlertControllerStyle.Alert)
            
            // Delete action
            alertController.addAction(UIAlertAction(title: "Borrar", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
                // Deletes the row from the DAO
                
                daoEntregable().deleteEntregableAt(entregable)
                
                // Deletes the element from the array
                
                self.entregablesDictionary[cliente]?.removeAtIndex(indexPath.row)
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }))
            
            // Cancel action
            alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default,handler: { (alertController) -> Void in
                self.classifierItemsTable.reloadData()
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        })
        delete.backgroundColor = UIColor.redColor()
        
        return [delete]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        let cliente = self.entregablesKeys[indexPath.section]
        let entregable = self.entregablesDictionary[cliente]![indexPath.row]
        
        if(cell?.accessoryType == UITableViewCellAccessoryType.None){
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            //Ingresar seleccion en la variable
            self.selectedEntregable = entregable
            self.generateInvoiceButton.enabled = true
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath:NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = UITableViewCellAccessoryType.None
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createInvoiceSegue" {
            let navVC = segue.destinationViewController as! UINavigationController
            let vc:ReciboEmitidoVC = navVC.viewControllers.first as! ReciboEmitidoVC
            vc.entregable = self.selectedEntregable
            vc.tipoFact = "ENT"
            vc.cliente = self.selectedEntregable?.contrato?.cliente
            vc.delegateAddress = self
        }
    }
}

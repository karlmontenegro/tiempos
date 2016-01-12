//
//  RecibosEntregablesVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 11/01/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import Foundation

class RecibosEntregablesVC: UIViewController, classifierOp {

    var origin = "ClassifierItem"
    var classifier = "Clientes"
    var client:Cliente? = nil
    var classifierItemArray:Array<Contrato>? = nil
    
    var selectedEntregablesArray:Array<Entregable> = []
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var classifierItemsTable: UITableView!
    @IBOutlet weak var txtClient: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func returnSelectedOption(selectedObject: AnyObject?, origin: String) {
        self.txtClient.text = (selectedObject as! Cliente).nombre!
        self.client = selectedObject as? Cliente
        self.classifierItemArray = daoContrato().getAllContractsByClientAndFactType(self.client!, tipo: "ENT")
        self.classifierItemsTable.reloadData()
    }
    
    @IBAction func sortByClientTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("classifierPickerSegue", sender: self)
    }

    @IBAction func generateInvoiceTapped(sender: AnyObject) {
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if self.classifierItemArray == nil {
            return 0
        } else {
            return self.classifierItemArray!.count
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let num = daoEntregable().getActiveEntregablesByContract(self.classifierItemArray![section]).count
        
        return num
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.classifierItemArray == nil {
            return ""
        } else {
            return "Contrato: " + self.classifierItemArray![section].nombreContrato!
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("classifierItemCell", forIndexPath: indexPath)

            cell.textLabel?.text = "Entregable " + (indexPath.row + 1).description
            cell.detailTextLabel?.text = daoEntregable().getEntregablesByContract(self.classifierItemArray![indexPath.section])[indexPath.row].nombreEntreg!

        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Borrar" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // Alerts before the delete just in case it wasn't meant to be
            let alertController = UIAlertController(title: "Atención", message:
                "¿Estás seguro que quieres borrar este tiempo? Esto borrará toda la información relacionada con el tiempo.", preferredStyle: UIAlertControllerStyle.Alert)
            
            // Delete action
            alertController.addAction(UIAlertAction(title: "Borrar", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
                // Deletes the row from the DAO
                
                //daoEntregable().deleteEntregableAt(self.classifierItemArray![indexPath.row])
                
                // Deletes the element from the array
                self.classifierItemArray!.removeAtIndex(indexPath.row)
                
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
        
        if (cell?.accessoryType == UITableViewCellAccessoryType.Checkmark){
            
            cell!.accessoryType = UITableViewCellAccessoryType.None
            //self.removeFromArray(self.classifierItemArray![indexPath.row])
        }else{
            
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            //self.selectedEntregablesArray.append(self.classifierItemArray![indexPath.row])
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func removeFromArray(obj: Entregable) {
        for var index = 0; index < self.selectedEntregablesArray.count; ++index {
            if self.selectedEntregablesArray[index] == obj {
                self.selectedEntregablesArray.removeAtIndex(index)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "classifierPickerSegue" {
            let vc:ClassifierPickerModal = segue.destinationViewController as! ClassifierPickerModal
            vc.delegateAddress = self
            vc.origin = self.origin
            vc.classifier = self.classifier
        }
        if segue.identifier == "createInvoiceSegue" {
            let navVC = segue.destinationViewController as! UINavigationController
            let vc:ReciboEmitidoVC = navVC.viewControllers.first as! ReciboEmitidoVC
            vc.dataArray = self.selectedEntregablesArray
            vc.tipoFact = "ENT"
        }
    }
}

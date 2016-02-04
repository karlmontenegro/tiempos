//
//  ContratosTableViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 5/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

class ContratosTableViewController: UITableViewController {
    
    var arreglo = daoContrato().getAllActiveContracts()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        arreglo = daoContrato().getAllActiveContracts()
        self.tableView.reloadData()
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
        if(arreglo.count > 0){
            return self.arreglo.count
        }else{
            return 0
        }
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContratoCell", forIndexPath: indexPath)

        cell.textLabel!.text = self.arreglo[indexPath.row].valueForKey("nombreContrato") as! String?
        cell.detailTextLabel!.text = self.arreglo[indexPath.row].valueForKey("cliente")?.valueForKey("nombre") as! String?
        return cell
    }



    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Borrar" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // Alerts before the delete just in case it wasn't meant to be
            let alertController = UIAlertController(title: "Atención", message:
                "¿Estás seguro que quieres borrar este contrato? Esto borrará toda la información relacionada con el contrato.", preferredStyle: UIAlertControllerStyle.Alert)
            
            // Delete action
            alertController.addAction(UIAlertAction(title: "Borrar", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
                // Deletes the row from the DAO
                daoContrato().deleteContractAt(self.arreglo[indexPath.row])
                
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
        
        return [delete]
    }
 
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "ContratoDetalle"){
            let vc:NuevoContratoTVC = segue.destinationViewController as! NuevoContratoTVC
            
            let indexpath:NSIndexPath = self.tableView.indexPathForSelectedRow!
            
            vc.contrato = self.arreglo[indexpath.row]
            vc.origin = "EDIT"
        }
        if(segue.identifier == "nuevoContratoSegue"){
            let vc:NuevoContratoTVC = segue.destinationViewController as! NuevoContratoTVC
            
            //Aquí se crea el nuevo contrato
            let nuevoContrato:Contrato = daoContrato().genericContract()
            vc.contrato = nuevoContrato
            vc.origin = "NEW"
        }
    }

}

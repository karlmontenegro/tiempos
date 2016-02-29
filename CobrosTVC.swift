//
//  CobrosTVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 28/01/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

class CobrosTVC: UITableViewController,cobrosOp {

    @IBOutlet weak var menuButton: UIBarButtonItem!

    var notCashedInvoices:Array<Recibo> = daoRecibo().getAllPendingInvoices()!
    var cashedInvoices:Array<Recibo> = daoRecibo().getAllCashedInvoices()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func reloadCashedInvoices() {
        self.notCashedInvoices = daoRecibo().getAllPendingInvoices()!
        self.cashedInvoices = daoRecibo().getAllCashedInvoices()!
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Recibos sin cobrar"
        }else {
            return "Recibos cobrados"
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return self.notCashedInvoices.count
        } else {
            return self.cashedInvoices.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reciboCell", forIndexPath: indexPath)
        
        if indexPath.section == 0 {
            
            if self.notCashedInvoices[indexPath.row].contrato != nil {
                cell.textLabel!.text = self.notCashedInvoices[indexPath.row].contrato?.nombreContrato
            } else {
                cell.textLabel!.text = "(Sin Contrato)"
            }
            cell.detailTextLabel?.text = "Cliente: " + (self.notCashedInvoices[indexPath.row].cliente?.nombre)! + " Monto: " + Double(self.notCashedInvoices[indexPath.row].valor!).description
        } else {
            cell.textLabel!.text = self.cashedInvoices[indexPath.row].cliente?.nombre
            cell.detailTextLabel?.text = "Cliente: " + (self.cashedInvoices[indexPath.row].cliente?.nombre)! + " Monto: " + Double(self.cashedInvoices[indexPath.row].valor!).description
        }
        
        return cell
    }
    
   
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            if indexPath.section == 0 {
                daoRecibo().deleteInvoice(self.notCashedInvoices[indexPath.row])
                self.notCashedInvoices.removeAtIndex(indexPath.row)
            } else {
                daoRecibo().deleteInvoice(self.cashedInvoices[indexPath.row])
                self.cashedInvoices.removeAtIndex(indexPath.row)
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "invoiceDetailSegue" {
            let cobroVC = segue.destinationViewController as! CobroDetailVC
            let indexpath:NSIndexPath = self.tableView.indexPathForSelectedRow!
            
            if indexpath.section == 0 {
                cobroVC.rec = self.notCashedInvoices[indexpath.row]
                cobroVC.origin = "NC"
                cobroVC.delegateAddress = self
            } else {
                cobroVC.rec = self.cashedInvoices[indexpath.row]
                cobroVC.origin = "C"
            }
        }
    }
}

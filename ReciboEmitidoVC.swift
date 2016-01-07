//
//  ReciboEmitidoVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 5/01/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import Foundation

class ReciboEmitidoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tiemposArray:Array<Tiempo> = []
    let dateFormatter = NSDateFormatter()

    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var lblNomCliente: UILabel!
    @IBOutlet weak var lblNomContrato: UILabel!
    @IBOutlet weak var lblTipoFact: UILabel!
    @IBOutlet weak var lblFechaEmision: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let today:NSDate = NSDate()
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        self.lblFechaEmision.text = self.dateFormatter.stringFromDate(today)
        self.lblNomCliente.text = self.tiemposArray[0].cliente?.nombre
        
        if self.tiemposArray[0].contrato != nil {
            let contrato = self.tiemposArray[0].contrato
            
            self.lblNomContrato.text = contrato?.nombreContrato
            
            if contrato?.tipoFacturacion == "HRS" {
                self.lblTipoFact.text = "Por Horas"
            } else {
                self.lblTipoFact.text = "Por Entregables"
            }
        } else {
            self.lblNomContrato.text = "Ninguno"
            self.lblTipoFact.text = "Ninguna"
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tiemposArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reciboCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = self.tiemposArray[indexPath.row].titulo
        cell.detailTextLabel!.text = self.tiemposArray[indexPath.row].horas?.description
        
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
                
                
                
                // Deletes the element from the array
                
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }))
            
            // Cancel action
            alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default,handler: { (alertController) -> Void in
                self.detailTableView.reloadData()
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        })
        delete.backgroundColor = UIColor.redColor()
        
        return [delete]
    }

    @IBAction func saveTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

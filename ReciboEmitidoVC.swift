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

    var contrato:Contrato? = nil
    let dateFormatter = NSDateFormatter()

    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var lblNomCliente: UILabel!
    @IBOutlet weak var lblNomContrato: UILabel!
    @IBOutlet weak var lblTipoFact: UILabel!
    @IBOutlet weak var lblFechaEmision: UILabel!
    @IBOutlet weak var lblMontoTotal: UILabel!
    
    var montoTotal:Double = 0.0
    var tipoFact:String = "" //Si es por Entregables o por Horas
    var dataArray:Array<AnyObject> = []
    var singleData:AnyObject? = nil
    
    //Facturación Por Horas
    var tarifaPorHora:Double = 0.0
    var tiemposArray:Array<Tiempo> = []
    
    //Facturación Por Entregable
    var entregablesArray:Array<Entregable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let today:NSDate = NSDate()
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        self.lblFechaEmision.text = self.dateFormatter.stringFromDate(today)
        
        
        if tipoFact == "HRS" { //Por Horas
            self.contrato = (self.dataArray[0] as! Tiempo).contrato!
            self.lblNomCliente.text = (self.dataArray[0] as! Tiempo).contrato?.cliente?.nombre
            self.tiemposArray = self.dataArray as! Array<Tiempo>
            
            if self.multipleContracts(self.dataArray as! Array<Tiempo>) {
                self.lblNomContrato.text = "Varios Contratos"
                self.lblTipoFact.text = "Por Horas"
            } else {
                self.tarifaPorHora = Double(((self.dataArray[0] as! Tiempo).contrato?.contratoHoras?.tarifaHora)!)
                self.lblNomContrato.text = self.contrato?.nombreContrato
                self.lblTipoFact.text = (self.contrato?.moneda)! + " " + self.tarifaPorHora.description + " por Hora"
            }
            
            
        } else { //Por Entregables
            
            self.entregablesArray = self.dataArray as! Array<Entregable>
            
            if self.multipleContractsEnt(self.dataArray as! Array<Entregable>) {
                self.lblNomContrato.text = "Varios Contratos"
            }else {
                self.lblNomContrato.text = (self.dataArray[0] as! Entregable).contrato?.nombreContrato!
            }
            self.lblNomCliente.text = (self.dataArray[0] as! Entregable).contrato?.cliente?.nombre
            self.lblTipoFact.text = "Por Entregable"
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
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reciboCell", forIndexPath: indexPath)
        
        if tipoFact == "HRS" {
            let interval = self.tiemposArray[indexPath.row].horas!
            let timeInterval = NSTimeInterval(interval.doubleValue)
            let subtotal = Double(Int(interval)/3600) * self.tarifaPorHora

            cell.textLabel!.text = self.tiemposArray[indexPath.row].titulo
            cell.detailTextLabel!.text = self.stringFromTimeInterval(timeInterval) + "     Subtotal: " + (self.tiemposArray[0].contrato?.moneda)! + " " + subtotal.description
        
            self.montoTotal += subtotal
        
            self.lblMontoTotal.text = (self.tiemposArray[0].contrato?.moneda)! + " " + self.montoTotal.description
        } else {
            cell.textLabel!.text = self.entregablesArray[indexPath.row].nombreEntreg
            cell.detailTextLabel!.text = "Subtotal: " + (self.entregablesArray[indexPath.row].contrato?.moneda)! + Double((self.entregablesArray[indexPath.row].tarifa)!).description
            let subtotal = Double((self.entregablesArray[indexPath.row].tarifa)!)
            self.montoTotal += subtotal
        }
        
        self.lblMontoTotal.text = self.montoTotal.description
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Borrar" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // Alerts before the delete just in case it wasn't meant to be
            
            var mes:String = ""
            
            if self.tipoFact == "ENT" {
                mes = "entregable"
            } else {
                mes = "tiempo"
            }
        
            let alertController = UIAlertController(title: "Atención", message:
                "¿Estás seguro que quieres quitar el " + mes + " del recibo?", preferredStyle: UIAlertControllerStyle.Alert)
            
            // Delete action
            alertController.addAction(UIAlertAction(title: "Borrar", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
                // Deletes the row from the DAO
                
                if self.tipoFact == "HRS" {
                    self.tiemposArray.removeAtIndex(indexPath.row)
                } else {
                    self.entregablesArray.removeAtIndex(indexPath.row)
                }
                // Deletes the element from the array
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.detailTableView.reloadData()
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
        let alertController = UIAlertController(title: "Atención", message:
            "Se registrará el recibo por el monto de " + self.montoTotal.description + "¿Desea continuar?", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Save action
        alertController.addAction(UIAlertAction(title: "Emitir", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in

        }))
        
        // Cancel action
        alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default,handler: { (alertController) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d horas %02d minutos", hours, minutes)
    }
    
    func multipleContracts(arr: Array<Tiempo>) -> Bool {
        let nombre = arr[0].contrato?.nombreContrato!
        
        for tiempo in arr {
            if tiempo.contrato?.nombreContrato != nombre {
                return true
            }
        }
        return false
    }
    
    func multipleContractsEnt(arr: Array<Entregable>) -> Bool {
        let nombre = arr[0].contrato?.nombreContrato!
        
        for entregable in arr  {
            if entregable.contrato?.nombreContrato != nombre{
                return true
            }
        }
        return false
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

//
//  ReciboEmitidoVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 5/01/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import Foundation

class ReciboEmitidoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, tarifaOp {

    var entregable:Entregable? = nil
    var tiemposArray:Array<Tiempo> = []
    
    var cliente:Cliente? = nil
    var tipoFact:String = ""
    var montoTotal:Double? = nil

    let dateFormatter = NSDateFormatter()
    let today:NSDate = NSDate()

    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var lblNomCliente: UILabel!
    @IBOutlet weak var lblTipoFact: UILabel!
    @IBOutlet weak var lblFechaEmision: UILabel!
    @IBOutlet weak var lblMontoTotal: UILabel!
    @IBOutlet weak var txtDescripcion: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        self.lblFechaEmision.text = self.dateFormatter.stringFromDate(self.today)
        self.lblNomCliente.text = self.cliente?.nombre
        if self.tipoFact == "HRS" {
            self.lblTipoFact.text = "Por Horas"
            self.lblMontoTotal.text = self.calculateTotal(self.tiemposArray)
            print(self.tiemposArray)
        } else {
            self.lblTipoFact.text = "Por Entregables"
            self.lblMontoTotal.text = (self.entregable?.moneda?.descripcion)! + " " + Double((self.entregable?.tarifa!)!).description
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func returnUpdatedFees() {
        self.detailTableView.reloadData()
        self.lblMontoTotal.text = self.calculateTotal(self.tiemposArray)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.tipoFact == "HRS"  { //Facturación por horas
            
            return self.tiemposArray.count
        } else { //Facturación por entregables
            
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reciboCell", forIndexPath:
            indexPath)
        
        if self.tipoFact == "HRS" { //Por horas
            
            cell.textLabel!.text = self.tiemposArray[indexPath.row].titulo
            
            if self.tiemposArray[indexPath.row].contrato != nil {
                
                let tarifa = Double((self.tiemposArray[indexPath.row].contrato?.contratoHoras?.tarifaHora)!)
                let interval = self.tiemposArray[indexPath.row].horas!
                let timeInterval = NSTimeInterval(interval.doubleValue)
                let subtotal = Double(Int(interval)/3600) * tarifa
                let moneda = self.tiemposArray[indexPath.row].contrato?.moneda?.descripcion
                
                cell.detailTextLabel!.text = "Horas: " + self.stringFromTimeInterval(timeInterval) + " - Subtotal: " + moneda! + subtotal.description
                
            } else {
                let interval = self.tiemposArray[indexPath.row].horas!
                let timeInterval = NSTimeInterval(interval.doubleValue)
                
                if self.tiemposArray[indexPath.row].moneda == nil {
                    cell.detailTextLabel!.text = "Horas: " + self.stringFromTimeInterval(timeInterval) + " - Subtotal: (Sin Tarifa)"
                } else {
                    let tarifa = Double((self.tiemposArray[indexPath.row].tarifaHoras)!)
                    let subtotal = Double(Int(interval)/3600) * tarifa
                    let moneda = self.tiemposArray[indexPath.row].moneda?.descripcion
                    
                    cell.detailTextLabel!.text = "Horas: " + self.stringFromTimeInterval(timeInterval) + " - Subtotal: " + moneda! + subtotal.description
                }
            }
            
        } else { //Por entregables
            cell.textLabel!.text = self.entregable?.nombreEntreg
            cell.detailTextLabel!.text = "Tarifa: " + (self.entregable?.moneda?.descripcion)! + Double(self.entregable!.tarifa!).description
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.tiemposArray[indexPath.row].contrato == nil {
            self.performSegueWithIdentifier("tarifaModalSegue", sender: self)
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Borrar" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // Alerts before the delete just in case it wasn't meant to be
            
            
            let alertController = UIAlertController(title: "Atención", message:
                "¿Estás seguro que quieres quitar el del recibo?", preferredStyle: UIAlertControllerStyle.Alert)
            
            // Delete action
            alertController.addAction(UIAlertAction(title: "Borrar", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
                // Deletes the row from the DAO
                

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
        
        if self.montoTotal == nil {
            self.alertMessage("Faltan tarifas que completar antes de generar el recibo.", winTitle: "Error")
        } else {
        
            if self.findCurrencyInArray(self.tiemposArray) == nil {
                self.alertMessage("Falta asignar una moneda predeterminada antes de generar el recibo.", winTitle: "Error")
            } else {
                let alertController = UIAlertController(title: "Atención", message: "Se emitirá el recibo de monto: " + self.lblMontoTotal.text! + " al cliente " + (self.cliente?.nombre)!, preferredStyle: UIAlertControllerStyle.Alert)
                
                alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel,  handler: { (alertController) -> Void in
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }))
                
                alertController.addAction(UIAlertAction(title: "Emitir", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
                    
                    if self.tipoFact == "HRS" {
                        //Se crea la cabecera del recibo
                        let recibo:Recibo? = daoRecibo().createGenericNewInvoice(self.today, client: self.cliente, contract: self.findContractInArray(self.tiemposArray), total: self.montoTotal, moneda: self.findCurrencyInArray(self.tiemposArray),description: self.txtDescripcion.text)
                    
                        //Se añaden los elementos del recibo detalle
                        daoRecibo().addTiemposToInvoice(recibo!, tiempos: self.tiemposArray)
                        print(recibo)
                    } else {
                        let recibo: Recibo? = daoRecibo().createGenericNewInvoice(self.today, client: self.cliente, contract: self.entregable?.contrato, total: Double((self.entregable?.tarifa)!), moneda: self.entregable?.moneda, description: self.txtDescripcion.text)
                        daoRecibo().addEntregablesToInvoice(recibo!, entregables: self.entregable)
                    }
                    self.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
        }
        
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
    
    func calculateTotal(tiempos: Array<Tiempo>) -> String? {
        var montoTotal:Double = 0.0
        for t in tiempos {
            if t.contrato == nil {
                if t.moneda == nil{
                    return "(Tarifas Faltantes)"
                } else {
                    let tarifa = Double((t.tarifaHoras)!)
                    let interval = t.horas!
                    let subtotal = Double(Int(interval)/3600) * tarifa
                    montoTotal += subtotal
                }
            } else {
                let tarifa = Double((t.contrato?.contratoHoras?.tarifaHora)!)
                let interval = t.horas!
                let subtotal = Double(Int(interval)/3600) * tarifa
                montoTotal += subtotal
            }
        }
        
        if self.findCurrencyInArray(tiempos) != nil {
            self.montoTotal = montoTotal
            return self.findCurrencyInArray(tiempos)!.descripcion! + " " + montoTotal.description
        } else {
            return "(Moneda Faltante)"
        }        
    }
    
    func findCurrencyInArray(tiempos: Array<Tiempo>) -> Moneda? {
        for t in tiempos {
            if t.contrato != nil {
                return t.contrato?.moneda
            }
        }
        return daoConfiguracion().getConfig()?.moneda
    }
    
    func findContractInArray(tiempos:Array<Tiempo>) -> Contrato? {
        var i = 0
        var j = 0
        
        for i = 0; i <= tiempos.count; i++ {
            for j = 0; j <= tiempos.count; j++ {
                if tiempos[i].contrato != tiempos[j].contrato {
                    return nil
                }
            }
        }
        return tiempos[i].contrato
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tarifaModalSegue" {
            let vc:TarifaModal = segue.destinationViewController as! TarifaModal
            let indexpath:NSIndexPath = self.detailTableView.indexPathForSelectedRow!
            vc.tiempo = self.tiemposArray[indexpath.row]
            vc.currency = self.findCurrencyInArray(self.tiemposArray)
            vc.delegateAddress = self
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "tarifaModalSegue" {
            if self.findCurrencyInArray(self.tiemposArray) == nil {
                self.alertMessage("Asigna una moneda predeterminada primero.", winTitle: "Error")
                return false
            }
        }
        return true
    }

    func alertMessage(winMessage: String, winTitle: String){
        let alertController = UIAlertController(title: winTitle, message: winMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

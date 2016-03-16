//
//  ReciboEmitidoVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 5/01/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import Foundation

protocol invoiceOp {
    func reloadTimesList()
    func reloadEntregablesList()
}

class ReciboEmitidoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, tarifaOp, dateTimeOp, currencyOperations {

    var entregable:Entregable? = nil
    var tiemposArray:Array<Tiempo> = []
    
    var cliente:Cliente? = nil
    var tipoFact:String = ""
    var montoTotal:Double? = nil
    var delegateAddress: invoiceOp? = nil
    var dueDate:NSDate? = NSDate()
    var moneda:Moneda? = nil
    var monedaStatus:Bool = true
    
    let dateFormatter = NSDateFormatter()
    let today:NSDate = NSDate()

    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var lblNomCliente: UILabel!
    @IBOutlet weak var lblTipoFact: UILabel!
    @IBOutlet weak var lblFechaEmision: UILabel!
    @IBOutlet weak var lblMontoTotal: UILabel!
    @IBOutlet weak var btnFechaVencimiento: UIButton!
    @IBOutlet weak var btnMoneda: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.dateFormat = "dd/MM/yy"
        self.lblFechaEmision.text = self.dateFormatter.stringFromDate(self.today)
        self.btnFechaVencimiento.setTitle(self.lblFechaEmision.text!, forState: UIControlState.Normal)
        self.dueDate = self.dateFormatter.dateFromString(self.lblFechaEmision.text!)
        self.lblNomCliente.text = self.cliente?.nombre
        
        if self.tipoFact == "HRS" {
            self.lblTipoFact.text = "Por Horas"
            
            if !self.monedaStatus {
                self.btnMoneda.enabled = true
            } else {
                
                self.moneda = self.findCurrencyInArray(self.tiemposArray)
                
                if self.moneda != nil {
                    self.btnMoneda.setTitle(self.moneda?.descripcion, forState: UIControlState.Normal)
                    self.btnMoneda.enabled = false
                } else {
                    self.btnMoneda.setTitle("+ Añadir", forState: UIControlState.Normal)
                    self.btnMoneda.enabled = true
                }
            }
            
            self.lblMontoTotal.text = self.calculateTotal(self.tiemposArray)
        } else {
            self.lblTipoFact.text = "Por Entregables"
            
            if !self.monedaStatus {
                self.btnMoneda.enabled = true
            } else {
                self.btnMoneda.enabled = false
            }
            
            self.lblMontoTotal.text = (self.entregable?.moneda?.descripcion)! + " " + Double((self.entregable?.tarifa!)!).description
            self.montoTotal = Double((self.entregable?.tarifa!)!)
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
    
    func returnCurrency(currency: Moneda) {
        self.moneda = currency
        self.btnMoneda.setTitle(self.moneda?.descripcion, forState: UIControlState.Normal)
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
        if self.tipoFact == "HRS" {
            if self.tiemposArray[indexPath.row].contrato == nil {
                self.performSegueWithIdentifier("tarifaModalSegue", sender: self)
            }
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
            if self.tipoFact == "HRS" { //Por horas
                if self.findCurrencyInArray(self.tiemposArray) == nil || self.moneda == nil {
                    self.alertMessage("Falta asignar una moneda predeterminada antes de generar el recibo.", winTitle: "Error")
                } else {
                    let alertController = UIAlertController(title: "Atención", message: "Se emitirá el recibo de monto: " + self.lblMontoTotal.text! + " al cliente " + (self.cliente?.nombre)!, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel,  handler: { (alertController) -> Void in
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    }))
                    
                    alertController.addAction(UIAlertAction(title: "Emitir", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
                        
                        //Se crea la cabecera del recibo
                        
                        var recibo:Recibo? = nil
                        
                        if self.findCurrencyInArray(self.tiemposArray) != nil {
                            recibo = daoRecibo().createGenericNewInvoice(self.today, client: self.cliente, contract: self.findContractInArray(self.tiemposArray), total: self.montoTotal, moneda: self.findCurrencyInArray(self.tiemposArray), description: "", dueDate: self.dueDate!)
                        } else {
                            recibo = daoRecibo().createGenericNewInvoice(self.today, client: self.cliente, contract: self.findContractInArray(self.tiemposArray), total: self.montoTotal, moneda: self.moneda ,description: "", dueDate: self.dueDate!)
                        }
                        
                        //Se añaden los elementos del recibo detalle
                        daoRecibo().addTiemposToInvoice(recibo!, tiempos: self.tiemposArray)
                        self.delegateAddress?.reloadTimesList()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }

            } else { //Por entregables
                let alertController = UIAlertController(title: "Atención", message: "Se emitirá el recibo de monto: " + self.lblMontoTotal.text! + " al cliente " + (self.cliente?.nombre)!, preferredStyle: UIAlertControllerStyle.Alert)
                
                alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel,  handler: { (alertController) -> Void in
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }))
                
                alertController.addAction(UIAlertAction(title: "Emitir", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
                    
                    let recibo: Recibo? = daoRecibo().createGenericNewInvoice(self.today, client: self.cliente, contract: self.entregable?.contrato, total: Double((self.entregable?.tarifa)!), moneda: self.entregable?.moneda, description: "", dueDate: self.dueDate!)
                    daoRecibo().addEntregablesToInvoice(recibo!, entregables: self.entregable)
                    self.delegateAddress?.reloadEntregablesList()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    func returnDateTimeToDate(date: NSDate, type: String) {
        self.dueDate = date
        self.btnFechaVencimiento.setTitle(self.dateFormatter.stringFromDate(self.dueDate!), forState: UIControlState.Normal)
    }
    
    
    @IBAction func cancelTapped(sender: AnyObject) {
        if self.tipoFact == "HRS" {
            self.clearCurrencyFromTiempos(self.tiemposArray)
        }
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
            self.monedaStatus = false
            return "(Moneda Faltante)"
        }        
    }
    
    func findCurrencyInArray(tiempos: Array<Tiempo>) -> Moneda? {
        for t in tiempos {
            if t.contrato != nil {
                return t.contrato?.moneda
            }
        }
        if self.moneda != nil {
            return self.moneda
        } else {
            return daoConfiguracion().getConfig()?.moneda
        }
    }
    
    func findContractInArray(tiempos:Array<Tiempo>) -> Contrato? {
        
        for t in tiempos {
            for u in tiempos {
                if t.contrato != u.contrato {
                    return nil
                }
            }
        }
        return tiempos.first?.contrato
    }
    
    func clearCurrencyFromTiempos (tiempos: Array<Tiempo>) {
        for t in tiempos {
            t.moneda = nil
        }
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
            
            if self.findCurrencyInArray(self.tiemposArray) != nil {
                vc.currency = self.findCurrencyInArray(self.tiemposArray)
            } else {
                vc.currency = self.moneda
            }
            vc.delegateAddress = self
        }
        
        if segue.identifier == "fechaVencSegue" {
            let vc:DateTimePicker = segue.destinationViewController as! DateTimePicker
            
            if self.dueDate == nil {
                vc.date = self.today
            } else {
                vc.date = self.dueDate!
            }
            
            vc.delegateAddress = self
            vc.source = "INV"
        }
        
        if segue.identifier == "currencyModalSegue" {
            let vc:MonedaModal = segue.destinationViewController as! MonedaModal
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

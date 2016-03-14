//
//  NuevoTiempoTVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/12/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import EventKit
import Foundation

protocol unconvertedDatesOp{
    func refreshUnconvertedDates()
}

class NuevoTiempoTVC: UITableViewController, hoursOp, clientOp, contractHourOp, dateTimeOp {
    
    var date:NSDate? = nil
    var cita:Cita? = nil
    var horas:String = ""
    var source:String = ""
    var event:EKEvent? = nil
    let eventStore = EKEventStore()
    let dateFormatter = NSDateFormatter()
    
    var cliente:Cliente? = nil
    var contrato:Contrato? = nil
    var fecha:NSDate? = nil
    var interval:NSTimeInterval? = nil
    var delegateAddress:unconvertedDatesOp? = nil
    
    @IBOutlet weak var lblCliente: UILabel!
    @IBOutlet weak var lblContrato: UILabel!
    @IBOutlet weak var lblCita: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblHoras: UILabel!
    @IBOutlet weak var txtTitulo: UITextField!
    
    @IBOutlet weak var citaAsociada: UITableViewCell!
    @IBOutlet weak var fechaAsociada: UITableViewCell!
    @IBOutlet weak var contratoAsociado: UITableViewCell!
    @IBOutlet weak var viewTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateFormatter.dateFormat = "ccc, dd MMM"
        
        if self.source == "Date" {
            self.event = daoCita().getEventByDateId(self.cita!, store: self.eventStore)
            
            self.fecha = self.event?.startDate
            self.cliente = self.cita?.cliente
            self.contrato = self.cita?.contrato
            self.viewTitle.title = "Añadir Horas A Cita"
            
            if self.contrato == nil {
                self.lblContrato.text = "+ Asociar Contrato"
            } else {
                self.lblContrato.text = self.contrato?.nombreContrato
            }
            
            self.interval = self.getTotalTime((self.event?.startDate)!, end: (self.event?.endDate)!)!
            
            self.txtTitulo.text = self.event?.title
            self.lblCliente.text = self.cita?.cliente?.nombre
            
            self.lblCita.text = self.event?.title
            self.lblFecha.text = self.dateFormatter.stringFromDate((self.event?.startDate)!)
            self.horas = self.stringFromTimeInterval(self.interval!)
            self.lblHoras.text = self.horas
        }
        
        if self.source == "New" {
            
            self.lblCliente.text = "+ Cliente Asociado"
            self.lblContrato.text = "+ Contrato Asociado"
            self.lblCita.text = "+ Cita Asociada"
            self.lblFecha.text = self.dateFormatter.stringFromDate(self.date!)
            self.lblHoras.text = "+ Horas Laboradas"
            self.citaAsociada.hidden = true
            self.fecha = self.date!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        
        var numberInterval:Int = 0
        
    if self.txtTitulo.text == "" {
        self.alertMessage("El tiempo debe tener un título.", winTitle: "Error")
    } else {
        if self.cliente == nil {
            self.alertMessage("El tiempo debe tener un cliente asignado.", winTitle: "Error")
        } else {
            if self.interval == nil {
                self.alertMessage("El tiempo debe tener horas asignadas.", winTitle: "Error")
            } else {
                numberInterval = Int(self.interval!)
                
                let alertController = UIAlertController(title: "Atención", message:
                    "Se guardarán " + self.horas + " como tiempo laborado. ¿Deseas continuar?", preferredStyle: UIAlertControllerStyle.Alert)
                
                // Cancel action
                alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default,handler: { (alertController) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }))
                
                // Save action
                alertController.addAction(UIAlertAction(title: "Convertir", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
                    
                    daoTiempo().newTiempo(self.txtTitulo.text!, hours: numberInterval, cita: self.cita, fecha: self.fecha, place: "", contract: self.contrato, entregable: nil, client: self.cliente!, store: self.eventStore)
                    
                    self.delegateAddress?.refreshUnconvertedDates()
                    
                    let alert = UIAlertView()
                    alert.title = "Tiempos"
                    alert.message = "El tiempo laborado se guardó exitosamente"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    }
    
    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d horas %02d minutos", hours, minutes)
    }

    func getTotalTime(start:NSDate, end:NSDate)->NSTimeInterval?{
        let interval:NSTimeInterval = end.timeIntervalSinceDate(start)
        return interval
    }
    
    func returnHoursToTime(time: NSDate, min: NSDate, max: NSDate) {
        
        self.interval = time.timeIntervalSinceDate(min)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm ZZZ"
        self.horas = self.stringFromTimeInterval(interval!)
        self.lblHoras.text = self.horas
    }
    
    func returnClientToDate(client: Cliente) {
        self.lblCliente.text = client.nombre!
        self.cliente = client
    }
    
    func returnHourContract(contract: Contrato) {
        self.lblContrato.text = contract.nombreContrato!
        self.contrato = contract
    }
    
    func returnDateTimeToDate(date: NSDate, type: String) {
        self.date = date
        self.lblFecha.text = self.dateFormatter.stringFromDate(self.date!)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "hoursModalSegue" {
            let vc:HoursModal = segue.destinationViewController as! HoursModal
            vc.delegateAddress = self
            vc.interval = self.interval
        }
        
        if segue.identifier == "clientModalSegue" {
            let vc:ClientePicker = segue.destinationViewController as! ClientePicker
            vc.delegateAddress = self
        }
        
        if segue.identifier == "contractModalSegue" {
            let vc:ContractHoursPicker = segue.destinationViewController as! ContractHoursPicker
            vc.delegateAddress = self
            vc.cliente = self.cliente
        }
        
        if segue.identifier == "selectDateSegue" {
            let vc:DateTimePicker = segue.destinationViewController as! DateTimePicker
            vc.delegateAddress = self
            
            if self.source == "Date" {
                vc.date = self.fecha
            }
            if self.source == "New" {
                vc.date = self.date
            }
        }
    }

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if identifier == "contractModalSegue" {
            
            if daoContrato().getAllActiveContractsPorHorasByClient(self.cliente!)!.count == 0 {
                self.alertMessage("Debe haber por lo menos un contrato creado.", winTitle: "Error")
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

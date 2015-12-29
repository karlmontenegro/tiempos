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

class NuevoTiempoTVC: UITableViewController, hoursOp, clientOp, contractOp {
    
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
    var interval = NSTimeInterval()
    
    @IBOutlet weak var lblCliente: UILabel!
    @IBOutlet weak var lblContrato: UILabel!
    @IBOutlet weak var lblCita: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblHoras: UILabel!
    @IBOutlet weak var txtTitulo: UITextField!
    
    @IBOutlet weak var citaAsociada: UITableViewCell!
    @IBOutlet weak var fechaAsociada: UITableViewCell!
    @IBOutlet weak var contratoAsociado: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.source == "Date" {
            self.event = daoCita().getEventByDateId(self.cita!, store: self.eventStore)
            self.dateFormatter.dateFormat = "ccc, dd MMM"
            self.lblCliente.text = self.cita?.cliente?.nombre
            self.lblContrato.text = self.cita?.contrato?.nombreContrato
            self.lblCita.text = self.event?.title
            self.lblFecha.text = self.dateFormatter.stringFromDate((self.event?.startDate)!)
            self.horas = self.stringFromTimeInterval(self.getTotalTime((self.event?.startDate)!, end: (self.event?.endDate)!)!)
            self.lblHoras.text = self.horas
            self.fecha = self.event?.startDate
            self.cliente = self.cita?.cliente
            self.contrato = self.cita?.contrato
            self.interval = self.getTotalTime((self.event?.startDate)!, end: (self.event?.endDate)!)!
        }
        
        if self.source == "New" {
            self.citaAsociada.hidden = true
            self.fechaAsociada.hidden = true
            self.contratoAsociado.hidden = true
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
        
        let numberInterval = Int(self.interval)
        
        let alertController = UIAlertController(title: "Atención", message:
            "Se guardarán " + self.horas + " como tiempo laborado. ¿Deseas continuar?", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Save action
        alertController.addAction(UIAlertAction(title: "Guardar", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
            
            daoTiempo().newTiempo(self.txtTitulo.text!, hours: numberInterval, cita: self.cita, fecha: self.fecha, place: "", contract: self.contrato, entregable: nil, client: self.cliente!, store: self.eventStore)
            
            let alert = UIAlertView()
            alert.title = "Tiempos"
            alert.message = "El tiempo laborado se guardó exitosamente"
            alert.addButtonWithTitle("OK")
            alert.show()
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        // Cancel action
        alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default,handler: { (alertController) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
        self.horas = self.stringFromTimeInterval(interval)
        self.lblHoras.text = self.horas
    }
    
    func returnClientToDate(client: Cliente) {
        self.lblCliente.text = client.nombre!
        self.cliente = client
    }
    
    func returnContractToDate(contract: Contrato) {
        self.lblContrato.text = contract.nombreContrato!
        self.contrato = contract
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
        }
        
        if segue.identifier == "clientModalSegue" {
            let vc:ClientePicker = segue.destinationViewController as! ClientePicker
            vc.delegateAddress = self
        }
        
        if segue.identifier == "contractModalSegue" {
            let vc:ContractPicker = segue.destinationViewController as! ContractPicker
            vc.delegateAddress = self
            vc.cliente = self.cliente
        }
    }


}

//
//  NuevaCitaTVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 6/11/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

/* Correcciones (11/01/16)

- Posible bug a la hora de crear nueva cita
- Fecha de inicio sugerida (Fecha actual y hora)
- Proponer fecha fin por default (1 hora)
- Añadir contrato se cae (cita necesita contrato)

*/

import UIKit
import Foundation
import EventKitUI

class NuevaCitaTVC: UITableViewController,clientOp,dateTimeOp,contractOp,alarmOp,entregableOp {

    @IBOutlet weak var lblCliente: UILabel!
    @IBOutlet weak var txtNomCita: UITextField!
    @IBOutlet var alarmSwitch: UISwitch!
    @IBOutlet weak var entregableCell: UITableViewCell!
    @IBOutlet weak var lblAlarm: UILabel!

    
    var cliente:Cliente? = nil
    var startDate:NSDate? = nil
    var endDate:NSDate? = nil
    var contrato:AnyObject? = []
    var entregable:Entregable? = nil
    let eventStore = EKEventStore()
    var alarm:EKAlarm? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func returnClientToDate(client: Cliente) {
        self.cliente = client
        self.lblCliente.text = client.nombre
    }
    
    func returnDateTimeToDate(date: NSDate, type: String) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let dateStr:String = dateFormatter.stringFromDate(date)
        
        let cellStart:UITableViewCell = tableView.cellForRowAtIndexPath(self.tableView.indexPathForSelectedRow!)!
        let cellEnd:UITableViewCell = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow!)!
        
        if type == "startDate" {
            self.startDate = date
            cellStart.detailTextLabel!.text = dateStr
        }
        if type == "endDate" {
            self.endDate = date
            cellEnd.detailTextLabel!.text = dateStr
        }
    }
    
    func returnContractToDate(contract: Contrato) {
        
        let cellContract:UITableViewCell = tableView.cellForRowAtIndexPath(self.tableView.indexPathForSelectedRow!)!
        
        self.contrato = contract
        cellContract.textLabel!.text = (contrato as! Contrato).nombreContrato
        cellContract.detailTextLabel!.text = (contrato as! Contrato).tipoFacturacion!
        
        if (contrato as! Contrato).tipoFacturacion! == "HRS" {
            entregableCell.hidden = true

        }else{
            entregableCell.hidden = false
        }
    }
    
    func returnReminderToDate(number: Int, measure: String) {
        
        var alarmOffset:NSTimeInterval
        var offset:Double = 0
        self.alarm = EKAlarm()
        
        if measure == "Minutos" {
            offset = Double(number * -60)
        }
        if measure == "Horas" {
            offset = Double(number * -3600)
        }
        if measure == "Días" {
            offset = Double(number * -86400)
        }
        alarmOffset = offset
        self.alarm?.relativeOffset = alarmOffset
        self.lblAlarm.text = number.description + " " + measure + " antes"
    }
    
    func returnEntregableToDate(entregable: Entregable) {
        self.entregable = entregable
        self.entregableCell.textLabel!.text = entregable.nombreEntreg
    }
    
    // MARK: - Table view data source

    @IBAction func saveTapped(sender: AnyObject) {
        
        daoCita().newDate(self.txtNomCita.text!, cliente: self.cliente!, start: self.startDate!, end: self.endDate!, contract: self.contrato as! Contrato,entregable: self.entregable, activateAlarm: self.alarmSwitch.on, alarm: self.alarm, store: self.eventStore)
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            self.performSegueWithIdentifier("datePickerSegue", sender: self)
        }
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                if self.cliente != nil {
                    self.performSegueWithIdentifier("contractPicker", sender: self)
                } else {
                    self.alertMessage("Selecciona un cliente primero.", winTitle: "Error")
                }
            }
            if indexPath.row == 1 {
                self.performSegueWithIdentifier("entregablePicker", sender: self)
            }
        }
        if indexPath.section == 3{
            self.performSegueWithIdentifier("addAlarmSegue", sender: self)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "clientPickerModal"{
            let vc:ClientePicker = segue.destinationViewController as! ClientePicker
            vc.delegateAddress = self
        }
        if segue.identifier == "datePickerSegue"{
            let vc:DateTimePicker = segue.destinationViewController as! DateTimePicker
            let indexpath:NSIndexPath = self.tableView.indexPathForSelectedRow!
            
            if indexpath.section == 1 && indexpath.row == 0 {
                //inicio
                vc.source = "startDate"
            }
            if indexpath.section == 1 && indexpath.row == 1 {
                //fin
                vc.source = "endDate"
            }
            vc.delegateAddress = self
        }
        if segue.identifier == "contractPicker" {
            let vc:ContractPicker = segue.destinationViewController as! ContractPicker
            vc.cliente = self.cliente
            vc.delegateAddress = self
        }
        if segue.identifier == "entregablePicker" {
            let vc:EntregablePicker = segue.destinationViewController as! EntregablePicker
            vc.contract = self.contrato as? Contrato
            vc.delegateAddress = self
        }
        if segue.identifier == "addAlarmSegue"{
            let vc:AlarmPicker = segue.destinationViewController as! AlarmPicker
            vc.delegateAddress = self
        }
    }
    
    func alertMessage(winMessage: String, winTitle: String){
        let alertController = UIAlertController(title: winTitle, message: winMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

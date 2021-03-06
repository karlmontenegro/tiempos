//
//  NuevaCitaTVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 6/11/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import Foundation
import EventKitUI

class NuevaCitaTVC: UITableViewController,clientOperations,dateTimeOp,alarmOp,entregableOp, contractOp,UITextFieldDelegate {

    @IBOutlet weak var lblCliente: UILabel!
    @IBOutlet weak var txtNomCita: UITextField!
    @IBOutlet var alarmSwitch: UISwitch!
    @IBOutlet weak var entregableCell: UITableViewCell!
    @IBOutlet weak var lblAlarm: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var cellContrato: UITableViewCell!

    var cliente:Cliente? = nil
    var startDate:NSDate? = nil
    var endDate:NSDate? = nil
    var contrato:Contrato? = nil
    var entregable:Entregable? = nil
    let eventStore = EKEventStore()
    var alarm:EKAlarm? = nil
    let dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "ccc, dd MMM hh:mm a"
        
        self.txtNomCita.delegate = self
        
        self.lblStartDate.text = self.dateFormatter.stringFromDate(self.startDate!)
        self.endDate = self.startDate!.dateByAddingTimeInterval(1.0 * 60.0 * 60.0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func returnClientToSource(client: Cliente) {
        self.cliente = client
        self.lblCliente.text = client.nombre
        
        print(client)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.txtNomCita.endEditing(true)
        return false
    }
    
    func returnDateTimeToDate(date: NSDate, type: String) {
        
        let dateStr:String = self.dateFormatter.stringFromDate(date)
        
        let cellStart:UITableViewCell = tableView.cellForRowAtIndexPath(self.tableView.indexPathForSelectedRow!)!
        
        let cellEnd:UITableViewCell = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow!)!
        
        if type == "startDate" {
            self.startDate = date
            self.endDate = date.dateByAddingTimeInterval(60*60)
            cellStart.detailTextLabel!.text = dateStr
        }
        if type == "endDate" {
            self.endDate = date
            cellEnd.detailTextLabel!.text = dateStr
        }
    }
    
    func returnContractToSource(contract: Contrato) {
        
        self.contrato = contract
        self.cellContrato.textLabel?.text = self.contrato!.nombreContrato
        
        if self.contrato!.tipoFacturacion! == "HRS" {
            self.cellContrato.detailTextLabel!.text = "Por Horas"
            entregableCell.hidden = true
        }else{
            if self.contrato!.tipoFacturacion! == "ENT" {
                self.cellContrato.detailTextLabel!.text = "Por Entregables"
                entregableCell.hidden = false
            } else {
                self.cellContrato.detailTextLabel!.text = "(Sin Facturación)"
                entregableCell.hidden = true
            }
        }
        self.tableView.reloadData()
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
        
        if self.txtNomCita.text == "" {
            self.alertMessage("Se requiere que la cita tenga un nombre", winTitle: "Error")
        } else {
            if self.cliente == nil {
                self.alertMessage("Es obligatorio asignarle un cliente a la cita", winTitle: "Error")
            } else {
                if self.startDate == nil {
                    self.alertMessage("Inicio de cita necesario", winTitle: "Error")
                } else {
                    if self.endDate == nil {
                        self.alertMessage("Fin de cita necesario", winTitle: "Error")
                    } else {
                        let c = daoCita().newDate(self.txtNomCita.text!, cliente: self.cliente!, start: self.startDate!, end: self.endDate!, contract: self.contrato ,entregable: self.entregable, activateAlarm: self.alarmSwitch.on, alarm: self.alarm, store: self.eventStore)
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                }
            }
        }
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
                if self.contrato != nil {
                    self.performSegueWithIdentifier("entregablePicker", sender: self)
                } else {
                    self.alertMessage("Selecciona un contrato primero.", winTitle: "Error")
                }
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
            let vc:ClientModal = segue.destinationViewController as! ClientModal
            vc.delegateAddress = self
        }
        if segue.identifier == "datePickerSegue"{
            let vc:DateTimePicker = segue.destinationViewController as! DateTimePicker
            let indexpath:NSIndexPath = self.tableView.indexPathForSelectedRow!
            
            if indexpath.section == 1 && indexpath.row == 0 {
                //inicio
                vc.source = "startDate"
                vc.date = self.startDate
            }
            if indexpath.section == 1 && indexpath.row == 1 {
                //fin
                vc.source = "endDate"
                vc.date = self.endDate
            }
            vc.delegateAddress = self
        }
        if segue.identifier == "contractPicker" {
            let vc:ContractModal = segue.destinationViewController as! ContractModal
            vc.cliente = self.cliente
            vc.delegateAddress = self
            vc.source = "ALL"
        }
        if segue.identifier == "entregablePicker" {
            let vc:EntregablePicker = segue.destinationViewController as! EntregablePicker
            vc.contract = self.contrato!
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

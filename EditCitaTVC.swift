//
//  EditCitaTVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 20/11/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import EventKit
import Foundation

protocol dateDetailOp{
    func reloadDateDetailInfo(event:EKEvent, date:Cita)
}

class EditCitaTVC: UITableViewController,clientOp,contractOp,alarmOp,dateTimeOp,entregableOp{

    @IBOutlet weak var txtNomCita: UITextField!
    @IBOutlet weak var lblNomCliente: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblNomContrato: UILabel!
    @IBOutlet weak var lblTipoFact: UILabel!
    @IBOutlet weak var lblEntregables: UILabel!
    @IBOutlet weak var lblAlarm: UILabel!
    @IBOutlet weak var AlarmState: UISwitch!
    @IBOutlet weak var entregableCell: UITableViewCell!
    
    var cita:Cita? = nil
    var cliente:Cliente? = nil
    var contrato:Contrato? = nil
    var entregable:Entregable? = nil
    var event:EKEvent? = nil
    var startDate:NSDate? = nil
    var endDate:NSDate? = nil
    var alarm:EKAlarm? = nil
    var origin:Bool = false
    var eventStore:EKEventStore? = nil
    var delegateAddress:dateDetailOp? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "ccc, dd MMM hh:mm a"
        
        self.txtNomCita.text = self.event?.title
        self.lblNomCliente.text = self.cita?.cliente?.nombre
        self.lblStartDate.text = dateFormatter.stringFromDate((self.event?.startDate)!)
        self.lblEndDate.text = dateFormatter.stringFromDate((self.event?.endDate)!)
        self.lblNomContrato.text = self.cita?.contrato?.nombreContrato
        
        self.cliente = self.cita?.cliente
        self.contrato = self.cita?.contrato
        self.startDate = self.event?.startDate
        self.endDate = self.event?.endDate
        self.entregable = self.cita?.entregable
        
        if self.cliente == nil {
            self.alertMessage("Esta cita ha sido creada fuera de Freelo, añada la información faltante", winTitle: "Atención")
            self.origin = true
        }
        
        if self.cita?.cliente == nil {
            self.lblNomCliente.text = "+ Añadir cliente"
        }
        
        if self.cita?.contrato?.tipoFacturacion == "HRS"{
            self.lblTipoFact.text = "Por Horas"
        }else{
            if self.cita?.contrato?.tipoFacturacion == "ENT" {
                self.lblTipoFact.text = "Por Entregables"
                
                if self.entregable != nil {
                    self.entregableCell.hidden = false
                    self.entregableCell.textLabel?.text = "Entregable: " + (self.entregable?.nombreEntreg!)!
                } else {
                    self.entregableCell.hidden = false
                    self.entregableCell.textLabel?.text = "+ Añadir entregable"
                }
                
            } else { //No tiene contrato asociado
                self.lblNomContrato.text = "+ Añadir contrato"
                self.lblTipoFact.text = "(Sin Facturación)"
                self.entregableCell.hidden = true
            }
        }
        
        if (self.event?.hasAlarms)! {
            self.AlarmState.on = true
            self.lblAlarm.text = self.event?.alarms![0].relativeOffset.description
            self.alarm = self.event?.alarms![0]
        }else{
            self.AlarmState.on = false
            self.lblAlarm.text = "+ Añadir recordatorios"
            self.AlarmState.enabled = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func returnClientToDate(client: Cliente) {
        self.cliente = client
        self.lblNomCliente.text = client.nombre
    }
    
    func returnDateTimeToDate(date: NSDate, type: String) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "ccc, dd MMM hh:mm a"
        
        if type == "startDate" {
            self.startDate = date
            self.lblStartDate.text = dateFormatter.stringFromDate(date)
        }
        if type == "endDate" {
            self.endDate = date
            self.lblEndDate.text = dateFormatter.stringFromDate(date)
        }

    }
    
    func returnContractToDate(contract: Contrato) {
        self.contrato = contract
        self.lblNomContrato.text = contract.nombreContrato
        
        if contract.tipoFacturacion == "HRS" {
            self.lblTipoFact.text = "Por Horas"
            self.entregableCell.hidden = true
        } else {
            self.lblTipoFact.text = "Por Entregables"
            self.entregableCell.hidden = false
            self.entregableCell.textLabel?.text = "+ Añadir entregable"
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
        self.lblAlarm.text = number.description + " " + measure
        self.AlarmState.enabled = true
        self.AlarmState.on = true
    }
    
    func returnEntregableToDate(entregable: Entregable) {
        self.entregable = entregable
        self.entregableCell.textLabel!.text = entregable.nombreEntreg!
    }

    @IBAction func saveTapped(sender: AnyObject) {
        if self.txtNomCita.text == "" {
            self.alertMessage("Es necesario darle un nombre a la cita.", winTitle: "Error")
        } else {
            if self.cliente == nil {
                self.alertMessage("La cita requiere un cliente obligatoriamente.", winTitle: "Error")
            } else {
                daoCita().updateDate(self.cita!, nomDate: self.txtNomCita.text!, cliente: self.cliente!, start: self.startDate!, end: self.endDate!, contract: self.contrato, entregable: self.entregable, alarm: self.alarm, event: self.event!, eventStore: self.eventStore!)
                
                self.delegateAddress?.reloadDateDetailInfo(self.event!, date: self.cita!)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

    @IBAction func cancelTapped(sender: AnyObject) {
        if self.origin == true {
            daoCita().deleteDate(self.cita!)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editNomClienteSegue"{
            let vc:ClientePicker = segue.destinationViewController as! ClientePicker
            vc.delegateAddress = self
        }
        if segue.identifier == "editStartDateSegue"{
            let vc:DateTimePicker = segue.destinationViewController as! DateTimePicker
            vc.source = "startDate"
            vc.delegateAddress = self
            vc.date = self.startDate
        }
        if segue.identifier == "editEndDateSegue"{
            let vc:DateTimePicker = segue.destinationViewController as! DateTimePicker
            vc.source = "endDate"
            vc.delegateAddress = self
            vc.date = self.endDate
        }
        if segue.identifier == "editContractSegue"{
            let vc:ContractPicker = segue.destinationViewController as! ContractPicker
            vc.cliente = self.cliente
            vc.delegateAddress = self
        }
        if segue.identifier == "editReminderSegue"{
            let vc:AlarmPicker = segue.destinationViewController as! AlarmPicker
            vc.delegateAddress = self
        }
        if segue.identifier == "editEntregableSegue"{
            let vc:EntregablePicker = segue.destinationViewController as! EntregablePicker
            vc.delegateAddress = self
            vc.entregable = self.entregable
            vc.contract = self.contrato
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "editContractSegue" {
            if daoContrato().getAllActiveContracts().count == 0 {
                self.alertMessage("Debe existir por lo menos un contrato en la aplicación.", winTitle: "Error")
                return false
            } else {
                if self.cliente?.contrato!.count == 0 {
                    self.alertMessage("El cliente debe tener por lo menos un contrato. Elija otro, o cree un contrato.", winTitle: "Error")
                    return false
                } else {
                    return true
                }
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

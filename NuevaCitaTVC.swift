//
//  NuevaCitaTVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 6/11/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import Foundation

class NuevaCitaTVC: UITableViewController,clientOp,dateTimeOp,contractOp,alarmOp {

    @IBOutlet weak var txtCliente: UITextField!

    
    var cliente:AnyObject? = []
    var startDate:NSDate? = nil
    var endDate:NSDate? = nil
    var contrato:AnyObject? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtCliente.enabled = false;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func returnClientToDate(client: Cliente) {
        self.cliente = client
        self.txtCliente.text = client.valueForKey("Nombre") as? String
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
    }
    
    func returnReminderToDate(number: Int, measure: String) {
        
    }
    
    // MARK: - Table view data source

    @IBAction func saveTapped(sender: AnyObject) {
        
        //daoCita().newDate(...data)
        
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
            self.performSegueWithIdentifier("contractPicker", sender: self)
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
        if segue.identifier == "addAlarmSegue"{
            let vc:AlarmPicker = segue.destinationViewController as! AlarmPicker
            vc.delegateAddress = self
        }
    }
}

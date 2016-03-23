//
//  ConvertirCitaTVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 26/11/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import EventKit

class ConvertirCitaTVC: UITableViewController, TimeOp {

    var cita:Cita? = nil
    var entregable:Entregable? = nil
    var event:EKEvent? = nil
    
    var realStartTime:NSDate? = nil
    var realEndTime:NSDate? = nil
    var resultingTime:String = ""
    
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblNewEndTime: UILabel!
    
    @IBOutlet weak var lblResultingHours: UILabel!
    @IBOutlet weak var lblNewStartTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        self.realStartTime = self.event?.startDate
        self.realEndTime = self.event?.endDate
        
        self.lblStartTime.text = dateFormatter.stringFromDate((self.event?.startDate)!)
        self.lblEndTime.text = dateFormatter.stringFromDate((self.event?.endDate)!)
        self.lblNewStartTime.text = dateFormatter.stringFromDate((self.event?.startDate)!)
        self.lblNewEndTime.text = dateFormatter.stringFromDate((self.event?.endDate)!)
        self.resultingTime = self.stringFromTimeInterval(self.getTotalTime(self.realStartTime!, end: self.realEndTime!)!)
        self.lblResultingHours.text = self.resultingTime
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func convertTapped(sender: UIBarButtonItem) {
        //Do the conversion
        
        let interval:NSTimeInterval = self.getTotalTime(self.realStartTime!, end: self.realEndTime!)!
        let numberInterval = Int(interval)
        
        let alertController = UIAlertController(title: "Atención", message:
            "Se guardarán " + self.resultingTime + " como tiempo laborado. ¿Deseas continuar?", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Save action
        alertController.addAction(UIAlertAction(title: "Guardar", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
            
            daoTiempo().newTiempo(self.cita!, title: (self.event?.title)!, converted: true, hours: NSNumber(integer: numberInterval), place: "", fact: (self.cita!.contrato?.tipoFacturacion)!)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        // Cancel action
        alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default,handler: { (alertController) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    func getTotalTime(start:NSDate, end:NSDate)->NSTimeInterval?{
        let interval:NSTimeInterval = end.timeIntervalSinceDate(start)
        
        return interval
    }
    
    func returnTimeToDate(date: NSDate, type:String) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        print(dateFormatter.stringFromDate(date))
        
        if type == "start" {
            self.lblNewStartTime.text = dateFormatter.stringFromDate(date)
            self.realStartTime = date
        }
        if type == "end" {
            self.lblNewEndTime.text = dateFormatter.stringFromDate(date)
            self.realEndTime = date
        }
        
        self.resultingTime = self.stringFromTimeInterval(self.getTotalTime(self.realStartTime!, end: self.realEndTime!)!)
        self.lblResultingHours.text = self.resultingTime
    }
    
    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        //let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d horas %02d minutos", hours, minutes)
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editEndTimeSegue" {
            let vc:TimePicker = segue.destinationViewController as! TimePicker
            vc.cita = self.event
            vc.origin = "end"
            vc.delegateAddress = self
        }
        if segue.identifier == "editStartTimeSegue" {
            let vc:TimePicker = segue.destinationViewController as! TimePicker
            vc.cita = self.event
            vc.origin = "start"
            vc.delegateAddress = self
        }
    }

}

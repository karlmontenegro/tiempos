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
        self.lblResultingHours.text = self.stringFromTimeInterval(self.getTotalTime(self.realStartTime!, end: self.realEndTime!)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func convertTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
        
        self.lblResultingHours.text = self.stringFromTimeInterval(self.getTotalTime(self.realStartTime!, end: self.realEndTime!)!)
    }
    
    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
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

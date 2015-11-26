//
//  ConvertirCitaTVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 26/11/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import EventKit

class ConvertirCitaTVC: UITableViewController {

    var cita:Cita? = nil
    var entregable:Entregable? = nil
    var event:EKEvent? = nil
    
    @IBOutlet weak var lblCitaName: UILabel!
    @IBOutlet weak var lblCitaClient: UILabel!
    @IBOutlet weak var lblContractName: UILabel!
    @IBOutlet weak var lblEntregableName: UILabel!
    
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblNewEndTime: UILabel!
    
    @IBOutlet weak var lblResultingHours: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblCitaName.text = self.event?.title
        self.lblCitaClient.text = self.cita?.cliente?.nombre
        self.lblContractName.text = self.cita?.contrato?.nombreContrato
        
        if self.cita?.entregable != nil {
            self.lblEntregableName.text = self.cita?.entregable?.nombreEntreg
        }else {
            self.lblEntregableName.text = "Por Horas"
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        //let resultDate:NSDate = self.getTotalTime((self.event?.startDate)!, end: (self.event?.endDate)!)!
        
        self.lblStartTime.text = dateFormatter.stringFromDate((self.event?.startDate)!)
        self.lblEndTime.text = dateFormatter.stringFromDate((self.event?.endDate)!)
        self.lblNewEndTime.text = dateFormatter.stringFromDate((self.event?.endDate)!)
        self.lblResultingHours.text = self.getTotalTime((self.event?.startDate)!, end: (self.event?.endDate)!)!.description
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getTotalTime(start:NSDate, end:NSDate)->NSTimeInterval?{
        let interval:NSTimeInterval = end.timeIntervalSinceDate(start)
        
        return interval
    }

}

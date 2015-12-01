//
//  TimePicker.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 26/11/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import EventKit

protocol TimeOp{
    func returnTimeToDate(date:NSDate, type:String)
}

class TimePicker: UIViewController {

    var cita:EKEvent? = nil
    var origin:String = ""
    var selectedDate:NSDate? = nil
    var delegateAddress:TimeOp? = nil
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedDate = self.timePicker.date
        
        if origin == "start" {
           self.timePicker.minimumDate = cita?.startDate
           self.timePicker.setDate((cita?.startDate)!, animated: true)
        }else {
            self.timePicker.minimumDate = cita?.endDate
            self.timePicker.setDate((cita?.endDate)!, animated: true)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneTapped(sender: AnyObject) {
        self.delegateAddress!.returnTimeToDate(self.selectedDate!,type: self.origin)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func selectedTime(sender: UIDatePicker) {
        self.selectedDate = self.timePicker.date
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

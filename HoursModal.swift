//
//  HoursModal.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 16/12/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

protocol hoursOp {
    func returnHoursToTime(time:NSDate, min:NSDate, max:NSDate)
}

class HoursModal: UIViewController {
    
    @IBOutlet weak var timePicker: UIDatePicker!
    var delegateAddress:hoursOp? = nil
    var selectedTime:NSDate? = nil
    var interval:NSTimeInterval? = nil
    var dateFormatter:NSDateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timePicker.datePickerMode = UIDatePickerMode.Time
        self.dateFormatter.dateFormat = "HH:mm"
        //self.timePicker.timeZone = NSTimeZone(abbreviation: "UTC");
        
        var dateString = "19:00"
        
        if self.interval != nil {
            print(NSDate(timeIntervalSinceReferenceDate: self.interval!))
            self.timePicker.date = NSDate(timeIntervalSinceReferenceDate: self.interval!)
        } else {
            //self.timePicker.date = self.dateFormatter.dateFromString(dateString)!
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    @IBAction func timePickerAction(sender: AnyObject) {
        self.selectedTime = self.timePicker.date
    }
    
    @IBAction func doneTapped(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm ZZZ"
        self.delegateAddress!.returnHoursToTime(self.selectedTime!, min: self.timePicker.minimumDate! , max: self.timePicker.maximumDate!)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancelTapped(sender: AnyObject) {
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

    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d horas %02d minutos", hours, minutes)
    }
}

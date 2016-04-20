//
//  DateRangeModal.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 20/04/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

protocol dateRangeOp{
    func returnRangeToHome(start:NSDate, end:NSDate)
}

class DateRangeModal: UIViewController {

    var delegateAddress:dateRangeOp? = nil
    var startDate:NSDate? = NSDate().dateByAddingMonths(-1)
    var endDate:NSDate? = NSDate()
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startDatePicker.date = NSDate().dateByAddingMonths(-1)
        self.endDatePicker.date = NSDate()
        self.endDatePicker.maximumDate = NSDate()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startPickerValueChanged(sender: AnyObject) {
        self.startDate = self.startDatePicker.date
    }
    
    @IBAction func endPickerValueChanged(sender: AnyObject) {
       self.endDate = self.endDatePicker.date
    }
    
    @IBAction func applyDateRange(sender: AnyObject) {
        self.delegateAddress?.returnRangeToHome(self.startDate!, end: self.endDate!)
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

}

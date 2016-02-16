//
//  DateTimePicker.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 12/11/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

protocol dateTimeOp{
    func returnDateTimeToDate(date:NSDate, type:String)
}

class DateTimePicker: UIViewController {

    var source:String = ""
    var date:NSDate? = nil
    var selectedDate:AnyObject? = []
    var delegateAddress:dateTimeOp? = nil
    
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateTimePicker.date = self.date!
        self.selectedDate = self.dateTimePicker.date
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dateTimePickerAction(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        self.selectedDate = self.dateTimePicker.date
    }

    @IBAction func doneButtonTapped(sender: AnyObject) {
        self.delegateAddress!.returnDateTimeToDate(dateTimePicker.date, type: self.source)
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

//
//  AlarmPicker.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 13/11/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

protocol alarmOp{
    func returnReminderToDate(number: Int, measure: String)
}

class AlarmPicker: UIViewController, UIPickerViewDelegate {

    let numberArray:Array<Int> = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
    
    let measureArray:Array<String> = ["Minutos","Horas","Días"]
    
    var number:Int = 0
    var measure:String = ""
    var delegateAddress:alarmOp? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.number = numberArray[0]
        self.measure = measureArray[0]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 2
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if (component == 0) {
            return self.numberArray.count;
        }
        else {
            return self.measureArray.count;
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if (component == 0){
            return self.numberArray[row].description
        }else{
            return self.measureArray[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (component == 0){
            self.number = self.numberArray[row]
        }else{
            self.measure = self.measureArray[row]
        }      
    }

    @IBAction func doneTapped(sender: AnyObject) {
        print(self.number)
        print(self.measure)
        self.delegateAddress!.returnReminderToDate(self.number, measure: self.measure)
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

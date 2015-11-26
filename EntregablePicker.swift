//
//  EntregablePicker.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 25/11/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import Foundation

protocol entregableOp {
    func returnEntregableToDate(entregable: Entregable)
}

class EntregablePicker: UIViewController, UIPickerViewDelegate {

    var contract:Contrato? = nil
    var entregable:Entregable? = nil
    var delegateAddress:entregableOp? = nil
    var entregableArray:Array<Entregable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.entregableArray = daoEntregable().getEntregablesByContract(self.contract!)
        self.entregable = self.entregableArray[0]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if entregableArray.isEmpty {
            return 0
        }else{
            return self.entregableArray.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return self.entregableArray[row].nombreEntreg!
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.entregable = self.entregableArray[row]
    }
    
    
    @IBAction func doneTapped(sender: UIButton) {
        self.delegateAddress!.returnEntregableToDate(self.entregable!)
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

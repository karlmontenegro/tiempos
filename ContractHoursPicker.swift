//
//  ContractHoursPicker.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 23/02/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

protocol contractHourOp {
    func returnHourContract(contract: Contrato)
}

class ContractHoursPicker: UIViewController {

    var cliente:AnyObject? = []
    var contract:AnyObject? = []
    var contractArray:Array<Contrato> = []
    var delegateAddress:contractHourOp? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contractArray = daoContrato().getAllActiveContractsPorHorasByClient(self.cliente as! Cliente)!
        self.contract = contractArray[0]
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
        if contractArray.isEmpty {
            return 0
        }else{
            return self.contractArray.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return self.contractArray[row].nombreContrato! as String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.contract = self.contractArray[row]
    }
    
    @IBAction func doneTapped(sender: AnyObject) {
        self.delegateAddress!.returnHourContract(self.contract as! Contrato)
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

}

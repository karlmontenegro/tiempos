//
//  ContractModal.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 16/03/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

protocol contractOp {
    func returnContractToSource(contract: Contrato)
}

class ContractModal: UIViewController, contractViewOperations {
    
    var cliente:AnyObject? = []
    var contract:AnyObject? = []
    var contractArray:Array<Contrato> = []
    var delegateAddress:contractOp? = nil
    var selected:Bool = false
    var source:String = ""
    
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var contractPickerOut: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.source == "HRS" {
            self.contractArray = daoContrato().getAllActiveContractsPorHorasByClient(self.cliente as! Cliente)!
        } else {
            self.contractArray = daoContrato().getAllContractsByClient(self.cliente as! Cliente)
        }
        
        self.selectedButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
        
        if !self.contractArray.isEmpty {
            self.contract = contractArray[0]
        } else {
            self.selectedButton.enabled = false
        }
        // Do any additional setup after loading the view.
    }
    
    func updateContent() {
        if self.source == "HRS" {
            self.contractArray = daoContrato().getAllActiveContractsPorHorasByClient(self.cliente as! Cliente)!
        }
        
        if self.source == "ALL"  {
            self.contractArray = daoContrato().getAllContractsByClient(self.cliente as! Cliente)
        }
        
        self.contractPickerOut.reloadAllComponents()
        self.selectedButton.enabled = true
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
        if contractArray.isEmpty {
            return ""
        } else {
            return self.contractArray[row].nombreContrato! as String
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selected = true
        if !contractArray.isEmpty {
            self.contract = self.contractArray[row]
        }
    }
    
    @IBAction func doneTapped(sender: AnyObject) {
        
        if !self.selected && !self.contractArray.isEmpty {
            self.contract = self.contractArray[0]
        }
        self.delegateAddress!.returnContractToSource(self.contract as! Contrato)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if segue.identifier == "newContractSegue" {
            let navVC = segue.destinationViewController as! UINavigationController
            let tableVC = navVC.viewControllers.first as! NuevoContratoTVC
            tableVC.origin = "NEW"
            tableVC.delegateAddress = self
        }
    }
    
}


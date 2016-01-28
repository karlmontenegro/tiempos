//
//  ClassifierPickerModal.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 28/12/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import Foundation

protocol classifierOp {
    func returnSelectedOption(selectedObject:AnyObject?, origin:String)
}

class ClassifierPickerModal: UIViewController,UIPickerViewDelegate {

    var type:String = ""
    var origin:String = ""
    var data:Array<AnyObject> = []
    
    var classifier:String = ""
    var classifierItem:AnyObject? = nil
    var delegateAddress:classifierOp? = nil
    var selectedObject:AnyObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.origin == "Classifier" {
            self.data.append("Clientes")
            self.data.append("Contratos")
            self.selectedObject = self.data[0]
        }
        
        if self.origin == "ClassifierItem" {
            if self.classifier == "Clientes" {
                self.data = daoCliente().getAllClients()
                self.selectedObject = self.data[0]
            }
            
            if self.classifier == "Contratos" {
                
                if self.type == "HRS" {
                    self.data = daoContrato().getAllActiveContractsPorHoras()!
                }
                if self.type == "ENT" {
                    self.data = daoContrato().getAllActiveContractsPorEntregables()!
                }
                self.selectedObject = self.data[0]
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return self.data.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if self.origin == "Classifier" {
            return (self.data as! Array<String>)[row]
        } else {
            if self.classifier == "Clientes" {
                return (self.data as! Array<Cliente>)[row].nombre!
            } else {
                return (self.data as! Array<Contrato>)[row].nombreContrato!
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedObject = self.data[row]
    }

    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func doneTapped(sender: AnyObject) {
        self.delegateAddress?.returnSelectedOption(self.selectedObject, origin: self.origin)
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

//
//  MonedaModal.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 5/10/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

protocol currencyOperations{
    func returnCurrency(currency: String)
}

class MonedaModal: UIViewController,UIPickerViewDelegate {

    let listaMonedas:NSArray = ["(S/.) PEN", "(US$) USD"]
    var moneda:String = ""
    var delegateAddress:currencyOperations? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        if listaMonedas.count > 0 {
            return listaMonedas.count
        } else{
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return listaMonedas[row] as? String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.moneda = listaMonedas[row] as! String
    }

    
    @IBAction func doneTapped(sender: UIButton) {
        self.delegateAddress!.returnCurrency(self.moneda)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

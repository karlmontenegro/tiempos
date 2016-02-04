//
//  MonedaModal.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 5/10/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

protocol currencyOperations{
    func returnCurrency(currency: Moneda)
}

class MonedaModal: UIViewController,UIPickerViewDelegate {

    let listaMonedas:Array<Moneda> = daoMoneda().getAllCurrency()!
    var moneda:Moneda? = nil
    var delegateAddress:currencyOperations? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.moneda = listaMonedas[0]
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
        return listaMonedas[row].id! + " " + listaMonedas[row].descripcion!
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.moneda = listaMonedas[row]
    }

    
    @IBAction func doneTapped(sender: UIButton) {
        self.delegateAddress!.returnCurrency(self.moneda!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

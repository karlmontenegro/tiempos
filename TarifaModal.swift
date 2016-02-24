//
//  TarifaModal.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 24/02/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

protocol tarifaOp {
    func returnUpdatedFees()
}

class TarifaModal: UIViewController {
    
    var currency:Moneda? = nil
    var tiempo:Tiempo? = nil
    var delegateAddress:tarifaOp? = nil

    @IBOutlet weak var txtMonto: UITextField!
    let currencyArray:Array<Moneda> = daoMoneda().getAllCurrency()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currency = self.currencyArray[0]
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
        return self.currencyArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return self.currencyArray[row].descripcion
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currency = self.currencyArray[row]
    }

    
    @IBAction func saveTapped(sender: AnyObject) {
        if self.txtMonto.text == "" {
            self.alertMessage("Debe asignarle una tarifa al tiempo.", winTitle: "Error")
        } else {
            if self.currency == nil {
                self.alertMessage("Debe asignarle una moneda al tiempo.", winTitle: "Error")
            } else {
                daoTiempo().updateTiempoForInvoice(self.tiempo!, tarifa: Double(self.txtMonto.text!)!, moneda: self.currency!)
                self.delegateAddress?.returnUpdatedFees()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
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
    
    func alertMessage(winMessage: String, winTitle: String){
        let alertController = UIAlertController(title: winTitle, message: winMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

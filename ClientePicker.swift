//
//  ClientePicker.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 10/11/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

protocol clientOp{
    func returnClientToDate(client:Cliente)
}

class ClientePicker: UIViewController, UIPickerViewDelegate {

    var listaClientes: NSArray = []
    var cliente:AnyObject? = []
    var delegateAddress:clientOp? = nil
    
    @IBOutlet var clientPicker: [UIPickerView]!
    @IBOutlet weak var clientPickerOut: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listaClientes = daoCliente().getAllClients()
        self.cliente = listaClientes[0]
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
        if listaClientes.count > 0 {
            return listaClientes.count
        } else{
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return listaClientes[row].valueForKey("nombre") as? String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.cliente = listaClientes[row]
    }

    @IBAction func doneTapped(sender: AnyObject) {
        self.delegateAddress!.returnClientToDate(self.cliente as! Cliente)
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

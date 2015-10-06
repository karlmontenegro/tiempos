//
//  ClientModal.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 5/10/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

protocol clientOperations{
    func returnClientToContract(client:Cliente)
}

class ClientModal: UIViewController, UIPickerViewDelegate{

    var listaClientes:NSArray = []
    var cliente:AnyObject? = []
    var delegateAddress:clientOperations? = nil
    @IBOutlet var clientPicker: [UIPickerView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listaClientes = daoCliente().getAllClients()

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
        self.cliente = listaClientes[row] as! Cliente
    }

    
    @IBAction func doneTapped(sender: UIButton) {
        self.delegateAddress!.returnClientToContract(self.cliente as! Cliente)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

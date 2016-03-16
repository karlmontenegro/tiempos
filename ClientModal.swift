//
//  ClientModal.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 5/10/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

protocol clientOperations{
    func returnClientToSource(client:Cliente)
}

class ClientModal: UIViewController, UIPickerViewDelegate, clientViewOperations {

    var listaClientes:Array<Cliente> = []
    var cliente:AnyObject? = []
    var delegateAddress:clientOperations? = nil
    var selected:Bool = false
    
    @IBOutlet var clientPicker: [UIPickerView]!
    @IBOutlet weak var clientPickerOut: UIPickerView!
    @IBOutlet weak var selectButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.listaClientes = daoCliente().getAllClients()
        self.selectButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
        
        if !self.listaClientes.isEmpty {
            self.cliente = listaClientes[0]
        } else {
            self.selectButton.enabled = false
            
        }
        // Do any additional setup after loading the view.
    }

    func updateContent() {
        self.listaClientes = daoCliente().getAllClients()
        self.clientPickerOut.reloadAllComponents()
        self.selectButton.enabled = true
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
        if !self.listaClientes.isEmpty {
            return listaClientes.count
        } else{
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if !self.listaClientes.isEmpty {
            return listaClientes[row].valueForKey("nombre") as? String
        } else {
            return ""
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selected = true
        if !self.listaClientes.isEmpty {
            self.cliente = listaClientes[row]
        }
    }
    
    @IBAction func doneTapped(sender: UIButton) {
        
        if !self.selected && !self.listaClientes.isEmpty { //user didn't use the picker
            self.cliente = self.listaClientes[0]
        }
        
        self.delegateAddress!.returnClientToSource(self.cliente as! Cliente)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newClientSegue" {
            let navVC = segue.destinationViewController as! UINavigationController
            let tableVC = navVC.viewControllers.first as! NuevoClienteTVC
            tableVC.source = "NEW"
            tableVC.delegate = self
        }
    }
}

//
//  NuevoContratoViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 15/09/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import CoreData

class NuevoContratoViewController: UIViewController, UIPickerViewDelegate {

    @IBOutlet weak var nomContrato: UITextField!
    @IBOutlet weak var tipoFac: UITextField!
    @IBOutlet var clientePicker: [UIPickerView]!
    
    var listaClientes:NSArray = []
    var cliente:AnyObject = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let daocliente = daoCliente()
        self.listaClientes = daocliente.getAllClients()
        // Do any additional setup after loading the view.
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
        cliente =  listaClientes[row] as! Cliente
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTapped(sender: UIBarButtonItem) {
        
        daoContrato().newContract(self.nomContrato.text!, tipoFact: self.tipoFac.text!, client: self.cliente as! Cliente)
        
         self.navigationController?.popToRootViewControllerAnimated(true)
    }

    @IBAction func cancelTapped(sender: UIBarButtonItem) {
         self.navigationController?.popToRootViewControllerAnimated(true)
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

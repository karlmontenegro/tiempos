//
//  NuevoContratoViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 15/09/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import CoreData

class NuevoContratoViewController: UIViewController,clientOperations,currencyOperations {
    
    @IBOutlet weak var nomContrato: UITextField!
    @IBOutlet weak var txtCliente: UILabel!
    @IBOutlet weak var txtMoneda: UILabel!
    @IBOutlet weak var txtTotal: UILabel!
    
    @IBOutlet weak var tarifaPorHora: UITextField!
    @IBOutlet weak var nroHoras: UITextField!

    @IBOutlet weak var heightConst: NSLayoutConstraint!
    @IBOutlet weak var nroHorasHeight: NSLayoutConstraint!
    @IBOutlet weak var tarifaHeight: NSLayoutConstraint!
    @IBOutlet weak var nroEntregablesHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTotalHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTotalNumHeight: NSLayoutConstraint!
    
    let animationDuration:NSTimeInterval = 0.25
    
    @IBAction func factSwitchChanged(sender: UISwitch) {
       
        if sender.on{
            self.tipoFact = "ENT"
            hideView()
            
        }else{
            self.tipoFact = "HRS"
            showView()
        }
        
        //Display container
        
    }
    
    var listaClientes:NSArray = []
    var listaMonedas:NSArray = ["PEN (S/.)","USD (US$)"]
    var cliente:AnyObject = []
    
    //HRS => Por Horas
    //ENT => Por Entregables
    
    var tipoFact:String = ""
    
    func hideView(){
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.nroHorasHeight.constant = 0.0
            self.tarifaHeight.constant = 0.0
            self.heightConst.constant = 0.0
            self.lblTotalHeight.constant = 0.0
            self.lblTotalNumHeight.constant = 0.0
            self.nroEntregablesHeight.constant = 30.0
            self.view.layoutIfNeeded()
        }
    }
    
    func showView(){
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.nroHorasHeight.constant = 30.0
            self.tarifaHeight.constant = 30.0
            self.heightConst.constant = 86.0
            self.lblTotalNumHeight.constant = 21.0
            self.lblTotalHeight.constant = 21.0
            self.nroEntregablesHeight.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func changedTextTarifa(sender: UITextField) {
        var op1:Float = 0.00
        var op2:Int = 0
        
        if self.nroHoras.text == "" {
            self.txtTotal.text = "0.00"
        }else{
           
        }
    }
    
    @IBAction func changedTextHoras(sender: UITextField) {
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        hideView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let daocliente = daoCliente()
        self.listaClientes = daocliente.getAllClients()
        self.txtTotal.text = "0.00"
        
        // Do any additional setup after loading the view.
    }
    
    func returnClientToContract(client: Cliente) {
        self.cliente = client
        self.txtCliente.text = client.valueForKey("Nombre") as? String
    }
    
    func returnCurrency(currency: String) {
        self.txtMoneda.text = currency
    }
    
    @IBAction func saveTapped(sender: UIBarButtonItem) {
        
        daoContrato().newContract(self.nomContrato.text!, tipoFact: self.tipoFact, client: self.cliente as! Cliente)
        
         self.navigationController?.popToRootViewControllerAnimated(true)
    }

    @IBAction func cancelTapped(sender: UIBarButtonItem) {
         self.navigationController?.popToRootViewControllerAnimated(true)
    }
    @IBAction func selectClient(sender: UIButton) {
        performSegueWithIdentifier("clientPickerModal", sender: sender)
    }
    @IBAction func selectCurrency(sender: UIButton) {
        performSegueWithIdentifier("currencyPickerModal", sender: sender)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "clientPickerModal"{
            let vc:ClientModal = segue.destinationViewController as! ClientModal
            vc.delegateAddress = self
        }
        if segue.identifier == "currencyPickerModal"{
            let vc:MonedaModal = segue.destinationViewController as! MonedaModal
            vc.delegateAddress = self
        }
    }
}

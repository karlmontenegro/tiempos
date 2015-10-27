//
//  NuevoContratoViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 15/09/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class NuevoContratoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,clientOperations,currencyOperations {
    
    var data:AnyObject? = []
    var origin:String = ""
    
    var arreglo:Array<Entregable> = []
    var arrReal:NSSet = []
    
    let animationDuration:NSTimeInterval = 0.25
    
    var listaClientes:NSArray = []
    var listaMonedas:NSArray = ["PEN (S/.)","USD (US$)"]
    var cliente:AnyObject = []
    
    //HRS => Por Horas
    //ENT => Por Entregables
    
    var tipoFact:String = "ENT"
    
    
    @IBOutlet weak var entregables: UITableView!
    @IBOutlet weak var nomContrato: UITextField!
    @IBOutlet weak var txtCliente: UILabel!
    @IBOutlet weak var txtMoneda: UILabel!
    @IBOutlet weak var tarifaPorHora: UITextField!
    @IBOutlet weak var nroHoras: UITextField!
    @IBOutlet weak var horasViewHeight: NSLayoutConstraint!
    @IBOutlet weak var totalheight: NSLayoutConstraint!
    @IBOutlet weak var nroHorasHeight: NSLayoutConstraint!
    @IBOutlet weak var tarifaHeight: NSLayoutConstraint!
    @IBOutlet weak var entregablesViewHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    @IBOutlet weak var navbar: UINavigationItem!
    @IBOutlet weak var factSwitch: UISwitch!
    @IBOutlet weak var PorHorasLabel: UILabel!
    @IBOutlet weak var PorEntregablesLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!



    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        hideView()
        let daocliente = daoCliente()
        self.listaClientes = daocliente.getAllClients()
        self.view.layoutIfNeeded()
        self.arrReal = (self.data as! Contrato).entregables!
        
        
        if self.origin == "NEW"{
            //Nuevo Contrato
            
            self.navbar.title = "Nuevo Contrato"
            self.txtCliente.text = ""
            self.txtMoneda.text = ""
            
        }else{
            //Editar Contrato
            
            let contrato:Contrato = self.data as! Contrato
            let tipoDeFacturacion:String = contrato.valueForKey("tipoFacturacion") as! String
            let clienteDeContrato:Cliente = ((self.data as! Contrato).valueForKey("cliente") as! Cliente)
            self.hideSwitchArea()
            self.navbar.title = "Editar Contrato"
            self.nomContrato.text = contrato.valueForKey("nombreContrato") as? String
            self.txtCliente.text = clienteDeContrato.valueForKey("nombre") as? String
            self.cliente = contrato.valueForKey("cliente")!
            self.txtMoneda.text = contrato.valueForKey("moneda") as? String
            
            if tipoDeFacturacion == "HRS"{
                let horasDeContrato:ContratoHoras = (self.data as! Contrato).valueForKey("contratoHoras") as! ContratoHoras
                showView()
                self.tarifaPorHora.text = (horasDeContrato.valueForKey("tarifaHora") as! Float).description
                self.nroHoras.text = (horasDeContrato.valueForKey("totalHoras") as! Float).description
                
                let nHoras:Double = horasDeContrato.valueForKey("totalHoras") as! Double
                let tHoras:Double = horasDeContrato.valueForKey("tarifaHora") as! Double
            
                self.totalLabel.text = "Total Referencial: " +  self.txtMoneda.text! as String + " " + (tHoras * nHoras).description
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func factSwitchChanged(sender: UISwitch) {
       
        if sender.on{
            self.tipoFact = "ENT"
            daoContratoHoras().deleteAllContractHoras(self.data as! Contrato)
            hideView()
        }else{
            self.tipoFact = "HRS"
            daoEntregable().deleteAllEntregables(self.data as! Contrato)
            let e:ContratoHoras = daoContratoHoras().genericContratoHoras()
            (self.data as! Contrato).addContratoHoras(e)
            self.entregables.reloadData()
            showView()
        }
        
        //Display container
        
    }
    
    
    //Utility Functions
    
    func hideView(){
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.nroHorasHeight.constant = 0.0
            self.tarifaHeight.constant = 0.0
            self.totalheight.constant = 0.0
            self.horasViewHeight.constant = 0.0
            self.entregablesViewHeight.constant = 259.0
            self.buttonHeight.constant = 30.0
            self.view.layoutIfNeeded()
        }
    }
    
    func showView(){
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.horasViewHeight.constant = 86.0
            self.nroHorasHeight.constant = 30.0
            self.tarifaHeight.constant = 30.0
            self.totalheight.constant = 30.0
            self.entregablesViewHeight.constant = 0.0
            self.buttonHeight.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }
    
    func hideSwitchArea(){
        self.factSwitch.hidden = true
        self.PorEntregablesLabel.hidden = true
        self.PorHorasLabel.hidden = true
    }
    
    func returnClientToContract(client: Cliente) {
        self.cliente = client
        self.txtCliente.text = client.valueForKey("Nombre") as? String
    }
    
    func returnCurrency(currency: String) {
        self.txtMoneda.text = currency
    }
    
    @IBAction func saveTapped(sender: UIBarButtonItem) {
        
        daoContrato().updateContract(self.nomContrato.text as String!, tipoFact: self.tipoFact, moneda: self.txtMoneda.text as String!, client: self.cliente as! Cliente, object: self.data as! Contrato)
        
        if self.tipoFact == "HRS" {
            daoContratoHoras().updateContractHoras(Double(self.nroHoras.text as String!)!,horasInc: "", tarifaHora: Double(self.tarifaPorHora.text as String!)!, moneda: self.txtMoneda.text as String!, object: (self.data as! Contrato).valueForKey("contratoHoras") as! ContratoHoras)
        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        if self.origin == "NEW"{
            daoContrato().deleteContractAt(self.data as! Contrato)
        }
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    @IBAction func selectClient(sender: UIButton) {
        performSegueWithIdentifier("clientPickerModal", sender: sender)
    }
    @IBAction func selectCurrency(sender: UIButton) {
        performSegueWithIdentifier("currencyPickerModal", sender: sender)
    }
    
    
    //Table View Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.arrReal.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("entregableCell", forIndexPath: indexPath)
        
            cell.textLabel!.text = "Entregable " + (indexPath.row + 1).description

        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            daoEntregable().deleteEntregableAt(self.arrReal.allObjects[indexPath.row] as! Entregable)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            print(self.data as! Contrato)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("entregableDetail", sender: self)
    }
    
    @IBAction func addCell(sender: AnyObject) {
        let e:Entregable = daoEntregable().genericEntregable()
        (self.data as! Contrato).addEntregable(e)
        self.arreglo.append(e)
        self.entregables.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "clientPickerModal"{
            let vc:ClientModal = segue.destinationViewController as! ClientModal
            vc.delegateAddress = self
        }
        if segue.identifier == "currencyPickerModal"{
            let vc:MonedaModal = segue.destinationViewController as! MonedaModal
            vc.delegateAddress = self
        }
        if segue.identifier == "entregableDetail"{
            let vc:EntregableVC = segue.destinationViewController as! EntregableVC
            let indexpath:NSIndexPath = self.entregables.indexPathForSelectedRow!
            vc.data = self.arrReal.allObjects[indexpath.row]
            vc.moneda = self.txtMoneda.text as String!
            vc.nro = indexpath.row + 1
        }
    }
}

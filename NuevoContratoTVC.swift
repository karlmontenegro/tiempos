//
//  NuevoContratoTVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 6/01/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

/* Correcciones (11/01/16)

- Horas Totales Opcional
- 
*/

import UIKit
import Foundation

class NuevoContratoTVC: UITableViewController,clientOperations,currencyOperations, entOperations  {
    
    @IBOutlet weak var navigationTitle: UINavigationItem!

    var contrato:Contrato? = nil
    var origin:String = ""
    
    var cliente:Cliente? = nil
    var moneda:Moneda? = daoConfiguracion().getConfig()?.moneda
    var tipoFact:String = "ENT"
    var hideSectionHoras:Int = 1
    var hideSectionEnt:Int = 0
    
    @IBOutlet weak var lblNombreCliente: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblTipoFacturacion: UILabel!
    @IBOutlet weak var factSwitch: UISwitch!
    @IBOutlet weak var txtNombreContrato: UITextField!

    //FACTURACIÓN POR HORAS
    
    @IBOutlet weak var txtTarifaPorHoras: UITextField!
    @IBOutlet weak var txtTotalHoras: UITextField!
    @IBOutlet weak var lblTotalReferencial: UILabel!
    var contratoHoras:ContratoHoras? = nil
    
    //FACTURACIÓN POR ENTREGABLES
    
    var numEntregables:Int = 0
    @IBOutlet weak var lblNumEntregables: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        if self.origin == "EDIT" {
            if self.contrato?.tipoFacturacion == "ENT" {
                self.hideSectionHoras = 1
                self.hideSectionEnt = 0
            } else {
                self.hideSectionEnt = 1
                self.hideSectionHoras = 0
            }
            self.factSwitch.hidden = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.origin == "NEW" {
            self.lblTipoFacturacion.text = "Por Entregables"
            self.lblTotalReferencial.text = "0.0"
            self.navigationTitle.title = "Nuevo Contrato"
            self.lblNumEntregables.text = "Entregables: " + self.numEntregables.description
            
            if self.moneda == nil {
                self.lblCurrency.text = "+ Moneda"
            } else {
                self.lblCurrency.text = (self.moneda?.id)! + (self.moneda?.descripcion)!
                daoContrato().updateContract("", tipoFact: "", moneda: self.moneda!, client: nil, object: self.contrato!)
            }
        }
        
        if self.origin == "EDIT" {
            self.cliente = self.contrato?.cliente
            self.moneda = (self.contrato?.moneda)!
            self.tipoFact = (self.contrato?.tipoFacturacion)!
            self.navigationTitle.title = "Editar Contrato"
            
            self.lblNombreCliente.text = self.cliente!.nombre
            self.txtNombreContrato.text = self.contrato?.nombreContrato
            
            if self.contrato?.tipoFacturacion == "ENT" {
                self.lblCurrency.text = (self.contrato?.moneda?.id)! + (self.contrato?.moneda?.descripcion)!
                self.lblTipoFacturacion.text = "Por Entregables"
                self.factSwitch.on = true
                self.lblNumEntregables.text = "Entregables: " + (self.contrato?.entregables!.count.description)!
                self.numEntregables = (self.contrato?.entregables!.count)!
            } else { //Por Horas
                
                self.contratoHoras = self.contrato?.contratoHoras
                self.lblCurrency.text = (self.contratoHoras?.moneda?.id)! + (self.contratoHoras?.moneda?.descripcion)!
                let tH:Double? = Double(contratoHoras!.tarifaHora!)
                let tT:Double? = Double(contratoHoras!.totalHoras!)
                
                self.factSwitch.on = false
                self.lblTipoFacturacion.text = "Por Horas"
                self.txtTarifaPorHoras.text = contratoHoras!.tarifaHora?.description
                self.txtTotalHoras.text = contratoHoras!.totalHoras?.description
                
                if tH != nil  && tT != nil {
                    self.lblTotalReferencial.text = (self.contratoHoras?.moneda?.id)! + (self.contratoHoras?.moneda?.descripcion)! + " " + (tH! * tT!).description
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ACTIONS

    @IBAction func switchValueChanged(sender: UISwitch) {
        if sender.on {
            self.lblTipoFacturacion.text = "Por Entregables"
            self.hideSectionHoras = 1
            self.hideSectionEnt = 0
            self.tipoFact = "ENT"
            self.txtTarifaPorHoras.text = ""
            self.txtTotalHoras.text = ""
            self.lblTotalReferencial.text = "0.0"
            self.tableView.reloadData()
            
        } else {
            self.lblTipoFacturacion.text = "Por Horas"
            self.hideSectionHoras = 0
            self.hideSectionEnt = 1
            self.tipoFact = "HRS"
            daoEntregable().deleteAllEntregables(self.contrato!)
            self.numEntregables = 0
            self.lblNumEntregables.text = "Entregables: 0"
            self.tableView.reloadData()
        }
    }

    @IBAction func horasTotalesChanged(sender: UITextField) {
        let tarHoras:Double? = Double(self.txtTarifaPorHoras.text!)
        let totalHoras:Double? = Double(self.txtTotalHoras.text!)
        
        if tarHoras != nil && totalHoras != nil {
            self.lblTotalReferencial.text = (self.moneda?.id)! + (self.moneda?.descripcion)! + " " + (tarHoras! * totalHoras!).description
        }
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        if self.txtNombreContrato.text == "" {
            self.alertMessage("El contrato debe llevar un nombre", winTitle: "Error")
        } else {
            if self.cliente == nil {
                self.alertMessage("El contrato debe llevar un cliente", winTitle: "Error")
            } else {
                if self.tipoFact == "ENT" {
                    if self.numEntregables == 0 {
                        self.alertMessage("El contrato por entregables debe tener por lo menos uno de éstos.", winTitle: "Error")
                    } else {
                        daoContrato().updateContract(self.txtNombreContrato.text!, tipoFact: self.tipoFact, moneda: self.moneda!, client: self.cliente!, object: self.contrato!)
                    }
                }
                if self.tipoFact == "HRS" {
                    daoContrato().updateContract(self.txtNombreContrato.text!, tipoFact: self.tipoFact, moneda: self.moneda!, client: self.cliente!, object: self.contrato!)
                    if self.txtTarifaPorHoras.text == "" {
                        self.alertMessage("EL contrato por horas debe tener una tarifa obligatoriamente.", winTitle: "Error")
                    }else {
                        self.contratoHoras = daoContratoHoras().genericContratoHoras()
                        daoContratoHoras().updateContractHoras(Double(self.txtTotalHoras.text!), horasInc: "", tarifaHora: Double(self.txtTarifaPorHoras.text!)!, moneda: self.moneda!, object: self.contratoHoras!)
                        daoContrato().addContratoHorasToContract(self.contratoHoras!, obj: self.contrato!)
                    }
                }
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }

    @IBAction func cancelTapped(sender: AnyObject) {
        if self.origin == "NEW" {
            daoContrato().deleteContractAt(self.contrato!)
        }
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // DELEGATE FUNCTIONS FOR CLIENT AND CURRENCY

    func returnClientToContract(client: Cliente) {
        self.cliente = client
        self.lblNombreCliente.text = self.cliente?.nombre
    }
    
    func returnCurrency(currency: Moneda) {
        self.moneda = currency
        self.lblCurrency.text = (self.moneda?.id)! + (self.moneda?.descripcion)!
        daoContrato().updateContract("", tipoFact: "", moneda: currency, client: nil, object: self.contrato!)
    }
    
    func returnNumEntregablesToContract(num: Int) {
        self.lblNumEntregables.text = "Entregables: " + num.description
        self.numEntregables = num
    }
    // FIXED TABLEVIEW OPERATIONS
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 4 { //Sección por Horas
            if self.hideSectionHoras == 1 && self.hideSectionEnt == 0 {
                return 0
            }
            if self.hideSectionHoras == 0 && self.hideSectionEnt == 1 {
                return 3
            }
        }
        
        if section == 5 { //Sección por Entregables
            if self.hideSectionHoras == 1 && self.hideSectionEnt == 0 {
                return 1
            }
            if self.hideSectionHoras == 0 && self.hideSectionEnt == 1 {
                return 0
            }
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.hideSectionHoras == 1 && section == 4 { //Sección por Horas
            return UIView.init(frame: CGRectZero)
        }
        
        if self.hideSectionEnt == 1 && section == 5 { //Sección por Entregables
            return UIView.init(frame: CGRectZero)
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 4 && self.hideSectionHoras == 1 { //Sección por Horas
            return 1
        }
        
        if section == 5 && self.hideSectionEnt == 1 { //Sección por Entregables
            return 1
        }
        return 32
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if self.hideSectionHoras == 1 && section == 4 { //Sección por Horas
            return UIView.init(frame: CGRectZero)
        }
        
        if self.hideSectionEnt == 1 && section == 5 { //Sección por Entregables
            return UIView.init(frame: CGRectZero)
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 4 && self.hideSectionHoras == 1 { //Sección por Horas
            return 1
        }
        
        if section == 5 && self.hideSectionEnt == 1 { //Sección por Entregables
            return 1
        }
        return 32
    }
    
    /*
    // NAVEGACIÓN

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "clientModalSegue" {
            let vc:ClientModal = segue.destinationViewController as! ClientModal
            vc.delegateAddress = self
        }
        if segue.identifier == "currencyModalSegue" {
            let vc:MonedaModal = segue.destinationViewController as! MonedaModal
            vc.delegateAddress = self
        }
        if segue.identifier == "entregablesSegue" {
            let navVC = segue.destinationViewController as! UINavigationController
            let tableVC = navVC.viewControllers.first as! EntregableTVC
            tableVC.contrato = self.contrato
            tableVC.delegateAddress = self
        }
    }
    
    func alertMessage(winMessage: String, winTitle: String){
        let alertController = UIAlertController(title: winTitle, message: winMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

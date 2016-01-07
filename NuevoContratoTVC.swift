//
//  NuevoContratoTVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 6/01/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import Foundation

class NuevoContratoTVC: UITableViewController,clientOperations,currencyOperations, entOperations  {

    var contrato:Contrato? = nil
    var origin:String = ""
    
    var cliente:Cliente? = nil
    var moneda:String = ""
    var tipoFact:String = ""
    var hideSectionHoras:Int = 1
    var hideSectionEnt:Int = 0
    
    @IBOutlet weak var lblNombreCliente: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblTipoFacturacion: UILabel!
    @IBOutlet weak var factSwitch: UISwitch!

    //FACTURACIÓN POR HORAS
    
    @IBOutlet weak var txtTarifaPorHoras: UITextField!
    @IBOutlet weak var txtTotalHoras: UITextField!
    @IBOutlet weak var lblTotalReferencial: UILabel!
    var contratoHoras:ContratoHoras? = nil
    
    //FACTURACIÓN POR ENTREGABLES
    
    var numEntregables:Int = 0
    @IBOutlet weak var lblNumEntregables: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.origin == "NEW" {
            self.lblTipoFacturacion.text = "Por Entregables"
            self.lblTotalReferencial.text = self.moneda + "0.0"
            self.navigationController?.title = "Nuevo Contrato"
        }
        
        if self.origin == "EDIT" {
            self.cliente = self.contrato?.cliente
            self.moneda = (self.contrato?.moneda)!
            self.tipoFact = (self.contrato?.tipoFacturacion)!
            self.navigationController?.title = "Editar Contrato"
            
            self.lblNombreCliente.text = self.cliente!.nombre
            self.lblCurrency.text = self.moneda
            
            if self.contrato?.tipoFacturacion == "ENT" {
                self.lblTipoFacturacion.text = "Por Entregables"
                self.factSwitch.on = true
                self.lblNumEntregables.text = "Entregables: " + (self.contrato?.entregables!.count.description)!
            } else { //Por Horas
                
                let contratoHoras = self.contrato?.valueForKey("contratoHoras") as! ContratoHoras
                let tH:Double? = Double(contratoHoras.tarifaHora!)
                let tT:Double? = Double(contratoHoras.totalHoras!)
                
                self.factSwitch.on = false
                self.lblTipoFacturacion.text = "Por Horas"
                self.txtTarifaPorHoras.text = contratoHoras.tarifaHora?.description
                self.txtTotalHoras.text = contratoHoras.totalHoras?.description
                
                if tH != nil  && tT != nil {
                    self.lblTotalReferencial.text = self.moneda + " " + (tH! * tT!).description
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
            self.tableView.reloadData()
            
        } else {
            self.lblTipoFacturacion.text = "Por Horas"
            self.hideSectionHoras = 0
            self.hideSectionEnt = 1
            self.tipoFact = "HRS"
            self.tableView.reloadData()
        }
    }

    @IBAction func horasTotalesChanged(sender: UITextField) {
        let tarHoras:Double? = Double(self.txtTarifaPorHoras.text!)
        let totalHoras:Double? = Double(self.txtTotalHoras.text!)
        
        if tarHoras != nil && totalHoras != nil {
            self.lblTotalReferencial.text = self.moneda + " " + (tarHoras! * totalHoras!).description
        }
    }
    
    
    @IBAction func saveTapped(sender: AnyObject) {
        daoContrato().updateContract((self.cliente?.nombre)!, tipoFact: self.tipoFact, moneda: self.moneda, client: self.cliente!, object: self.contrato!)
        if self.tipoFact == "HRS" {
            self.contratoHoras = daoContratoHoras().genericContratoHoras()
            daoContratoHoras().updateContractHoras(Double(self.txtTotalHoras.text!)!, horasInc: "", tarifaHora: Double(self.txtTarifaPorHoras.text!)!, moneda: self.moneda, object: self.contratoHoras!)
            self.contrato?.addContratoHoras(self.contratoHoras!)
        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)
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
    
    func returnCurrency(currency: String) {
        self.moneda = currency
        self.lblCurrency.text = self.moneda
    }
    
    func returnNumEntregablesToContract(num: Int) {
        self.lblNumEntregables.text = "Entregables: " + num.description
    }
    // FIXED TABLEVIEW OPERATIONS
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 3 {
            if self.hideSectionHoras == 1 && self.hideSectionEnt == 0 {
                return 0
            }
            if self.hideSectionHoras == 0 && self.hideSectionEnt == 1 {
                return 3
            }
        }
        
        if section == 4 {
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
        
        if self.hideSectionHoras == 1 && section == 3 {
            return UIView.init(frame: CGRectZero)
        }
        
        if self.hideSectionEnt == 1 && section == 4 {
            return UIView.init(frame: CGRectZero)
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 3 && self.hideSectionHoras == 1 {
            return 1
        }
        
        if section == 4 && self.hideSectionEnt == 1 {
            return 1
        }
        return 32
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if self.hideSectionHoras == 1 && section == 3 {
            return UIView.init(frame: CGRectZero)
        }
        
        if self.hideSectionEnt == 1 && section == 4 {
            return UIView.init(frame: CGRectZero)
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3 && self.hideSectionHoras == 1 {
            return 1
        }
        
        if section == 4 && self.hideSectionEnt == 1 {
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
}

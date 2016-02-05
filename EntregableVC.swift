//
//  EntregableVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 20/10/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

protocol entregableEditionOperations{
    func refreshTableViewForEntregables()
}

class EntregableVC: UIViewController {

    var data:AnyObject? = [] //Entregable
    var moneda:Moneda = daoConfiguracion().getConfig()!.moneda!
    var nro:Int = 0
    var mode:String = ""
    var delegateAddress:entregableEditionOperations? = nil
    
    @IBOutlet weak var txtEntregable: UILabel!
    @IBOutlet weak var txtNomEntregable: UITextField!
    @IBOutlet weak var txtTarifa: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var lblCurrency: UILabel!
    
    @IBAction func cancelTapped(sender: UIButton) {
        if self.mode == "NEW" {
           daoEntregable().deleteEntregableAt(self.data as! Entregable)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func saveTapped(sender: UIButton) {
        daoEntregable().updateEntregable(txtNomEntregable.text as String!, tarifa: txtTarifa.text as String!, object: self.data as! Entregable)
        self.delegateAddress!.refreshTableViewForEntregables()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveButton.enabled = false
        if mode == "NEW" {
            self.txtEntregable.text = "Nuevo Entregable"
        }else{
            self.txtEntregable.text = "Editar Entregable"
        }
        // Do any additional setup after loading the view.
        
        self.txtNomEntregable.text = (data as! Entregable).valueForKey("nombreEntreg") as? String
        if mode != "NEW" {
            self.txtTarifa.text = ((data as! Entregable).valueForKey("tarifa") as! Float).description
        }
        
        if (self.data as! Entregable).contrato?.moneda != nil {
            self.lblCurrency.text = ((data as! Entregable).contrato?.moneda?.id)! + ((data as! Entregable).contrato?.moneda?.descripcion)!
        } else {
            self.lblCurrency.text = (self.moneda.id)! + (self.moneda.descripcion)!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nomChanged(sender: AnyObject) {
        self.saveButton.enabled = true
    }
    
    @IBAction func tarifaChanged(sender: UITextField) {
        self.saveButton.enabled = true
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

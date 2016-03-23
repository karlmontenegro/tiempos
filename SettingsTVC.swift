//
//  SettingsTVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 29/12/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController,currencyOperations {

    var monto:Double = 0.0
    var moneda:Moneda? = nil
    var config:Configuracion = daoConfiguracion().getConfig()!
    
    
    @IBOutlet weak var txtMonto: UITextField!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtMonto.placeholder = config.defaultTarifaHora?.description
        
        if self.config.moneda == nil {
            self.lblCurrency.text = "+ Seleccionar moneda por defecto"
        } else {
            self.lblCurrency.text = "Moneda por defecto: " + (self.config.moneda?.id)! + " " + (self.config.moneda?.descripcion)!
        }
        
        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func returnCurrency(currency: Moneda) {
        self.moneda = currency
        self.lblCurrency.text! = "Moneda por defecto: " + (self.moneda?.id)! + " " + (self.moneda?.descripcion)!
    }

    @IBAction func saveTapped(sender: AnyObject) {
        self.alertMessage("Se sobreescribirán los parámetros de configuración. ¿Desea continuar?", winTitle: "Atención")
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "currencyModalSegue" {
            let vc:MonedaModal = segue.destinationViewController as! MonedaModal
            vc.delegateAddress = self
        }
    }
    
    func alertMessage(winMessage: String, winTitle: String){
        let alertController = UIAlertController(title: winTitle, message: winMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
            
            if self.txtMonto.text == "" {
                daoConfiguracion().storeConfig(0.0, moneda: self.moneda!, obj: self.config)
            } else {
                daoConfiguracion().storeConfig(Double(self.txtMonto.text!)!, moneda: self.moneda!, obj: self.config)
            }
            
            self.confirmationMessage("Configuración guardada exitosamente", winTitle: "Éxito!")
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func confirmationMessage(winMessage: String, winTitle: String){
        let alertController = UIAlertController(title: winTitle, message: winMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
            
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

//
//  DetalleClienteViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 5/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

class DetalleClienteViewController: UIViewController {

    var data:AnyObject = []
    
    @IBOutlet weak var lblRazonSocial: UILabel!
    @IBOutlet weak var lblRUC: UILabel!
    @IBOutlet weak var viewTitle: UINavigationItem!
    @IBOutlet weak var modalAddress: UIView!
    @IBOutlet weak var modalAddressFX: UIVisualEffectView!

    @IBOutlet weak var lblDireccion: UITextField!
    @IBOutlet weak var lblRefUno: UITextField!
    @IBOutlet weak var lblRefDos: UITextField!
    @IBOutlet weak var swMainAddress: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTitle.title = data.valueForKey("nombre") as! String?
        lblRazonSocial.text = "Razón Social: " + (data.valueForKey("razonSocial") as! String?)!
        lblRUC.text = "RUC: " + (data.valueForKey("ruc") as! String?)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addAddressTapped(sender: AnyObject) {
        UIView.transitionWithView(self.modalAddress, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.modalAddress.hidden = false
            self.modalAddressFX.hidden = false
            }, completion: { finished in
                // any code entered here will be applied
                // .once the animation has completed
        })
    }
    
    @IBAction func cancelNewAddress(sender: AnyObject) {
        UIView.transitionWithView(self.modalAddress, duration: 0.7, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.modalAddress.hidden = true
            self.modalAddressFX.hidden = true
            }, completion: { finished in
                // any code entered here will be applied
                // .once the animation has completed
        })
    }
    
    @IBAction func saveNewAddress(sender: AnyObject) {
        
        let DAODireccion = daoDireccion()
        let direccionF:String = (lblDireccion.text) as String + " " + (lblRefUno.text) as String + " " + (lblRefDos.text) as String
        
        DAODireccion.newAddress(data.valueForKey("usuario") as! Usuario, cliente: data as! Cliente, dir: direccionF, p: swMainAddress.on)
        
        var tv : UITableViewController = self.childViewControllers[1] as! UITableViewController
        tv.tableView.reloadData()
        tv.viewWillAppear(true)
        
        
        UIView.transitionWithView(self.modalAddress, duration: 0.7, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.modalAddress.hidden = true
            self.modalAddressFX.hidden = true
            }, completion: { finished in
                // any code entered here will be applied
                // .once the animation has completed
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "contactTableSegue"){
            let tvc:ContactosPorClienteTableViewController = segue.destinationViewController as! ContactosPorClienteTableViewController
            
            tvc.contactData = (self.data as! Cliente).contacto
        }
        if(segue.identifier == "addressTableSegue"){
            let tvc:DireccionesPorClienteTableViewController = segue.destinationViewController as! DireccionesPorClienteTableViewController
            
            tvc.addressData = self.data as! Cliente
        }
        if(segue.identifier == "cancelAddAddress"){
        }
    }

}

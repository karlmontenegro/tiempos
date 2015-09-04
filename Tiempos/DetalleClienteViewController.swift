//
//  DetalleClienteViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 5/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

class DetalleClienteViewController: UIViewController,refreshClientData,refreshAddressTable {

    var data:AnyObject = []
    
    @IBOutlet weak var lblRazonSocial: UILabel!
    @IBOutlet weak var lblRUC: UILabel!
    @IBOutlet weak var viewTitle: UINavigationItem!
    
    func refreshClientDelegate() {
        viewTitle.title = data.valueForKey("nombre") as! String?
        lblRazonSocial.text = "Razón Social: " + (self.data.valueForKey("razonSocial") as! String?)!
        lblRUC.text = "RUC: " + (self.data.valueForKey("ruc") as! String?)!
    }
    
    func refreshAddressesDelegate() {
        var tbc:UITableViewController = self.childViewControllers[0] as! UITableViewController
        tbc.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTitle.title = data.valueForKey("nombre") as! String?
        lblRazonSocial.text = "Razón Social: " + (self.data.valueForKey("razonSocial") as! String?)!
        lblRUC.text = "RUC: " + (self.data.valueForKey("ruc") as! String?)!
    }
    
    @IBAction func editClient(sender: UIButton) {
        performSegueWithIdentifier("editClientSegue", sender: sender)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addAddressTapped(sender: UIButton) {
        performSegueWithIdentifier("addAddress", sender: sender)
    }
    
    @IBAction func addNewContact(sender: UIButton) {
        performSegueWithIdentifier("addContact", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "contactTableSegue"){
            let tvc:ContactosPorClienteTableViewController = segue.destinationViewController as! ContactosPorClienteTableViewController
            tvc.contactData = (data as! Cliente).contacto
        }
        if(segue.identifier == "addressTableSegue"){

            let tvc:DireccionesPorClienteTableViewController = segue.destinationViewController as! DireccionesPorClienteTableViewController
            tvc.addressData = data as! Cliente
        }
        if(segue.identifier == "addAddress"){

            let tvc:NuevaDireccionViewController = segue.destinationViewController as! NuevaDireccionViewController
            tvc.data = self.data as! Cliente
            tvc.delegateAddress = self
        }
        if(segue.identifier == "editClientSegue"){

            let tvc:EditarCliente = segue.destinationViewController as! EditarCliente
            tvc.data = self.data as! Cliente
            tvc.delegateClient = self
        }
        if(segue.identifier == "editAddressSegue"){
            
        }
    }
}

//
//  DetalleClienteViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 5/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import AddressBook

class DetalleClienteViewController: UIViewController,refreshClientData,refreshAddressTable,refreshAddressTableAfterEdit,editAddress,showAddress {

    var data:AnyObject = []
    var direccion:AnyObject = []
    let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    
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
    
    func editAddressDelegate(direccion: AnyObject){
        self.direccion = direccion
        self.performSegueWithIdentifier("editAddressSegue", sender: self)
    }
    
    func showAddressModal(direccion: AnyObject){
        
        let dir:String = (direccion as! Direccion).direccion as String + ", " + (direccion as! Direccion).referenciaUno as String + ", " + (direccion as! Direccion).referenciaDos as String
        
        let alertController = UIAlertController(title: "Direccion", message:
            dir, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
        
        let authorizationStatus = ABAddressBookGetAuthorizationStatus()
        
        switch authorizationStatus {
        case .Denied, .Restricted:
            displayCantAddContactAlert()
            //println("Denied")
        case .Authorized:
            println("Authorized")
        case .NotDetermined:
            promptForAddressBookRequestAccess(sender)
            //println("Not Determined")
        }
        
        performSegueWithIdentifier("addContact", sender: sender)
    }
    
    func promptForAddressBookRequestAccess(addButton: UIButton) {
        var err: Unmanaged<CFError>? = nil
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef) {
            (granted: Bool, error: CFError!) in
            dispatch_async(dispatch_get_main_queue()) {
                if !granted {
                    self.displayCantAddContactAlert()
                    println("Just denied")
                } else {
                    println("Just authorized")
                }
            }
        }
    }
    
    func displayCantAddContactAlert() {
        let cantAddContactAlert = UIAlertController(title: "Cannot Add Contact",
            message: "You must give the app permission to add the contact first.",
            preferredStyle: .Alert)
        cantAddContactAlert.addAction(UIAlertAction(title: "Change Settings",
            style: .Default,
            handler: { action in
                self.openSettings()
        }))
        cantAddContactAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        presentViewController(cantAddContactAlert, animated: true, completion: nil)
    }
    
    func openSettings() {
        let url = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "contactTableSegue"){
            let tvc:ContactosPorClienteTableViewController = segue.destinationViewController as! ContactosPorClienteTableViewController
            tvc.contactData = (data as! Cliente).contacto
        }
        if(segue.identifier == "addressTableSegue"){

            let tvc:DireccionesPorClienteTableViewController = segue.destinationViewController as! DireccionesPorClienteTableViewController
            tvc.delegateAddress = self
            tvc.addressData = data as! Cliente
            tvc.delegateShow = self
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
            let tvc:EditarDireccionViewController = segue.destinationViewController as! EditarDireccionViewController
            tvc.data = self.direccion as! Direccion
            tvc.delegateAddress = self
        }
    }
}

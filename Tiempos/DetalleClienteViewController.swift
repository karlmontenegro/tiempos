//
//  DetalleClienteViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 5/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import AddressBook
import AddressBookUI

class DetalleClienteViewController: UIViewController,refreshClientData,refreshAddressTable,refreshAddressTableAfterEdit,editAddress,showAddress,showContact,ABPeoplePickerNavigationControllerDelegate {

    var data:AnyObject = []
    var origin:String = ""
    
    var direccion:AnyObject = []
    
    var addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil , nil).takeRetainedValue()
    
    var arrContactsData:NSMutableArray = []
    
    @IBOutlet weak var lblRazonSocial: UILabel!
    @IBOutlet weak var lblRUC: UILabel!
    @IBOutlet weak var viewTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Change button names depending on the origin
        
        switch origin{
            case "NEW":self.viewTitle.leftBarButtonItem?.title = "Grabar"
            self.viewTitle.rightBarButtonItem?.title = "Regresar"
            case "EDIT":
                self.viewTitle.rightBarButtonItem?.enabled = false
                self.viewTitle.leftBarButtonItem?.title = "Clientes"
                self.viewTitle.rightBarButtonItem?.title = ""
        default:
            self.viewTitle.rightBarButtonItem?.title = ""
            self.viewTitle.leftBarButtonItem?.title = ""
        }
 
        viewTitle.title = data.valueForKey("nombre") as! String?
        lblRazonSocial.text = "Razón Social: " + (self.data.valueForKey("razonSocial") as! String?)!
        lblRUC.text = "RUC: " + (self.data.valueForKey("ruc") as! String?)!        
    }
    
    func showContactInterface(contacto: AnyObject) {
        
        let peopleViewController = ABPersonViewController()
        
        let recordID:ABRecordID = (((contacto as! Contacto).valueForKey("recordRef")?.intValue) as ABRecordID?)!
        
        var recordRef:ABRecordRef? = ABAddressBookGetPersonWithRecordID(self.addressBookRef, recordID).takeRetainedValue()
        
        peopleViewController.displayedPerson = recordRef!
        self.navigationController?.pushViewController(peopleViewController, animated: true)
    }
    
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord) {
        let contact:NSMutableDictionary = ["firstName":"","lastName":"","mobileNumber":"","homeNumber":"","homeEmail":"","workEmail":"","address":"","zipCode":"","city":""]
        
        var names = ABRecordCopyValue(person, kABPersonFirstNameProperty)
        let recordId:ABRecordID = ABRecordGetRecordID(person)
        
        if names != nil{
            contact.setValue(names.takeRetainedValue() as! String, forKey: "firstName")
        }
        
        names = ABRecordCopyValue(person, kABPersonLastNameProperty)
        if names != nil{
            contact.setValue(names.takeRetainedValue() as! String, forKey: "lastName")
        }
        
        let idNumber:NSNumber = NSNumber(int: recordId)
        
        daoContacto().newContact(contact.valueForKey("firstName") as! String, lastName: contact.valueForKey("lastName") as! String, recordRef: idNumber,cliente: self.data as! Cliente)
        self.refreshAddressesDelegate()
    }
    
    func refreshClientDelegate() {
        viewTitle.title = data.valueForKey("nombre") as! String?
        lblRazonSocial.text = "Razón Social: " + (self.data.valueForKey("razonSocial") as! String?)!
        lblRUC.text = "RUC: " + (self.data.valueForKey("ruc") as! String?)!
    }
    
    func refreshAddressesDelegate() {
        let tbc:UITableViewController = self.childViewControllers[0] as! UITableViewController
        let tbd:UITableViewController = self.childViewControllers[1] as! UITableViewController
        tbc.tableView.reloadData()
        tbd.tableView.reloadData()
    }
    
    func editAddressDelegate(direccion: AnyObject){
        self.direccion = direccion
        self.performSegueWithIdentifier("editAddressSegue", sender: self)
    }
    
    func showAddressModal(direccion: AnyObject){
        
        let dir:String = (direccion as! Direccion).direccion! as String + ", " + (direccion as! Direccion).referenciaUno! as String + ", " + (direccion as! Direccion).referenciaDos! as String
        
        let alertController = UIAlertController(title: "Dirección", message:
            dir, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
        let people = ABPeoplePickerNavigationController()
        people.peoplePickerDelegate = self
        people.editing = true
        presentViewController(people, animated: true, completion: nil)
        
    }
    
    @IBAction func rightButtonPressed(sender: UIBarButtonItem) {
        
        switch origin{
            case "NEW":
            //delete the client
            daoCliente().deleteClientAt(self.data as! Cliente)
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            case "EDIT": print("none")
        default: print("none")
        }
    }
    
    @IBAction func leftButtonPressed(sender: UIBarButtonItem) {
        
        switch origin{
            case "NEW":
                self.navigationController?.popToRootViewControllerAnimated(true)
            case "EDIT":
                //save the object
                self.navigationController?.popToRootViewControllerAnimated(true)
        default: print("none")
        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "contactTableSegue"){
            let tvc:ContactosPorClienteTableViewController = segue.destinationViewController as! ContactosPorClienteTableViewController
            tvc.contactData = data as! Cliente
            tvc.delegateContact = self
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

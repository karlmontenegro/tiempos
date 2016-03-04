//
//  NuevoClienteTVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 15/02/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import AddressBook
import AddressBookUI

class NuevoClienteTVC: UITableViewController,refreshAddressTable,refreshAddressTableAfterEdit,ABPeoplePickerNavigationControllerDelegate {

    
    var cliente:Cliente = daoCliente().newClient("", ruc: "", razonSoc: "", direccion: "", usuario: "")
    
    var rowCountPhones:Int = 0
    var rowCountAddresses:Int = 0
    var rowAdded:Bool = false
    
    var contactArray:Array<Contacto>? = nil
    
    var addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil , nil).takeRetainedValue()
    var arrContactsData:NSMutableArray = []
    
    
    var addressArray:Array<Direccion>? = nil
    var editableAddress:Direccion? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contactArray = self.cliente.contacto?.allObjects as? Array<Contacto>
        self.addressArray = self.cliente.direccion?.allObjects as? Array<Direccion>
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshAddressesDelegate() {
        self.contactArray = self.cliente.contacto?.allObjects as? Array<Contacto>
        self.addressArray = self.cliente.direccion?.allObjects as? Array<Direccion>
        
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            return 3
        } else {
            if section == 1 { //Contactos
                if contactArray != nil {
                    return contactArray!.count + 1
                } else {
                    return 1
                }
            } else {
                if addressArray != nil {
                    return addressArray!.count + 1
                } else {
                    return 1
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Información del Cliente"
        }
        if section == 1 {
            return "Contactos"
        }
        if section == 2 {
            return "Direcciones"
        }
        return ""
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as! TextInputTableViewCell
                cell.configure(text: "", placeholder: "Nombre")
                return cell
            }
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as! TextInputTableViewCell
                cell.configure(text: "", placeholder: "Razón Social")
                return cell
            }else {
                let cell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as! TextInputTableViewCell
                cell.configure(text: "", placeholder: "RUC")
                return cell
            }
        }else {
            if indexPath.section == 1 {
                if indexPath.row == 0 {
                    let addContactCell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("addContactButton", forIndexPath:  indexPath)
                    return addContactCell
                } else {
                    let contactCell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("contactCell", forIndexPath: indexPath)
                    
                    if self.contactArray != nil {
                        contactCell.textLabel?.text = self.contactArray![indexPath.row - 1].firstName! + " " + self.contactArray![indexPath.row - 1].lastName!
                    }
                    
                    return contactCell
                }
            } else {
                if indexPath.row == 0 {
                    let addAddressCell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("addAddressButton", forIndexPath:  indexPath)
                    return addAddressCell
                } else {
                    let addressCell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("addressCell", forIndexPath: indexPath)
                    
                    if self.addressArray != nil {
                        addressCell.textLabel?.text = self.addressArray![indexPath.row - 1].direccion
                        
                        if self.addressArray![indexPath.row - 1].principal!.boolValue {
                            addressCell.detailTextLabel?.text = "Principal"
                        } else {
                            addressCell.detailTextLabel?.text = ""
                        }
                    }
                    
                    return addressCell
                }
            }
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 { //Botón de Contactos
                let people = ABPeoplePickerNavigationController()
                people.peoplePickerDelegate = self
                people.editing = true
                presentViewController(people, animated: true, completion: nil)
            } else { //Lista de Contactos
                print(self.contactArray![indexPath.row - 1])
                    
                //self.showContactInterface(self.contactArray![indexPath.row - 1])
            }
        }
        if indexPath.section == 2 { //Botón de Direcciones
            if indexPath.row > 0 { //Lista de Direcciones
                self.showAddressModal(self.addressArray![indexPath.row - 1])
            }
        }
    }
    

    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        
        if indexPath.section == 2 { //Direcciones
        
            let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Borrar" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // Alerts before the delete just in case it wasn't meant to be
                let alertController = UIAlertController(title: "Atención", message:
                "¿Estás seguro que quieres borrar esta dirección?", preferredStyle: UIAlertControllerStyle.Alert)
            
                // Delete action
                alertController.addAction(UIAlertAction(title: "Borrar", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
                // Deletes the row from the DAO
                daoDireccion().deleteAddressAt(self.addressArray![indexPath.row - 1])
                
                // Deletes the element from the array
                self.addressArray!.removeAtIndex(indexPath.row - 1)
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }))
            
            // Cancel action
            alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default,handler: { (alertController) -> Void in
                self.tableView.reloadData()
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            })
            
            let edit = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Editar", handler: { (action: UITableViewRowAction!, indexPath:NSIndexPath) -> Void in
                self.editableAddress = self.addressArray![indexPath.row - 1]
                self.performSegueWithIdentifier("editAddressSegue", sender: self)
            })
            
            delete.backgroundColor = UIColor.redColor()
            edit.backgroundColor = UIColor.orangeColor()
            
            return [edit,delete]
        } else {
            return nil
        }
    }
    
    
    @IBAction func saveTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        daoCliente().deleteClientAt(self.cliente)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "addAddressSegue" {
            let vc:NuevaDireccionViewController = segue.destinationViewController as! NuevaDireccionViewController
            vc.delegateAddress = self
            vc.data = self.cliente
        }
        
        if segue.identifier == "editAddressSegue" {
            let vc:EditarDireccionViewController = segue.destinationViewController as! EditarDireccionViewController
            vc.delegateAddress = self
            vc.data = self.editableAddress!
        }
    }
    
    //AUX FUNCTIONS
    
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
        
        daoContacto().newContact(contact.valueForKey("firstName") as! String, lastName: contact.valueForKey("lastName") as! String, recordRef: idNumber,cliente: self.cliente)
        self.refreshAddressesDelegate()
    }
    
    func showContactInterface(contacto: Contacto) {
        
        let peopleViewController = ABPersonViewController()
        
        let recordID:ABRecordID = (contacto.recordRef?.intValue as ABRecordID?)!
        
        let recordRef:ABRecordRef? = ABAddressBookGetPersonWithRecordID(self.addressBookRef, recordID).takeRetainedValue()
        
        peopleViewController.displayedPerson = recordRef!
        self.navigationController?.pushViewController(peopleViewController, animated: true)
    }
    
    func showAddressModal(direccion: AnyObject){
        let dir:String = (direccion as! Direccion).direccion! as String + ", " + (direccion as! Direccion).referenciaUno! as String + ", " + (direccion as! Direccion).referenciaDos! as String
        
        let alertController = UIAlertController(title: "Dirección", message:
            dir, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

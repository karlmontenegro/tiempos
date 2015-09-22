//
//  DAOContacto.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class daoContacto{
    
    func newContact(firstName: String, lastName: String, recordRef: NSNumber, cliente: Cliente){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let entityAddress = NSEntityDescription.entityForName("Contacto", inManagedObjectContext: context)
        
        let newContact = Contacto(entity: entityAddress!, insertIntoManagedObjectContext: context)
        
        newContact.setValue(firstName, forKey: "firstName")
        newContact.setValue(lastName, forKey: "lastName")
        newContact.setValue(cliente, forKey: "cliente")
        newContact.recordRef = recordRef
        
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func deleteContactAt(contacto: Contacto){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        context.deleteObject(contacto)
        
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func getAllContacts()->Array<Contacto>{
        return []
    }
}
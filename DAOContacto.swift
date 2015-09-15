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
    
    func newContact(firstName: String, lastName: String, recordRef: NSNumber){
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var entityAddress = NSEntityDescription.entityForName("Contacto", inManagedObjectContext: context)
        
        var error:NSError?
        
        let newContact = Contacto(entity: entityAddress!, insertIntoManagedObjectContext: context)
        
        newContact.setValue(firstName, forKey: "firstName")
        newContact.setValue(lastName, forKey: "lastName")
        //newContact.recordRef = recordRef
        
        if !context.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }else{
            println(newContact)
        }
    }
    
    func getAllContacts()->Array<Contacto>{
        return []
    }
}
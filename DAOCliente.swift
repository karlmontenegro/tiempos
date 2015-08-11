//
//  DAOCliente.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 10/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class daoCliente{
    
    func newClient(nombre: String, ruc: String, razonSoc: String, direccion:String){
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var newClient = NSEntityDescription.insertNewObjectForEntityForName("Cliente",inManagedObjectContext: context) as!NSManagedObject
        
        newClient.setValue(ruc, forKey: "ruc")
        newClient.setValue(nombre, forKey: "nombre")
        newClient.setValue(razonSoc, forKey: "razonSocial")
        newClient.setValue(direccion, forKey: "direccion")
        
        context.save(nil)
    }
    
    func getAllClients()->NSArray{
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Cliente")
        request.returnsObjectsAsFaults = false;
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        return results
    }
    
}
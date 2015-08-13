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
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func newClient(nombre: String, ruc: String, razonSoc: String, direccion:String, usuario: String){
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        let defaults = NSUserDefaults.standardUserDefaults()
        var entityUsuario = NSEntityDescription.entityForName("Usuario",
            inManagedObjectContext:context)
        let request = NSFetchRequest()
        request.entity = entityUsuario
        
        let pred = NSPredicate(format: "(objectID = %@)", defaults.stringForKey(usuario)!)
        request.predicate = pred

        
        
        var newClient = NSEntityDescription.insertNewObjectForEntityForName("Cliente",inManagedObjectContext: context) as!NSManagedObject
        
        newClient.setValue(ruc, forKey: "ruc")
        newClient.setValue(nombre, forKey: "nombre")
        newClient.setValue(razonSoc, forKey: "razonSocial")
        newClient.setValue(direccion, forKey: "direccion")
        
        //Extraer el usuario usando el stringForKey
        
        
        
        //newClient.setValue(defaults.stringForKey(usuario), forKey: "usuario")
        
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
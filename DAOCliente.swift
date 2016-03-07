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
    
    func genericClient()->Cliente {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let newClient = NSEntityDescription.insertNewObjectForEntityForName("Cliente",inManagedObjectContext: context)
        
        newClient.setValue("", forKey: "ruc")
        newClient.setValue("", forKey: "nombre")
        newClient.setValue("", forKey: "razonSocial")
        
        do{
            try context.save()
        }catch{
            print(error)
        }
        
        return newClient as! Cliente
    }
    
    func newClient(nombre: String, ruc: String, razonSoc: String, direccion:String, usuario: String)->Cliente{
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext

        let newClient = NSEntityDescription.insertNewObjectForEntityForName("Cliente",inManagedObjectContext: context)
        
        newClient.setValue(ruc, forKey: "ruc")
        newClient.setValue(nombre, forKey: "nombre")
        newClient.setValue(razonSoc, forKey: "razonSocial")
              
        do{
            try context.save()
        }catch{
            print(error)
        }
        
        return newClient as! Cliente
    }
    
    func getAllClients()->Array<Cliente>{
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "Cliente")
        
        request.returnsObjectsAsFaults = false
        
        var results:Array<Cliente> = []
        
        do{
            try results = context.executeFetchRequest(request) as! Array<Cliente>
        }catch{
            print(error)
        }
        return results
    }
    
    func deleteClientAt(object: Cliente){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        context.deleteObject(object)
        
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func updateClient(object: Cliente, nombre: String, razSoc: String, ruc: String){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        object.setValue(nombre, forKey: "nombre")
        object.setValue(razSoc, forKey: "razonSocial")
        object.setValue(ruc, forKey: "ruc")
        
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func getClientById(object: Cliente)->Cliente{
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let entityCliente = NSEntityDescription.entityForName("Cliente", inManagedObjectContext: context)
        let request = NSFetchRequest()
        //let pred = NSPredicate(format: "self = %@", object)
        request.entity = entityCliente
        
        var result:NSArray = []
        
        do{
            try result = context.executeFetchRequest(request)
        }catch{
            print(error)
        }
        
        return result[0] as! Cliente
    }
}
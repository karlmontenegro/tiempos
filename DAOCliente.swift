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
    func newClient(nombre: String, ruc: String, razonSoc: String, direccion:String, usuario: String){
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!

        //var entityUsuario = NSEntityDescription.entityForName("Usuario",inManagedObjectContext:context)
        //let request = NSFetchRequest()
        //request.entity = entityUsuario
        
        //let pred = NSPredicate(format: "(username = %@)", usuario)
        //request.predicate = pred
        
        //var results:NSArray = context.executeFetchRequest(request, error: nil)!

        var newClient = NSEntityDescription.insertNewObjectForEntityForName("Cliente",inManagedObjectContext: context) as!NSManagedObject
        
        newClient.setValue(ruc, forKey: "ruc")
        newClient.setValue(nombre, forKey: "nombre")
        newClient.setValue(razonSoc, forKey: "razonSocial")
        
        //Extraer el usuario usando el stringForKey
        
        //newClient.setValue(results.firstObject as! Usuario, forKey: "usuario")
        
        context.save(nil)
    }
    
    func getAllClients()->Array<Cliente>{
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Cliente")
        request.returnsObjectsAsFaults = false;
        
        var results:Array = context.executeFetchRequest(request, error: nil)! as! Array<Cliente>
        return results
    }
    
    func deleteClientAt(object: Cliente){
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        context.deleteObject(object)
        context.save(nil)
    }
    
    func updateClient(object: Cliente, nombre: String, razSoc: String, ruc: String){
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        object.setValue(nombre, forKey: "nombre")
        object.setValue(razSoc, forKey: "razonSocial")
        object.setValue(ruc, forKey: "ruc")
        
        context.save(nil)
    }
    
    func getClientById(object: Cliente)->Cliente{
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var entityCliente = NSEntityDescription.entityForName("Cliente", inManagedObjectContext: context)
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "self = %@", object)
        request.entity = entityCliente
        
        var result:NSArray = context.executeFetchRequest(request, error: nil)!
        
        return result[0] as! Cliente
    }
}
//
//  DAOEntregable.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class daoEntregable{
    func genericEntregable()->Entregable{ //Entregable vacio
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let newEntregable = NSEntityDescription.insertNewObjectForEntityForName("Entregable", inManagedObjectContext: context)
        
        
        do{
            try context.save()
        }catch{
            print(error)
        }
        return newEntregable as! Entregable
    }
    func deleteEntregableAt(object: Entregable){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        context.deleteObject(object)
        
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func deleteAllEntregables(object: Contrato){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let set = object.allEntregables()
        
        for s in set{
            context.deleteObject(s as! NSManagedObject)
        }
        
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func updateEntregable(nombre: String, tarifa: String, moneda: Moneda, object: Entregable, entrega: NSDate?){
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let numTarifa = Float(tarifa)
        let num = NSNumber(float: numTarifa!)
        
        if entrega != nil {
            object.setValue(entrega!, forKey: "fechaEntrega")
        }
        
        object.setValue(nombre, forKey: "nombreEntreg")
        object.setValue(num, forKey: "tarifa")
        object.setValue(moneda, forKey: "moneda")
        
        do{
            try context.save()
        }catch{
            print(error)
        }
        
    }
    
    func getAllEntregables()->Dictionary<Cliente,Array<Entregable>>? {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest()
        
        let entityEntregable = NSEntityDescription.entityForName("Entregable", inManagedObjectContext: context)
        let contratoSortDescriptor = NSSortDescriptor(key: "contrato.nombreContrato", ascending: true)
        let clienteSortDescriptor = NSSortDescriptor(key: "contrato.cliente.nombre", ascending: true)
        let dateSortDescriptor = NSSortDescriptor(key: "fechaEntrega", ascending: true)
        
        let pred = NSPredicate(format: "(reciboDetalle = NIL)")
        
        request.entity = entityEntregable
        request.predicate = pred
        request.sortDescriptors = [clienteSortDescriptor,contratoSortDescriptor,dateSortDescriptor]
        request.returnsObjectsAsFaults = false
        
        var results:Array<Entregable> = []
        
        do{
            try results = context.executeFetchRequest(request) as! Array<Entregable>
        }catch{
            print(error)
        }
        return self.classifyEntregablesByClient(results)
    }
    
    func getEntregablesByContract(contract:Contrato)->Array<Entregable>{
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let entityEntregable = NSEntityDescription.entityForName("Entregable", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "(contrato = %@)", contract)
        
        request.entity = entityEntregable
        request.predicate = pred
        
        var result:NSArray = []
        
        do{
            try result = context.executeFetchRequest(request)
        }catch{
            print(error)
        }
        
        return result as! Array<Entregable>
    }
    func getActiveEntregablesByContract(contract:Contrato)->Array<Entregable>{
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let entityEntregable = NSEntityDescription.entityForName("Entregable", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "(contrato = %@) AND (recibo = nil)", contract)
        
        request.entity = entityEntregable
        request.predicate = pred
        
        var result:NSArray = []
        
        do{
            try result = context.executeFetchRequest(request)
        }catch{
            print(error)
        }
        
        return result as! Array<Entregable>
    }
    func classifyEntregablesByClient(array: Array<Entregable>) -> Dictionary<Cliente,Array<Entregable>>? {
        
        var entregableDictionary = Dictionary<Cliente,Array<Entregable>>()
        var thisClient:Cliente? = nil
        
        for entregable in array {
            thisClient = entregable.contrato?.cliente
            
            if entregableDictionary.indexForKey(thisClient!) == nil {
                entregableDictionary[thisClient!] = []
            }
            
            entregableDictionary[thisClient!]?.append(entregable)
        }
        
        return entregableDictionary
    }
}
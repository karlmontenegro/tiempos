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
    
    func updateEntregable(nombre: String, tarifa: String, object: Entregable){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let numTarifa = Float(tarifa)
        let num = NSNumber(float: numTarifa!)
        
        object.setValue(nombre, forKey: "nombreEntreg")
        object.setValue(num, forKey: "tarifa")
        
        do{
            try context.save()
        }catch{
            print(error)
        }
        
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
}
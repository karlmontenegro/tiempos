//
//  DAOContrato.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class daoContrato{
    
    func newContract(nombre: String, tipoFact: String, client: Cliente){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let newContract = NSEntityDescription.insertNewObjectForEntityForName("Contrato", inManagedObjectContext: context) 
        
        newContract.setValue(nombre, forKey: "nombreContrato")
        newContract.setValue(tipoFact, forKey: "tipoFacturacion")
        newContract.setValue(true, forKey: "estado")
        newContract.setValue(client, forKey: "cliente")
        
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func deleteContractAt(object: Contrato){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        context.deleteObject(object)
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func updateContract(nombre:String, tipoFact: String, object: Contrato){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        object.setValue(nombre, forKey: "nombreContrato")
        object.setValue(tipoFact, forKey: "tipoFacturacion")
        
        do{
            try context.save()
        }catch{
            print(error)
        }
        
    }
    
    func getContractById(object: Contrato)->Contrato{
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let entityContract = NSEntityDescription.entityForName("Contrato", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "self = %@", object)
        request.entity = entityContract
        
        var result:NSArray = []
        
        do{
            try result = context.executeFetchRequest(request)
        }catch{
            print(error)
        }
        return result[0] as! Contrato
    }
    
    func getAllActiveContracts()->Array<Contrato>{
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let entityContract = NSEntityDescription.entityForName("Contrato", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "(estado = %@)", true)
        
        request.entity = entityContract
        
        var result:NSArray = []
        
        do{
            try result = context.executeFetchRequest(request)
        }catch{
            print(error)
        }
        
        return result as! Array<Contrato>
    }
    
}
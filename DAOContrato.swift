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
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var newContract = NSEntityDescription.insertNewObjectForEntityForName("Contrato", inManagedObjectContext: context) as! NSManagedObject
        
        newContract.setValue(nombre, forKey: "nombreContrato")
        newContract.setValue(tipoFact, forKey: "tipoFacturacion")
        newContract.setValue(true, forKey: "estado")
        newContract.setValue(client, forKey: "cliente")
        
        context.save(nil)
    }
    
    func deleteContractAt(object: Contrato){
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        context.deleteObject(object)
        context.save(nil)
    }
    
    func updateContract(nombre:String, tipoFact: String, object: Contrato){
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        object.setValue(nombre, forKey: "nombreContrato")
        object.setValue(tipoFact, forKey: "tipoFacturacion")
        context.save(nil)
    }
    
    func getContractById(object: Contrato)->Contrato{
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var entityContract = NSEntityDescription.entityForName("Contrato", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "self = %@", object)
        request.entity = entityContract
        
        var result:NSArray = context.executeFetchRequest(request, error: nil)!
        
        return result[0] as! Contrato
    }
    
    func getAllActiveContracts()->Array<Contrato>{
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var entityContract = NSEntityDescription.entityForName("Contrato", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "(estado = %@)", true)
        
        request.entity = entityContract
        
        var result:NSArray = context.executeFetchRequest(request, error: nil)!
        
        return result as! Array<Contrato>
    }
    
}
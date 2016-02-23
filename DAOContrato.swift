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
    
    func genericContract()->Contrato{ //Contrato vacio
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let newContract = NSEntityDescription.insertNewObjectForEntityForName("Contrato", inManagedObjectContext: context)
        
        
        newContract.setValue("", forKey: "nombreContrato")
        newContract.setValue("", forKey: "tipoFacturacion")
        newContract.setValue(true, forKey: "estado")
        newContract.setValue(nil,forKey: "moneda")
        
        do{
            try context.save()
        }catch{
            print(error)
        }
        
        return newContract as! Contrato
    }
    
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
    
    func newContract(nombre:String, tipoFact: String, client: Cliente, entregables: Int, moneda: Moneda){
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let newContract = NSEntityDescription.insertNewObjectForEntityForName("Contrato", inManagedObjectContext: context)
        
        newContract.setValue(nombre, forKey: "nombreContrato")
        newContract.setValue(tipoFact, forKey: "tipoFacturacion")
        newContract.setValue(true, forKey: "estado")
        newContract.setValue(client, forKey: "cliente")
        newContract.setValue(moneda, forKey: "moneda")
        
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
    
    func updateContract(nombre:String, tipoFact: String, moneda: Moneda, client: Cliente?, object: Contrato){
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        object.setValue(nombre, forKey: "nombreContrato")
        object.setValue(tipoFact, forKey: "tipoFacturacion")
        
        if client != nil {
            object.setValue(client, forKey: "cliente")
        }
    
        object.setValue(moneda, forKey: "moneda")
        
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    
    func getAllActiveContracts()->Array<Contrato>{
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let entityContract = NSEntityDescription.entityForName("Contrato", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "(estado = %@)", true)
        
        request.entity = entityContract
        request.predicate = pred
        
        var result:NSArray = []
        
        do{
            try result = context.executeFetchRequest(request)
        }catch{
            print(error)
        }
        
        return result as! Array<Contrato>
    }
    
    func getAllContracts()->Array<Contrato>{
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Contrato")
        
        request.returnsObjectsAsFaults = false
        
        var results:Array<Contrato> = []
        
        do{
            try results = context.executeFetchRequest(request) as! Array<Contrato>
        }catch{
            print(error)
        }
        return results
    }
    
    func getAllContractsByClient(client: Cliente)->Array<Contrato>{
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let entityContract = NSEntityDescription.entityForName("Contrato", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "(estado = %@) AND (cliente = %@)", true, client)
        
        request.entity = entityContract
        request.predicate = pred
        
        var result:NSArray = []
        
        do{
            try result = context.executeFetchRequest(request)
        }catch{
            print(error)
        }
        
        return result as! Array<Contrato>
    }
    
    func getAllActiveContractsPorEntregables()->Array<Contrato>?{
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let entityContract = NSEntityDescription.entityForName("Contrato", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "(estado = %@) AND (tipoFacturacion = %@)", true,"ENT")
        
        request.entity = entityContract
        request.predicate = pred
        
        var result:NSArray = []
        
        do{
            try result = context.executeFetchRequest(request)
        }catch{
            print(error)
        }
        
        return result as? Array<Contrato>
    }
    
    func getAllActiveContractsPorHoras()->Array<Contrato>?{
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let entityContract = NSEntityDescription.entityForName("Contrato", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "(estado = %@) AND (tipoFacturacion = %@)", true,"HRS")
        
        request.entity = entityContract
        request.predicate = pred
        
        var result:NSArray = []
        
        do{
            try result = context.executeFetchRequest(request)
        }catch{
            print(error)
        }
        
        return result as? Array<Contrato>
    }
    
    func getAllActiveContractsPorHorasByClient(client: Cliente)->Array<Contrato>? {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let entityContract = NSEntityDescription.entityForName("Contrato", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "(estado = %@) AND (tipoFacturacion = %@) AND (cliente = %@)", true,"HRS",client)
        
        request.entity = entityContract
        request.predicate = pred
        
        var result:NSArray = []
        
        do{
            try result = context.executeFetchRequest(request)
        }catch{
            print(error)
        }
        
        return result as? Array<Contrato>
    }
    
    func addContratoHorasToContract(ch: ContratoHoras, obj: Contrato) {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        obj.setValue(ch, forKey: "contratoHoras")
        
        do{
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func getAllContractsByClientAndFactType(client: Cliente, tipo: String)->Array<Contrato>{
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let entityContract = NSEntityDescription.entityForName("Contrato", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "(estado = %@) AND (cliente = %@) AND (tipoFacturacion = %@)", true, client, tipo)
        
        request.entity = entityContract
        request.predicate = pred
        
        var result:NSArray = []
        
        do{
            try result = context.executeFetchRequest(request)
        }catch{
            print(error)
        }
        
        return result as! Array<Contrato>
    }
}
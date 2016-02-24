//
//  DAORecibo.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

class daoRecibo{
    
    func createGenericNewInvoice(date: NSDate, client: Cliente?, contract: Contrato?, total: Double?, description:String) -> Recibo?{
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let newInvoice = NSEntityDescription.insertNewObjectForEntityForName("Recibo", inManagedObjectContext: context)
        
        newInvoice.setValue(date, forKey: "fechaEmision")
        newInvoice.setValue(client, forKey: "cliente")
        newInvoice.setValue(contract, forKey: "contrato")
        newInvoice.setValue(total, forKey: "valor")
        newInvoice.setValue(false, forKey: "cobrado")
        newInvoice.setValue(nil, forKey: "fechaCobro")
        newInvoice.setValue("", forKey:  "reciboExterno")
        newInvoice.setValue(description, forKey: "descripcion")
        
        do{
            try context.save()
        }catch{
            print(error)
        }
        return newInvoice as? Recibo
    }
    
    func addEntregablesToInvoice(obj: Recibo, entregables: Array<Entregable>?){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        do{
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func addTiemposToInvoice(obj: Recibo, tiempos: Array<Tiempo>?){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        
        do{
            try context.save()
        } catch {
            print(error)
        }
    }
    
    
    func updateInvoice(obj:Recibo, client: Cliente?, contract: Contrato?, tiempos: Array<Tiempo>?, entregables: Array<Entregable>?, total: Double?) {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        obj.setValue(client, forKey: "cliente")
        obj.setValue(contract, forKey: "contrato")
        obj.setValue(total, forKey: "valor")
        
        
        do{
            try context.save()
        }catch{
            print(error)
        }
        
    }
    
    func deleteInvoice(obj:Recibo) {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        context.deleteObject(obj)
        do{
            try context.save()
        }catch{
            print(error)
        }

    }
    
    func getAllInvoices()->Array<Recibo>? {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Recibo")
        
        request.returnsObjectsAsFaults = false
        
        var results:Array<Recibo> = []
        
        do{
            try results = context.executeFetchRequest(request) as! Array<Recibo>
        }catch{
            print(error)
        }

        return results
    }
    
    func getAllCashedInvoices()->Array<Recibo>? {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let entityInvoice = NSEntityDescription.entityForName("Recibo", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "(cobrado = %@)", true)
        
        request.entity = entityInvoice
        request.predicate = pred
        
        var result:NSArray = []
        
        do{
            try result = context.executeFetchRequest(request)
        }catch{
            print(error)
        }
        
        return result as? Array<Recibo>
    }
    
    func getAllPendingInvoices()->Array<Recibo>? {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let entityInvoice = NSEntityDescription.entityForName("Recibo", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "(cobrado = %@)", false)
        
        request.entity = entityInvoice
        request.predicate = pred
        
        var result:NSArray = []
        
        do{
            try result = context.executeFetchRequest(request)
        }catch{
            print(error)
        }
        
        return result as? Array<Recibo>
    }
    
    func getTiempoListFromInvoice(obj:Recibo)->Array<Tiempo>? {
        var tiempos: Array<Tiempo> = []

        return tiempos
    }
    
    func getEntregablesListFromInvoice(obj:Recibo)->Array<Entregable>?{
        var entregables: Array<Entregable> = []

        return entregables
    }
    
    func cashInvoice(obj:Recibo,date:NSDate) {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        obj.setValue(true, forKey: "cobrado")
        obj.setValue(date, forKey: "fechaCobro")
        
        do{
            try context.save()
        }catch {
            print(error)
        }
    }

}
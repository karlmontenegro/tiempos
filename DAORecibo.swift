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
        
        for ent in entregables! {
            obj.addEntregable(ent)
        }
        
        do{
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func addTiemposToInvoice(obj: Recibo, tiempos: Array<Tiempo>?){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        for tiem in tiempos! {
            obj.addTiempo(tiem)
        }
        
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
        
        if tiempos != nil {
            obj.deleteTiempos()
            for ti in tiempos! {
                obj.addTiempo(ti)
            }
        } else {
            if entregables != nil {
                obj.deleteEntregables()
                for ent in entregables! {
                    obj.addEntregable(ent)
                }
            }
        }
        
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
        return nil
    }

}
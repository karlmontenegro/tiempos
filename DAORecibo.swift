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
    
    func createGenericNewInvoice(date: NSDate, client: Cliente?, contract: Contrato?, total: Double?, moneda: Moneda?,description:String?, dueDate: NSDate) -> Recibo?{
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let newInvoice = NSEntityDescription.insertNewObjectForEntityForName("Recibo", inManagedObjectContext: context)
        
        newInvoice.setValue(date, forKey: "fechaEmision")
        newInvoice.setValue(client, forKey: "cliente")
        newInvoice.setValue(moneda, forKey: "moneda")
        newInvoice.setValue(dueDate, forKey: "fechaVencimiento")
        
        if contract != nil {
            newInvoice.setValue(contract, forKey: "contrato")
        }
        
        newInvoice.setValue(total, forKey: "valor")
        newInvoice.setValue(false, forKey: "cobrado")
        newInvoice.setValue(nil, forKey: "fechaCobro")
        newInvoice.setValue("", forKey:  "reciboExterno")
        
        if description != nil {
            newInvoice.setValue(description, forKey: "descripcion")
        }
        
        do{
            try context.save()
        }catch{
            print(error)
        }
        return newInvoice as? Recibo
    }
    
    func addEntregablesToInvoice(obj: Recibo, entregables: Entregable?){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let newInvoiceDetail = NSEntityDescription.insertNewObjectForEntityForName("ReciboDetalle", inManagedObjectContext: context)
        
        newInvoiceDetail.setValue(obj, forKey: "recibo")
        
        newInvoiceDetail.setValue(1, forKey: "item")
        newInvoiceDetail.setValue(0, forKey: "nroHoras")
        newInvoiceDetail.setValue(0, forKey: "tarifaHoras")
        newInvoiceDetail.setValue(entregables?.tarifa, forKey: "total")
        newInvoiceDetail.setValue(entregables, forKey: "entregable")
        
        do{
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func addTiemposToInvoice(obj: Recibo, tiempos: Array<Tiempo>?){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        var tarifa = 0.0
        
        
        var item = 1
        
        for t in tiempos! {
            
            let newInvoiceDetail = NSEntityDescription.insertNewObjectForEntityForName("ReciboDetalle", inManagedObjectContext: context)
            
            if t.tarifaHoras != 0 {
                tarifa = Double(t.tarifaHoras!)
            } else {
                tarifa = Double((t.contrato?.contratoHoras?.tarifaHora)!)
            }
            
            let interval = t.horas!
            let subtotal = Double(Int(interval)/3600) * tarifa
            
            newInvoiceDetail.setValue(obj, forKey: "recibo")
            newInvoiceDetail.setValue(item, forKey: "item")
            newInvoiceDetail.setValue(t.horas, forKey: "nroHoras")
            newInvoiceDetail.setValue(t.tarifaHoras, forKey: "tarifaHoras")
            newInvoiceDetail.setValue(subtotal, forKey: "total")
            newInvoiceDetail.setValue(t, forKey: "tiempo")
            item += 1
            
            t.setValue(obj, forKey: "recibo")
            t.setValue(true, forKey: "convertido")
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
        let invoiceSortDescriptor = NSSortDescriptor(key: "recibo.fechaVencimiento", ascending: true)
        
        request.sortDescriptors = [invoiceSortDescriptor]
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
        let invoiceSortDescriptor = NSSortDescriptor(key: "fechaVencimiento", ascending: true)
        
        request.sortDescriptors = [invoiceSortDescriptor]
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
        let tiempos: Array<Tiempo> = []

        return tiempos
    }
    
    func getEntregablesListFromInvoice(obj:Recibo)->Array<Entregable>?{
        let entregables: Array<Entregable> = []

        return entregables
    }
    
    func cashInvoice(obj:Recibo, date:NSDate, description: String?) {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        if description != nil {
            obj.setValue(description, forKey: "descripcion")
        }
        
        obj.setValue(true, forKey: "cobrado")
        obj.setValue(date, forKey: "fechaCobro")
        
        do{
            try context.save()
        }catch {
            print(error)
        }
    }

}
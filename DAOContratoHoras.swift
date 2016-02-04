//
//  DAOContratoHoras.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class daoContratoHoras{
    
    func genericContratoHoras()->ContratoHoras{
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let newContratoHoras = NSEntityDescription.insertNewObjectForEntityForName("ContratoHoras", inManagedObjectContext: context)
        
        do{
            try context.save()
        }catch{
            print(error)
        }
        
        return newContratoHoras as! ContratoHoras
    }
    
    func newContratoHoras(nroHoras: Double, horasInc:String, tarifaHora: Double, moneda:Moneda, object: Tiempo){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let newContratoHoras = NSEntityDescription.insertNewObjectForEntityForName("ContratoHoras", inManagedObjectContext: context)
        
        newContratoHoras.setValue(nroHoras, forKey: "totalHoras")
        newContratoHoras.setValue(nil, forKey: "horasInc")
        newContratoHoras.setValue(moneda, forKey: "moneda")
        newContratoHoras.setValue(tarifaHora, forKey: "tarifaHora")
        
        do{
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func deleteAllContractHoras(object: Contrato){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        context.deleteObject(object.contratoHoras!)
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func updateContractHoras(nroHoras: Double?, horasInc:String, tarifaHora: Double, moneda: Moneda, object: ContratoHoras){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        object.setValue(nil, forKey: "horasInc")
        if nroHoras != nil {
            object.setValue(nroHoras, forKey: "totalHoras")
        }else {
            object.setValue(0.0, forKey: "totalHoras")
        }
        object.setValue(tarifaHora, forKey: "tarifaHora")
        object.setValue(moneda, forKey: "moneda")
        
        do{
            try context.save()
        }catch{
            print(error)
        }
        
    }
}

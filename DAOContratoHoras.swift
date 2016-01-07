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
    
    func newContratoHoras(nroHoras: Double, horasInc:String, tarifaHora: Double, moneda:String, object: Tiempo){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let newContratoHoras = NSEntityDescription.insertNewObjectForEntityForName("ContratoHoras", inManagedObjectContext: context)
        
        newContratoHoras.setValue(nroHoras, forKey: "totalHoras")
        newContratoHoras.setValue(nil, forKey: "horasInc")
        newContratoHoras.setValue(moneda, forKey: "moneda")
        newContratoHoras.setValue(tarifaHora, forKey: "tarifaHora")
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
    
    func updateContractHoras(nroHoras: Double, horasInc:String, tarifaHora: Double, moneda: String, object: ContratoHoras){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        object.setValue(nil, forKey: "horasInc")
        object.setValue(nroHoras, forKey: "totalHoras")
        object.setValue(tarifaHora, forKey: "tarifaHora")
        object.setValue(moneda, forKey: "monedaNom")
        
        do{
            try context.save()
        }catch{
            print(error)
        }
        
    }
}

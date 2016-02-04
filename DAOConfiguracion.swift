//
//  DAOConfiguracion.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 4/02/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class daoConfiguracion{
        
    func storeConfig(tarifa: Double?, moneda: Moneda?, obj:Configuracion){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        if tarifa != nil {
            obj.setValue(tarifa, forKey: "defaultTarifaHora")
        }
        obj.setValue(moneda, forKey: "moneda")
        
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func getConfig()->Configuracion?{
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Configuracion")
        
        request.returnsObjectsAsFaults = false
        
        var results:Array<Configuracion> = []
        
        do{
            try results = context.executeFetchRequest(request) as! Array<Configuracion>
        }catch{
            print(error)
        }
        return results[0]
    }
}
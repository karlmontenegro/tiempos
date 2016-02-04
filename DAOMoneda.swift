//
//  DAOMoneda.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

class daoMoneda{
    
    func setActiveCurrency(obj: Moneda){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        obj.setValue(true, forKey: "estado")
        
        do{
            try context.save()
        }catch {
            print(error)
        }
    }
    
    func getAllCurrency()->Array<Moneda>?{
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Moneda")
        
        request.returnsObjectsAsFaults = false
        
        var results:Array<Moneda> = []
        
        do{
            try results = context.executeFetchRequest(request) as! Array<Moneda>
        }catch{
            print(error)
        }
        return results
    }
    
    func getDefaultCurrency()->Moneda {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let entityCurrency = NSEntityDescription.entityForName("Moneda", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "(defaultCurrency = %@)", true)
        
        request.entity = entityCurrency
        request.predicate = pred
        
        var result:NSArray = []
        
        do{
            try result = context.executeFetchRequest(request)
        }catch{
            print(error)
        }
        
        return result[0] as! Moneda
    }
    
    func getCurrencyByID()->Moneda?{
        return nil
    }
}
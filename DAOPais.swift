
//
//  DAOPais.swift
//  Tiempos
//  Created by Isabel Dunin Borkowski on 11/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class daoPais{
    
    //Only one run
    func seedCountries(){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let pais1 = NSEntityDescription.insertNewObjectForEntityForName("Pais", inManagedObjectContext: context)
        
        let pais2 = NSEntityDescription.insertNewObjectForEntityForName("Pais", inManagedObjectContext: context)
        
        pais1.setValue("PE", forKey: "id")
        pais1.setValue("Peru", forKey: "nombrePais")
        pais1.setValue(nil, forKey: "usuarios")
        
        pais2.setValue("BR", forKey: "id")
        pais2.setValue("Brasil", forKey: "nombrePais")
        pais2.setValue(nil, forKey: "usuarios")
        
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func getAllCountries()->NSArray{
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "Pais")
        request.returnsObjectsAsFaults = false;
        
        let results:NSArray = []
        
        do{
            try context.executeFetchRequest(request)
        }catch{
            print(error)
        }
        return results
    }
}
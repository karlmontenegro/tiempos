
//
//  DAOPais.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 11/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class daoPais{
    
    func seedCountries(){
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var pais1 = NSEntityDescription.insertNewObjectForEntityForName("Pais", inManagedObjectContext: context) as! NSManagedObject
        
        var pais2 = NSEntityDescription.insertNewObjectForEntityForName("Pais", inManagedObjectContext: context) as! NSManagedObject
        
        pais1.setValue("PE", forKey: "id")
        pais1.setValue("Peru", forKey: "nombrePais")
        
        pais2.setValue("BR", forKey: "id")
        pais2.setValue("Brasil", forKey: "nombrePais")
        
        context.save(nil)
    }
    
    func getAllCountries()->NSArray{
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Pais")
        request.returnsObjectsAsFaults = false;
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        return results
    }
}
//
//  DAOCliente.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 10/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class daoCliente{
    func getAllClients()->NSArray{
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Cliente")
        request.returnsObjectsAsFaults = false;
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        return results
    }
}
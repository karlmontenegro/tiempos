//
//  Cliente.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 22/09/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

@objc(Cliente)
class Cliente: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    func addAddress(dir: Direccion){
        let addresses = self.mutableSetValueForKey("direccion")
        addresses.addObject(dir)
    }
    
    func allAddresses()->NSSet{
        return self.mutableSetValueForKey("direccion")
    }
}

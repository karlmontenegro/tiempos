//
//  Contrato.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 15/09/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

@objc(Contrato)
class Contrato: NSManagedObject {

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    func addEntregable(e: Entregable){
        let entregables = self.mutableSetValueForKey("entregables")
        entregables.addObject(e)
    }
    
    func allEntregables()->NSSet{
        return self.mutableSetValueForKey("entregables")
    }
}

//
//  Pais.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 12/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

@objc(Pais)
class Pais: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var nombrePais: String
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
}

//
//  Contacto.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 10/09/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

@objc(Contacto)
class Contacto: NSManagedObject {

    @NSManaged var recordRef: NSNumber
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

}

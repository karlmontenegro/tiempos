//
//  Contacto.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

@objc(Contacto)
class Contacto: NSManagedObject {

    @NSManaged var nombreContacto: String
    @NSManaged var infoContacto: NSSet
    @NSManaged var cliente: Cliente

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}

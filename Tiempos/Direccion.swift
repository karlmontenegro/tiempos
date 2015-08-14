//
//  Direccion.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

@objc(Direccion)
class Direccion: NSManagedObject {

    @NSManaged var principal: NSNumber
    @NSManaged var direccion: String
    @NSManaged var cliente: Cliente

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}

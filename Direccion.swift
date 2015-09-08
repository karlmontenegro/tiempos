//
//  Direccion.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 8/09/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

@objc(Direccion)
class Direccion: NSManagedObject {

    @NSManaged var direccion: String
    @NSManaged var principal: NSNumber
    @NSManaged var referenciaUno: String
    @NSManaged var referenciaDos: String
    @NSManaged var cliente: Cliente

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}

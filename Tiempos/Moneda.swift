//
//  Moneda.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

@objc(Moneda)
class Moneda: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var descripcion: String
    @NSManaged var contratoHoras: NSSet
    @NSManaged var entregable: NSSet
    @NSManaged var recibo: NSSet

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}

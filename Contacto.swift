//
//  Contacto.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 15/09/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

@objc(Contacto)
class Contacto: NSManagedObject {

    @NSManaged var recordRef: Int32
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var cliente: Cliente
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

}

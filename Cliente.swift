//
//  Cliente.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 13/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

@objc(Cliente)
class Cliente: NSManagedObject {

    @NSManaged var direccion: String
    @NSManaged var nombre: String
    @NSManaged var razonSocial: String
    @NSManaged var ruc: String
    @NSManaged var usuario: Usuario
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

}

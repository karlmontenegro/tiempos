//
//  Cliente.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

@objc(Cliente)
class Cliente: NSManagedObject {

    @NSManaged var nombre: String
    @NSManaged var razonSocial: String
    @NSManaged var ruc: String
    @NSManaged var usuario: Usuario
    @NSManaged var contacto: NSSet
    @NSManaged var contrato: NSSet
    @NSManaged var direccion: NSSet
    @NSManaged var cita: NSSet
    @NSManaged var tiempo: NSSet
    @NSManaged var recibo: NSSet

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}

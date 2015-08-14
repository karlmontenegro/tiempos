//
//  Usuario.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

@objc(Usuario)
class Usuario: NSManagedObject {

    @NSManaged var apellidos: String
    @NSManaged var email: String
    @NSManaged var fechaAlta: NSDate
    @NSManaged var nombres: String
    @NSManaged var password: String
    @NSManaged var username: String
    @NSManaged var ruc: String
    @NSManaged var nombreSunat: String
    @NSManaged var direccionSunat: String
    @NSManaged var usuarioSol: String
    @NSManaged var claveSol: String
    @NSManaged var clientes: NSSet
    @NSManaged var pais: Pais

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}

//
//  Usuario+CoreDataProperties.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 22/09/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Usuario {

    @NSManaged var apellidos: String?
    @NSManaged var claveSol: String?
    @NSManaged var direccionSunat: String?
    @NSManaged var email: String?
    @NSManaged var fechaAlta: NSDate?
    @NSManaged var nombres: String?
    @NSManaged var nombreSunat: String?
    @NSManaged var password: String?
    @NSManaged var ruc: String?
    @NSManaged var username: String?
    @NSManaged var usuarioSol: String?
    @NSManaged var clientes: NSSet?
    @NSManaged var pais: Pais?

}

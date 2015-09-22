//
//  Cliente+CoreDataProperties.swift
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

extension Cliente {

    @NSManaged var nombre: String?
    @NSManaged var razonSocial: String?
    @NSManaged var ruc: String?
    @NSManaged var cita: NSSet?
    @NSManaged var contacto: NSSet?
    @NSManaged var contrato: NSSet?
    @NSManaged var direccion: NSSet?
    @NSManaged var recibo: NSSet?
    @NSManaged var tiempo: NSSet?
    @NSManaged var usuario: Usuario?

}

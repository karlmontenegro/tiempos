//
//  Contrato.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 15/09/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

@objc(Contrato)
class Contrato: NSManagedObject {

    @NSManaged var nombreContrato: String
    @NSManaged var tipoFacturacion: String
    @NSManaged var estado: NSNumber
    @NSManaged var cita: Cita
    @NSManaged var cliente: Cliente
    @NSManaged var contratoHoras: ContratoHoras
    @NSManaged var entregables: NSSet
    @NSManaged var recibo: NSSet
    @NSManaged var tiempo: NSSet

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}

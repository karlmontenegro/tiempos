//
//  Contrato+CoreDataProperties.swift
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

extension Contrato {

    @NSManaged var estado: NSNumber?
    @NSManaged var nombreContrato: String?
    @NSManaged var tipoFacturacion: String?
    @NSManaged var cita: Cita?
    @NSManaged var cliente: Cliente?
    @NSManaged var contratoHoras: ContratoHoras?
    @NSManaged var entregables: NSSet?
    @NSManaged var recibo: NSSet?
    @NSManaged var tiempo: NSSet?

}

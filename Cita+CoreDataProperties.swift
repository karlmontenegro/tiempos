//
//  Cita+CoreDataProperties.swift
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

extension Cita {

    @NSManaged var convertido: NSNumber?
    @NSManaged var cliente: Cliente?
    @NSManaged var contrato: Contrato?
    @NSManaged var entregable: Entregable?
    @NSManaged var tiempo: Tiempo?
    @NSManaged var eventRef: String?
    @NSManaged var fechaInicio: NSDate?
    @NSManaged var fechaFin: NSDate?

}

//
//  Entregable+CoreDataProperties.swift
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

extension Entregable {

    @NSManaged var nombreEntreg: String?
    @NSManaged var nroHorasInc: NSDate?
    @NSManaged var tarifa: NSNumber?
    @NSManaged var cita: Cita?
    @NSManaged var contrato: Contrato?
    @NSManaged var moneda: Moneda?
    @NSManaged var recibo: Recibo?
    @NSManaged var tiempo: NSSet?

}

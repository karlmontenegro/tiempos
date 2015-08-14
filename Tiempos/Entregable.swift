//
//  Entregable.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

@objc(Entregable)
class Entregable: NSManagedObject {

    @NSManaged var nombreEntreg: String
    @NSManaged var tarifa: NSNumber
    @NSManaged var nroHorasInc: NSDate
    @NSManaged var moneda: Moneda
    @NSManaged var contrato: Contrato
    @NSManaged var cita: Cita
    @NSManaged var tiempo: NSSet
    @NSManaged var recibo: Recibo
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}

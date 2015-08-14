//
//  ContratoHoras.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

@objc(ContratoHoras)
class ContratoHoras: NSManagedObject {

    @NSManaged var tarifaHora: NSNumber
    @NSManaged var horasInc: NSDate
    @NSManaged var moneda: NSManagedObject
    @NSManaged var contrato: Contrato

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}

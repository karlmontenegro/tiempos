//
//  Cita.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

@objc(Cita)
class Cita: NSManagedObject {

    @NSManaged var convertido: NSNumber
    @NSManaged var entregable: NSManagedObject
    @NSManaged var contrato: Contrato
    @NSManaged var cliente: Cliente
    @NSManaged var tiempo: Tiempo

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}

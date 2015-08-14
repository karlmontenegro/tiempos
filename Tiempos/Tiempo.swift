//
//  Tiempo.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

@objc(Tiempo)
class Tiempo: NSManagedObject {

    @NSManaged var titulo: String
    @NSManaged var lugar: String
    @NSManaged var tipoFac: String
    @NSManaged var horaIni: NSDate
    @NSManaged var horaFin: NSDate
    @NSManaged var convertido: NSNumber
    @NSManaged var cita: NSManagedObject
    @NSManaged var contrato: Contrato
    @NSManaged var entregable: NSManagedObject
    @NSManaged var cliente: Cliente
    @NSManaged var recibo: NSManagedObject

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}

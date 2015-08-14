//
//  Recibo.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

@objc(Recibo)
class Recibo: NSManagedObject {

    @NSManaged var reciboExterno: String
    @NSManaged var descripcion: String
    @NSManaged var fechaEmision: NSDate
    @NSManaged var valor: NSNumber
    @NSManaged var cobrado: NSNumber
    @NSManaged var fechaCobro: NSDate
    @NSManaged var tiempo: NSSet
    @NSManaged var cliente: Cliente
    @NSManaged var contrato: Contrato
    @NSManaged var entregable: NSSet
    @NSManaged var moneda: NSManagedObject

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}

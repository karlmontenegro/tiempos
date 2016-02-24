//
//  Recibo+CoreDataProperties.swift
//  
//
//  Created by Isabel Dunin Borkowski on 24/02/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Recibo {

    @NSManaged var cobrado: NSNumber?
    @NSManaged var descripcion: String?
    @NSManaged var fechaCobro: NSDate?
    @NSManaged var fechaEmision: NSDate?
    @NSManaged var reciboExterno: String?
    @NSManaged var valor: NSNumber?
    @NSManaged var cliente: Cliente?
    @NSManaged var moneda: Moneda?
    @NSManaged var reciboDetalle: NSSet?

}

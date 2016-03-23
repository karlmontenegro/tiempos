//
//  Moneda+CoreDataProperties.swift
//  
//
//  Created by Isabel Dunin Borkowski on 4/02/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Moneda {

    @NSManaged var descripcion: String?
    @NSManaged var id: String?
    @NSManaged var defaultCurrency: NSNumber?
    @NSManaged var contratoHoras: NSSet?
    @NSManaged var entregable: NSSet?
    @NSManaged var recibo: NSSet?
    @NSManaged var configuracion: Configuracion?
    @NSManaged var contrato: NSSet?
    @NSManaged var tiempo: Tiempo?
}

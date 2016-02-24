//
//  ReciboDetalle+CoreDataProperties.swift
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

extension ReciboDetalle {

    @NSManaged var item: NSNumber?
    @NSManaged var nroHoras: NSNumber?
    @NSManaged var tarifaHoras: NSNumber?
    @NSManaged var total: NSNumber?
    @NSManaged var contrato: Contrato?
    @NSManaged var entregable: Entregable?
    @NSManaged var recibo: Recibo?
    @NSManaged var contratoHoras: ContratoHoras?

}

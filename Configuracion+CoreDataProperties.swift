//
//  Configuracion+CoreDataProperties.swift
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

extension Configuracion {

    @NSManaged var defaultTarifaHora: NSNumber?
    @NSManaged var moneda: Moneda?

}

//
//  Moneda+CoreDataProperties.swift
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

extension Moneda {

    @NSManaged var descripcion: String?
    @NSManaged var id: String?
    @NSManaged var contratoHoras: NSSet?
    @NSManaged var entregable: NSSet?
    @NSManaged var recibo: NSSet?

}

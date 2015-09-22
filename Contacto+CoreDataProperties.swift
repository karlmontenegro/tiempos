//
//  Contacto+CoreDataProperties.swift
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

extension Contacto {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var recordRef: NSNumber?
    @NSManaged var cliente: Cliente?

}

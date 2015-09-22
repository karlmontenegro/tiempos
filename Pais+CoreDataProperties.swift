//
//  Pais+CoreDataProperties.swift
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

extension Pais {

    @NSManaged var id: String?
    @NSManaged var nombrePais: String?
    @NSManaged var usuarios: NSSet?

}

//
//  InfoContacto.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

@objc(InfoContacto)
class InfoContacto: NSManagedObject {

    @NSManaged var tipo: String
    @NSManaged var valor: String
    @NSManaged var contacto: Contacto

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}

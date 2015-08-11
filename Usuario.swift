//
//  Usuario.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 11/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

class Usuario: NSManagedObject {

    @NSManaged var username: String
    @NSManaged var password: String
    @NSManaged var nombres: String
    @NSManaged var apellidos: String
    @NSManaged var email: String
    @NSManaged var fechaAlta: NSDate
    @NSManaged var pais: NSManagedObject

}

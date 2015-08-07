//
//  ClientesModel.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 7/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import CoreData

@objc(ClientesModel)
class ClientesModel: NSManagedObject {
    
    //Properties feeding the attributes on our model
    //must match our entity's attributes

    @NSManaged var id:Int64
    @NSManaged var idCliente:Int64
    @NSManaged var nombre:String
    @NSManaged var ruc:String
    @NSManaged var razonSocial:String
    @NSManaged var direccion:String
}

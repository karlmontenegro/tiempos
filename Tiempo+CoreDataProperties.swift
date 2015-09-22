//
//  Tiempo+CoreDataProperties.swift
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

extension Tiempo {

    @NSManaged var convertido: NSNumber?
    @NSManaged var horaFin: NSDate?
    @NSManaged var horaIni: NSDate?
    @NSManaged var lugar: String?
    @NSManaged var tipoFac: String?
    @NSManaged var titulo: String?
    @NSManaged var cita: Cita?
    @NSManaged var cliente: Cliente?
    @NSManaged var contrato: Contrato?
    @NSManaged var entregable: Entregable?
    @NSManaged var recibo: Recibo?

}

//
//  ContratoHoras+CoreDataProperties.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 27/10/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ContratoHoras {

    @NSManaged var horasInc: NSDate?
    @NSManaged var tarifaHora: NSNumber?
    @NSManaged var totalHoras: NSNumber?
    @NSManaged var contrato: Contrato?
    @NSManaged var moneda: Moneda?
    @NSManaged var monedaNom: String?
    @NSManaged var reciboDetalle: ReciboDetalle?
}

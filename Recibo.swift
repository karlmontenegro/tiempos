//
//  Recibo.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 22/09/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

@objc(Recibo)
class Recibo: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    func addTiempo(tiempo: Tiempo){
        let tiempos = self.mutableSetValueForKey("tiempo")
        tiempos.addObject(tiempo)
    }
    
    func addEntregable(ent: Entregable){
        let entregables = self.mutableSetValueForKey("entregable")
        entregables.addObject(ent)
    }
    
    func deleteTiempos(){
        let tiempos = self.mutableSetValueForKey("tiempo")
        tiempos.removeAllObjects()
    }
    
    func deleteEntregables(){
        let entregables = self.mutableSetValueForKey("entregable")
        entregables.removeAllObjects()
    }
}

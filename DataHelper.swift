//
//  DataHelper.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 4/02/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

class DataHelper {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func seedCurrency(){
        let monedaList = [(id: "PEN", descripcion: "(S/.)",defaultCurrency: false),
            (id: "USD", descripcion: "($)",  defaultCurrency: false),
            (id: "EUR", descripcion: "(€)",  defaultCurrency: false)]
        
        if self.isCurrencyEmpty() {
            for moneda in monedaList {
                let newMoneda = NSEntityDescription.insertNewObjectForEntityForName("Moneda", inManagedObjectContext: context) as! Moneda
                newMoneda.id = moneda.id
                newMoneda.descripcion = moneda.descripcion
                newMoneda.defaultCurrency = moneda.defaultCurrency
            }
        }
        
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func seedConfig(){
        let newConfig = NSEntityDescription.insertNewObjectForEntityForName("Configuracion", inManagedObjectContext: context) as! Configuracion
        
        newConfig.defaultTarifaHora = 0.00
        newConfig.moneda = nil
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
    }
    
    func isCurrencyEmpty ()->Bool {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let entityContract = NSEntityDescription.entityForName("Moneda", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        
        request.entity = entityContract
        request.returnsObjectsAsFaults = false
        
        var result:Array<Moneda>= []
        
        do{
            try result = context.executeFetchRequest(request) as! Array<Moneda>
        }catch{
            print(error)
        }
        
        return result.isEmpty
    }
}
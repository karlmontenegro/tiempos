//
//  DAOReports.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 20/04/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class daoReports{
    
    func getAllCashedTiempos(start:NSDate, end:NSDate)->Dictionary<String,Double>? {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Tiempo")
        let pred = NSPredicate(format: "(convertido = %@) AND ((contrato.tipoFacturacion = %@) OR (contrato = nil)) AND ((createdAt >= %@) AND (createdAt <= %@))", true,"HRS", start, end)
        
        let contratoSortDescriptor = NSSortDescriptor(key: "contrato.nombreContrato", ascending: true)
        
        let clienteSortDescriptor = NSSortDescriptor(key: "cliente.nombre", ascending: true)
        request.sortDescriptors = [clienteSortDescriptor, contratoSortDescriptor]
        request.predicate = pred
        request.returnsObjectsAsFaults = false
        
        var results:Array<Tiempo> = []
        
        do{
            try results = context.executeFetchRequest(request) as! Array<Tiempo>
        } catch {
            print(error)
        }
        return self.classifyTimesByClient(results)
    }
    
    func classifyTimesByClient(array: Array<Tiempo>) -> Dictionary<String,Double>? {
        
        var timeDictionary = Dictionary<Cliente,Array<Tiempo>>()
        var resultDictionary = Dictionary<String,Double>()
        
        var thisClient:Cliente? = nil
        
        for tiempo in array {
            thisClient = tiempo.cliente
            
            if timeDictionary.indexForKey(thisClient!) == nil {
                timeDictionary[thisClient!] = []
            }
            
            timeDictionary[thisClient!]?.append(tiempo)
        }
        
        let clientArray = timeDictionary.keys
        var totalHours = 0.0
        for c in clientArray {
            for t in timeDictionary[c]! {
                totalHours += Double(t.horas!)
            }
            resultDictionary[c.nombre!] = totalHours
            totalHours = 0.0
        }
        return resultDictionary
    }
    
    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        //let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        
        return String(format: "%02d h %02d m", hours, minutes)
    }
}
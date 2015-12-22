//
//  DAOTiempo.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData

class daoTiempo{
    
    func newTiempo(cliente: Cliente?, contrato: Contrato?, title: String?, fecha: NSDate?, hours: NSNumber, place: String, fact: String, converted: Bool) {
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let newTiempo = NSEntityDescription.insertNewObjectForEntityForName("Tiempo", inManagedObjectContext: context)
        
        newTiempo.setValue(title, forKey: "titulo")
        newTiempo.setValue(converted, forKey: "convertido")
        newTiempo.setValue(hours, forKey: "horas")
        
        newTiempo.setValue(cliente, forKey: "cliente")
        newTiempo.setValue(contrato, forKey: "contrato")
        //newTiempo.setValue(cita.entregable!, forKey: "entregable")
        
        newTiempo.setValue(nil, forKey: "recibo")
        
        do{
            try context.save()
        }catch{
            print(error)
        }
        
        print(newTiempo)
    }
    
    func newTiempo(cita: Cita, title: String, converted: Bool, hours: NSNumber, place:String, fact:String) {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let newTiempo = NSEntityDescription.insertNewObjectForEntityForName("Tiempo", inManagedObjectContext: context)
        
        newTiempo.setValue(title, forKey: "titulo")
        newTiempo.setValue(converted, forKey: "convertido")
        newTiempo.setValue(hours, forKey: "horas")
        newTiempo.setValue(cita, forKey: "cita")
        
        newTiempo.setValue(cita.cliente!, forKey: "cliente")
        newTiempo.setValue(cita.contrato!, forKey: "contrato")
        newTiempo.setValue(cita.entregable!, forKey: "entregable")
        
        newTiempo.setValue(nil, forKey: "recibo")
        
        daoCita().setConvertedStatus(cita, converted: converted)
        
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func updateTiempo(tiempo: Tiempo, cita: Cita, title:String, converted: Bool, hours: NSNumber, place:String, fact: String) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        tiempo.setValue(title, forKey: "titulo")
        tiempo.setValue(converted, forKey: "convertido")
        tiempo.setValue(hours, forKey: "horas")
        tiempo.setValue(cita, forKey: "cita")
        
        tiempo.setValue(cita.cliente!, forKey: "cliente")
        tiempo.setValue(cita.contrato!, forKey: "contrato")
        tiempo.setValue(cita.entregable!, forKey: "entregable")
        
        daoCita().setConvertedStatus(cita, converted: converted)
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func deleteTiempo(tiempo: Tiempo) {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        context.deleteObject(tiempo)
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
}
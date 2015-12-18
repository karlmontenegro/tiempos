//
//  DAOCita.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import EventKit

class daoCita{
    
    //newDate(...data)
    
    //crear la cita en la base de datos
    //crear el evento en el calendario
    //asociar el id del evento con la cita
    
    //guardar la cita
    
    func newDate(nomDate: String, cliente:Cliente, start:NSDate, end:NSDate, contract:Contrato,entregable:Entregable?,activateAlarm:Bool,alarm:EKAlarm?,store:EKEventStore){
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext

        let newCita = NSEntityDescription.insertNewObjectForEntityForName("Cita",inManagedObjectContext: context)
        
        let calEvent:EKEvent? = EKEvent(eventStore:store)
        let calendar:EKCalendar = daoCalendar().getCalendar("Freelo Calendar", store: store)!
        
        newCita.setValue(cliente, forKey: "cliente")
        newCita.setValue(contract, forKey: "contrato")
        newCita.setValue(false, forKey: "convertido")
        
        calEvent?.title = nomDate
        calEvent?.startDate = start
        calEvent?.endDate = end
        calEvent?.calendar = calendar
        calEvent?.notes = "Cliente: " + cliente.nombre! + " Contrato:" + contract.nombreContrato!
        
        if alarm != nil{
            if activateAlarm{
                calEvent?.addAlarm(alarm!)
            }
        }
        
        if entregable != nil{
            newCita.setValue(entregable, forKey: "entregable")
        }
        
        do{
            try store.saveEvent(calEvent!, span: EKSpan.ThisEvent)
        }catch{
            print(error)
        }
        newCita.setValue(calEvent?.eventIdentifier, forKey: "eventRef")
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func setConvertedStatus(cita: Cita, converted:Bool) {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        cita.setValue(converted, forKey: "convertido")
        
        do{
            try context.save()
        }catch {
            print(error)
        }
    }
    
    
    func updateDate(cita: Cita,nomDate:String, cliente:Cliente, start:NSDate, end:NSDate, contract: Contrato,entregable:Entregable?, alarm: EKAlarm?, event: EKEvent){
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        cita.setValue(cliente, forKey: "cliente")
        cita.setValue(contract, forKey: "contrato")
        
        let store:EKEventStore = event.valueForKey("eventStore") as! EKEventStore
        
        event.title = nomDate
        event.startDate = start
        event.endDate = end
        event.notes = "Cliente: " + cliente.nombre! + " Contrato:" + contract.nombreContrato!
        
        
        if alarm != nil{
            event.alarms = []
            event.addAlarm(alarm!)
        }
        
        if entregable != nil {
            cita.setValue(entregable, forKey: "entregable")
        }
        
        do{
            try store.saveEvent(event, span: EKSpan.ThisEvent)
        }catch{
            print(error)
        }
        
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func getDateByEventId(event:EKEvent)->Cita?{
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let entityCita = NSEntityDescription.entityForName("Cita", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "(eventRef = %@)", event.eventIdentifier )
        request.entity = entityCita
        request.predicate = pred
        
        var result:NSArray = []
        
        do{
            try result = context.executeFetchRequest(request)
        }catch{
            print(error)
        }
        if result.count > 0 {
            return result[0] as? Cita
        }else{
            return nil
        }
    }
    
    func getEventByDateId(cita:Cita, store:EKEventStore)->EKEvent? {
        return daoCalendar().getDateById(cita.eventRef!, eventStore: store)
    }
    
    func getUnconvertedDates()->Array<Cita> {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let entityContract = NSEntityDescription.entityForName("Cita", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "(convertido = %@)", false)
        
        request.returnsObjectsAsFaults = false
        request.entity = entityContract
        request.predicate = pred
        
        var result:NSArray = []
        
        do{
            try result = context.executeFetchRequest(request)
        }catch{
            print(error)
        }
        
        return result as! Array<Cita>
    }
    
    func deleteDate(cita:Cita, store:EKEventStore) {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        daoCalendar().deleteEventById(cita.eventRef!, eventStore: store)
        
        context.deleteObject(cita)
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func deleteEventByDateId(event:EKEvent, store:EKEventStore) {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let cita:Cita = self.getDateByEventId(event)!
        
        context.deleteObject(cita)
        
        do{
            try context.save()
        }catch{
            print(error)
        }
        
        daoCalendar().deleteEventById(event.eventIdentifier, eventStore: store)
    }
}
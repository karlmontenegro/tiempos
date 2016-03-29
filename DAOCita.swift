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
    
    func createGenericDate(nomDate: String, calEvent: EKEvent?)->Cita? {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let newGenericCita = NSEntityDescription.insertNewObjectForEntityForName("Cita", inManagedObjectContext: context)
        
        newGenericCita.setValue(nil, forKey: "cliente")
        newGenericCita.setValue(false, forKey: "convertido")
        newGenericCita.setValue(nil, forKey: "contrato")
        newGenericCita.setValue(nil, forKey: "entregable")
        newGenericCita.setValue(calEvent?.eventIdentifier, forKey: "eventRef")
        
        do{
            try context.save()
        }catch{
            print(error)
        }
        
        return newGenericCita as? Cita
    }
    
    func newDate(nomDate: String, cliente:Cliente, start:NSDate, end:NSDate, contract:Contrato?,entregable:Entregable?,activateAlarm:Bool,alarm:EKAlarm?,store:EKEventStore)-> Cita?{
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext

        let newCita = NSEntityDescription.insertNewObjectForEntityForName("Cita",inManagedObjectContext: context)
        
        let calEvent:EKEvent? = EKEvent(eventStore:store)
        let calendar:EKCalendar = daoCalendar().getCalendar("Freelo Calendar", store: store)!
        
        newCita.setValue(cliente, forKey: "cliente")
        
        if contract != nil {
           newCita.setValue(contract, forKey: "contrato")
        }
        
        newCita.setValue(false, forKey: "convertido")
        newCita.setValue(start, forKey: "fechaInicio")
        newCita.setValue(end, forKey: "fechaFin")
        
        calEvent?.title = nomDate
        calEvent?.startDate = start
        calEvent?.endDate = end
        calEvent?.calendar = calendar
        
        if contract != nil {
            calEvent?.notes = "Cliente: " + cliente.nombre! + " Contrato:" + contract!.nombreContrato!
        }
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
        
        return newCita as? Cita
    }
    
    func newDate(nomDate: String, cliente:Cliente, start:NSDate, end:NSDate, contract:Contrato?,entregable:Entregable?,activateAlarm:Bool,alarm:EKAlarm?,store:EKEventStore,converted:Bool)->Cita{
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let newCita = NSEntityDescription.insertNewObjectForEntityForName("Cita",inManagedObjectContext: context)
        
        let calEvent:EKEvent? = EKEvent(eventStore:store)
        let calendar:EKCalendar = daoCalendar().getCalendar("Freelo Calendar", store: store)!
        
        newCita.setValue(cliente, forKey: "cliente")
        
        if contract != nil {
            newCita.setValue(contract, forKey: "contrato")
        }
        newCita.setValue(converted, forKey: "convertido")
        newCita.setValue(start, forKey: "fechaInicio")
        newCita.setValue(end, forKey: "fechaFin")
                
        calEvent?.title = nomDate
        calEvent?.startDate = start
        calEvent?.endDate = end
        calEvent?.calendar = calendar
        
        if contract != nil {
            calEvent?.notes = "Cliente: " + cliente.nombre! + " Contrato:" + contract!.nombreContrato!
        }
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
        return newCita as! Cita
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
    
    
    func updateDate(cita: Cita, nomDate:String, cliente:Cliente, start:NSDate, end:NSDate, contract: Contrato?,entregable:Entregable?, alarm: EKAlarm?, event: EKEvent, eventStore: EKEventStore){
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let store:EKEventStore = event.valueForKey("eventStore") as! EKEventStore
        
        event.title = nomDate
        event.startDate = start
        event.endDate = end
        
        cita.setValue(cliente, forKey: "cliente")
        cita.setValue(start, forKey:  "fechaInicio")
        cita.setValue(end, forKey: "fechaFin")
        
        if contract != nil {
            cita.setValue(contract!, forKey: "contrato")
            event.notes = "Cliente: " + cliente.nombre! + " Contrato:" + contract!.nombreContrato!
        }
        
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
    
    func updateDate(cita: Cita, start:NSDate, end:NSDate) {
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        cita.setValue(start, forKey: "fechaInicio")
        cita.setValue(end, forKey: "fechaFin")
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
    }
    
    func getDateByEventId(event:EKEvent)->Cita?{
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let entityCita = NSEntityDescription.entityForName("Cita", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "eventRef = %@", event.eventIdentifier)
        request.returnsObjectsAsFaults = false
        request.entity = entityCita
        request.predicate = pred
        
        var result:Array<Cita> = []
        
        do{
            try result = context.executeFetchRequest(request) as! Array<Cita>
        }catch{
            print(error)
        }
        
        if result.isEmpty {
            return nil
        } else {
            return result[0]
        }
        
    }
    
    func getEventByDateId(cita:Cita, store:EKEventStore)->EKEvent? {
        return daoCalendar().getDateById(cita.eventRef!, eventStore: store)
    }
    
    func getUnconvertedDates(date:NSDate, store:EKEventStore)->Dictionary<NSDate,Array<Cita>>? {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let entityContract = NSEntityDescription.entityForName("Cita", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "(convertido = %@)", false)
        
        request.returnsObjectsAsFaults = false
        request.entity = entityContract
        request.predicate = pred
        
        var result:Array<Cita>= []
        
        do{
            try result = context.executeFetchRequest(request) as! Array<Cita>
        }catch{
            print(error)
        }
        
        return self.classifyCitasByDate(date, array: result, eventStore: store)
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
    
    func deleteDate(cita:Cita) {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
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
        
        let cita:Cita? = self.getDateByEventId(event)
        
        if cita != nil {
            context.deleteObject(cita!)
            do{
                try context.save()
            }catch{
                print(error)
            }
        }
        daoCalendar().deleteEventById(event.eventIdentifier, eventStore: store)
    }

    //Aux Functions
    
    func classifyCitasByDate(endDate: NSDate, array: Array<Cita>, eventStore: EKEventStore) -> Dictionary<NSDate,Array<Cita>>? {
        
        var citaDictionary = Dictionary<NSDate,Array<Cita>>()
        var dateForThisDay:NSDate? = nil
        
        print(array)
        
        for cita in array {
            dateForThisDay = cita.fechaInicio
            
            if dateForThisDay!.isLessThanDate(endDate) || dateForThisDay!.isToday(){
                if citaDictionary.indexForKey(dateForThisDay!.dateByIgnoringTime()) == nil {
                    citaDictionary[dateForThisDay!.dateByIgnoringTime()] = []
                }
                citaDictionary[dateForThisDay!.dateByIgnoringTime()]?.append(cita)
            }
        }
        
        return citaDictionary
    }
}

extension NSDate {
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: NSTimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}

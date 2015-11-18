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
    
    func newDate(nomDate: String, cliente:Cliente, start:NSDate, end:NSDate, contract:Contrato,activateAlarm:Bool,alarm:EKAlarm,store:EKEventStore){
        
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
        
        if activateAlarm{
            calEvent?.addAlarm(alarm)
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
        print(newCita)
    }
    
    func getDateByEventId(event:EKEvent)->Cita?{
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let entityCita = NSEntityDescription.entityForName("Cita", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "(eventRef = %@)", event.eventIdentifier)
        request.entity = entityCita
        request.predicate = pred
        request.returnsObjectsAsFaults = false
        
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
}
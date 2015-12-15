//
//  DAOCalendar.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 5/11/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import EventKit
import UIKit

class daoCalendar{
    
    func getCalendar(calendarName:String, store:EKEventStore)->EKCalendar?{
        
        let calendarList:[EKCalendar] = store.calendarsForEntityType(EKEntityType.Event)
        
        let cal:EKCalendar? = self.searchCalendarByTitle(calendarName, list: calendarList)
        
        if cal != nil {
            return cal
        }else{
            let calendar = EKCalendar(forEntityType: EKEntityType.Event, eventStore: store)
            
            calendar.title = "Freelo Calendar"
            calendar.source = store.defaultCalendarForNewEvents.source
            
            do{
                try store.saveCalendar(calendar, commit: true)
            }catch{
                print(error)
            }
            return calendar
        }
    }
    
    func addEvent(title: String, start:NSDate, end: NSDate,calendar:EKCalendar, eventStore:EKEventStore){
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = start
        event.endDate = end
        event.calendar = calendar
        
        do{
            try eventStore.saveEvent(event, span: EKSpan.ThisEvent)
        }catch{
            print(error)
        }
    }
    
    func getEventsForDate(date:NSDate,calendar:EKCalendar,eventStore:EKEventStore)->Array<EKEvent>{
        
        let userCalendar = NSCalendar.currentCalendar()
        let endDateComponents = NSDateComponents()
        endDateComponents.year = date.year
        endDateComponents.month = date.month
        endDateComponents.day = date.day
        endDateComponents.hour = 23
        endDateComponents.minute = 59
        endDateComponents.second = 59
        
        let endDate:NSDate = userCalendar.dateFromComponents(endDateComponents)!
        
        let predicate:NSPredicate = eventStore.predicateForEventsWithStartDate(date, endDate: endDate, calendars: [calendar])
        let result:Array<EKEvent> = eventStore.eventsMatchingPredicate(predicate)
        return result
    }
    
    //Aux Functions
    
    func searchCalendarByTitle(title:String, list: [EKCalendar])->EKCalendar?{
        
        for cal in list{
            if (cal.valueForKey("title") as! String) == title {
                return cal
            }
        }
        return nil
    }
    
    func deleteEventById(id:String, eventStore:EKEventStore) {
        let event:EKEvent = eventStore.eventWithIdentifier(id)!
        do {
            try eventStore.removeEvent(event, span: EKSpan.ThisEvent)
        }catch {
            print(error)
        }
    }
    
    func getDateById(id:String,eventStore:EKEventStore)->EKEvent?{
        
        return eventStore.eventWithIdentifier(id)
    }
}

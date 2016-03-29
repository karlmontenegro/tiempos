//
//  DateBatchImport.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 21/03/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import EventKit


class DateBatchImport {
    var eventStore: EKEventStore? = nil
    var calendar: EKCalendar? = nil
    
    init(eS: EKEventStore?, c: EKCalendar?) {
        self.eventStore = eS
        self.calendar = c
    }
    
    func importCalendarDatesToDataBase(months: Int, endDate: NSDate)->Int {
        var list:Array<EKEvent>? = nil
        
        let startDate = endDate.dateByAddingMonths(months)
        let predicate = eventStore?.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: [calendar!])
        var count:Int =  0
        
        list = eventStore?.eventsMatchingPredicate(predicate!) as [EKEvent]!
        
        //list contains all the events from startDate which is endDate - months until endDate
        
        for ev in list! {
            if daoCita().getDateByEventId(ev) == nil {
                let cita = daoCita().createGenericDate(ev.title, calEvent: ev)
                daoCita().updateDate(cita!, start: ev.startDate, end: ev.endDate)
                count += 1
            }
        }
        
        return count
    }
    
    func unsyncedDatesExist(months: Int, endDate: NSDate)->Bool {
        var list:Array<EKEvent>? = nil
        
        let startDate = endDate.dateByAddingMonths(months)
        let predicate = eventStore?.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: [calendar!])
        
        list = eventStore?.eventsMatchingPredicate(predicate!) as [EKEvent]!
        
        //list contains all the events from startDate which is endDate - months until endDate
        
        for ev in list! {
            if daoCita().getDateByEventId(ev) == nil {
                return true
            }
        }
        return false
    }
}
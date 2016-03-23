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
    
    init(eS: EKEventStore, c: EKCalendar) {
        self.eventStore = eS
        self.calendar = c
    }
    
    func importCalendarDatesToDataBase(startDate: NSDate, endDate: NSDate)->Array<EKEvent>? {
        var list:Array<EKEvent>? = nil
        
        let predicate = eventStore?.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: [calendar!])
        
        list = eventStore?.eventsMatchingPredicate(predicate!) as [EKEvent]!
        
        return list
    }
}
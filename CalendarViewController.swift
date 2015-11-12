//
//  CalendarViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 3/11/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//


//TODO

//Conseguir listado de calendarios, si no se encuentra, crear de nuevo el calendario.
//Crear eventos desde la aplicación y setear alertas.

import UIKit
import CoreData
import Foundation
import EventKit

class CalendarViewController: UIViewController,CalendarViewDelegate,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var dateTableView: UITableView!
    @IBOutlet weak var calendarV: UIView!
    
    let calendarName:String = "Freelo Calendar"
    var defaultCalendar:EKCalendar? = nil
    let eventStore = EKEventStore()
    
    var eventArray:Array<EKEvent> = []
    var arreglo:Array<String> = ["2:00 PM","2:30 PM","4:00 PM","5:00 PM"]
    
    override func viewWillAppear(animated: Bool) {
        //Creamos el calendario
        self.defaultCalendar = daoCalendar().getCalendar(calendarName, store: self.eventStore)
        
        let date = NSDate()
        var endDate = date.dateByAddingTimeInterval(2 * 60 * 60)
        
        /*
        
        daoCalendar().addEvent("1", start: date, end: endDate, calendar: self.defaultCalendar!, eventStore: self.eventStore)
        
        endDate = endDate.dateByAddingTimeInterval(2 * 60 * 60)
        
        daoCalendar().addEvent("2", start: date, end: endDate, calendar: self.defaultCalendar!, eventStore: self.eventStore)
        */
        self.eventArray = daoCalendar().getEventsForDate(date, calendar: self.defaultCalendar!, eventStore: self.eventStore)        
    }
    
    override func viewDidLoad() {
        let date = NSDate()
        
        let calendarView = CalendarView.instance(date, selectedDate: date)
        calendarView.delegate = self
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarV.addSubview(calendarView)
        
        // Constraints for calendar view - Fill the parent view.
        calendarV.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
        calendarV.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
        // Do any additional setup after loading the view.
        
        checkAccessForCalendar()
                self.dateTableView.reloadData()
        
    }
    
    func checkAccessForCalendar(){
        
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        
        switch (status) {
            
        case EKAuthorizationStatus.NotDetermined:
            // This happens on first-run
            self.eventStore.requestAccessToEntityType(EKEntityType.Event) { (accessGranted:Bool, error: NSError?) in
                if accessGranted == true {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.dateTableView.reloadData()
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        
                    })
                }
            }

        case EKAuthorizationStatus.Authorized:
            // Things are in line with being able to show the calendars in the table view
            
            self.dateTableView.reloadData()
            
        case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
            // We need to help them give us permission
            break
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelectDate(date: NSDate) {
        print("date selected!")
    }
    
    //Table View Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.eventArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CitaCell", forIndexPath: indexPath)
        
        if !self.eventArray.isEmpty{
            cell.detailTextLabel?.text = self.eventArray[indexPath.row].title
            cell.textLabel?.text = self.eventArray[indexPath.row].startDate.description
        }
        
        return cell
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDateDetail", sender: self)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDateDetail" {
            
        }
    }

}
